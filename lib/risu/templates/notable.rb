module Risu
	module Templates
		class Top10 < Risu::Base::TemplateBase
			
			#
			#
			def initialize ()
				@template_info = 
				{ 
					:name => "notable", 
					:author => "hammackj", 
					:version => "0.0.2", 
					:description => "Notable Vulnerabilities"
				}
			end
			
			#
			#
			def render(output)
				output.text Report.classification.upcase, :align => :center
				output.text "\n"

				output.font_size(22) { 
					output.text Report.title, :align => :center 
				}
				
				output.font_size(18) {
					output.text "Notable Vulnerabilities", :align => :center
					output.text "\n"
					output.text "This report was prepared by\n#{Report.author}", :align => :center
				}

				output.text "\n\n\n"
				
				output.text "Scan Date:", :style => :bold
				output.text "#{Report.scan_date}"
				output.text "\n"
				
				Item.top_10_table(output)
				
			end
		end
	end
end
