# Copyright (c) 2010-2013 Arxopia LLC.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the Arxopia LLC nor the names of its contributors
#     	may be used to endorse or promote products derived from this software
#     	without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL ARXOPIA LLC BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
#OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
#OF THE POSSIBILITY OF SUCH DAMAGE.

module Risu
	module Parsers
		module Nessus
			module Rollups
				class Java

					#
					def initialize
						@java_plugins = [
							66932,
							65995, # Needs ver
							56959, # Needs ver
							59462, # Needs ver
							62593, # Needs ver
							45544,
							45379, # Oracle Java SE Multiple Vulnerabilities (March 2010 CPU)
							65050, # Oracle Java JDK/JRE 6 < Update 43 Remote Code Execution (Windows)
							63521,
							65052,
							49996,
							52002,
							54997,
							55958, # Oracle Java JRE Unsupported Version Detection
							56566,
							57290,
							57959,
							64454,
							64790
						]
					end

					def newest_java_plugin
						newest = DateTime.new(0001, 01, 01)

						@java_plugins.each do |id|
							plugin = Plugin.find_by_id(id)

							if plugin.plugin_modification_date >= newest
								newest = plugin.plugin_modification_date
							end
						end

						return newest
					end

					def create_plugin

						plugin = Plugin.find_by_id(-99999)

						if plugin == nil
							plugin = Plugin.new
						end

							plugin.id = -99999
							plugin.plugin_name = "Oracle Java SE Meta Rollup"
							plugin.family_name = "Risu Rollup Plugins"
							plugin.description = ""
							plugin.plugin_version = ""
							plugin.plugin_publication_date = nil
							plugin.plugin_modification_date = nil
							plugin.vuln_publication_date = nil
							plugin.cvss_vector = ""
							plugin.cvss_base_score = ""
							plugin.cvss_temporal_score = ""
							plugin.cvss_temporal_vector = ""
							plugin.risk_factor = ""
							plugin.solution = ""
							plugin.synopsis = ""
							plugin.plugin_type = "Rollup"
							plugin.rollup = true

						plugin.save
					end

					#
					def create_item(host_id, severity)
						item = Item.new

							item.host_id = host_id
							item.plugin_id = -99999
							item.plugin_output = nil
							item.port = 0
							item.severity = severity
							item.plugin_name = "Oracle Java SE Meta Rollup"

						item.save
					end

					#
					def has_java_findings
						@java_plugins.each do |plugin_id|
							if Item.where(:plugin_id => plugin_id)
								return true
							end
						end

						return false
					end

					def calculate_severity current_severity, severity
						#record highest severity for all of the rolled up
						if severity == 4
							return 4
						elsif severity == 3 && current_severity != 4
							return 3
						elsif severity == 2 && current_severity != 4 && current_severity != 3
							return 2
						end
					end

					def clean_up
						if !has_java_findings()
							return
						end

						#Create the dummy plugin
						create_plugin()

						hosts = Host.to_a

						Host.to_a.each do |host|
							finding_severity = 0

							@java_plugins.each do |plugin|
								Item.where(:plugin_id => plugin_id).each do |item|
									severity = item.severity
									item.real_severity = severity
									item.severity = -1
									item.save

									finding_severity = calculate_severity(finding_severity, severity)
								end
							end

							create_item(host.id, finding_severity)
						end


						# @host_list = Hash.new

						# #Set all plugins
						# @java_plugins.each do |plugin_id|
						# 	@current_severity = "None"

						# 	Item.where(:plugin_id => plugin_id).each do |item|
						# 		severity = item.severity
						# 		item.real_severity = severity
						# 		item.severity = -1
						# 		item.save

						# 		#record highest severity for all of the rolled up
						# 		if severity == 4
						# 			@current_severity = 4
						# 		elsif severity == 3 && @current_severity != 4
						# 			@current_severity = 3
						# 		elsif severity == 2 && @current_severity != 4 && @current_severity != 3
						# 			@current_severity = 2
						# 		end

						# 		@host_list[item.host_id] = @current_severity

						# 	end
						# end

						# #Create the rollup plugin
						# create_plugin()

						# #Create 1 finding for each host, flagged with the highest severity for that host
						# @host_list.keys.each do |host_id|
						# 	create_item(host_id, @host_list[host_id])
						# end

					end
				end
			end
		end
	end
end
