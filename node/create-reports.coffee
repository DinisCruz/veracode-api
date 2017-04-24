require 'fluentnode'
Veracode_Usage_Reports = require('./src/Veracode-Usage-Reports')
usage_Reports          = new Veracode_Usage_Reports()

console.log "\n\nCreating Veracode Usage Reports"

using usage_Reports,->
  @.save_Latest_Usage_Report_As_Json =>
    @.create_Report_Stats()
    @.create_Report_Targets()
    console.log "Files in #{@.parsed_History} :"
    console.log @.parsed_History.files().file_Names()

