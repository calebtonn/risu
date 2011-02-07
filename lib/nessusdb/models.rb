# encoding: utf-8

begin
	file = File.open('database.yml')
	yaml = YAML::load(file)
	begin 
		ActiveRecord::Base.establish_connection(yaml) 
	rescue
		puts "[!] Unable to connect to database! Please check your database.yml"
	end
rescue
	puts "[!] Warning database.yml does not exist. Please run nessusdb --create-config to create one."	
end

# normally disabled due to peformance, enable for debugging
#ActiveRecord.colorize_logging = false
#ActiveRecord::Base.logger = Logger.new("db.log")

module NessusDB
	module Models
#		require 'nessusdb/models/host'
#		require 'nessusdb/models/familyselection'
#		require 'nessusdb/models/item'
#		require 'nessusdb/models/individualpluginselection'
#		require 'nessusdb/models/plugin'
#		require 'nessusdb/models/pluginspreference'
#		require 'nessusdb/models/policy'
#		require 'nessusdb/models/report'
#		require 'nessusdb/models/reference'
#		require 'nessusdb/models/serverpreference'
#		require 'nessusdb/models/version'
	end
end
