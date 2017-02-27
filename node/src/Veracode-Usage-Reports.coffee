Usage_Report = require './models/Usage-Report.model'

require 'fluentnode'

class Veracode_Usage_Reports
  constructor: ->
    @.base_Folder    = wallaby?.localProjectDir || '.'.real_Path()
    @.reports_Folder = @.base_Folder      .path_Combine '../../reports'
    @.scan_History   = @.reports_Folder   .path_Combine '_scan_history'
    @.parsed_History = @.scan_History     .path_Combine '_parsed'

    if @.reports_Folder.folder_Exists()       # if there is a reports folder, then create the other folders (in case they don't exist)
      @.scan_History   .folder_Create()
      @.parsed_History .folder_Create()

  latest_Usage_Report_Csv: =>
    @.scan_History.path_Combine("#{@.latest_Usage_Report_Id()}.csv").file_Contents()

  latest_Usage_Report_Json: =>
    @.parsed_History.path_Combine('usage-reports-raw.json').load_Json()

  latest_Usage_Report_Id: =>
    @.scan_History.path_Combine('_latest_report').file_Contents().trim()

  save_Latest_Usage_Report_As_Json: (callback)=>
    Usage_Report.Parse_Entries @.latest_Usage_Report_Csv(), (data)=>
      target_File = @.parsed_History.path_Combine 'usage-reports-raw.json'
      data.json_Pretty().save_As target_File
      callback target_File

  transform_Usage_Report: =>
    raw_Data = @.latest_Usage_Report_Json()
    report = {}
    console.log raw_Data.first()
    return report


module.exports = Veracode_Usage_Reports