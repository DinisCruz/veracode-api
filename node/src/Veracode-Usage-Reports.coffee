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

  latest_Usage_Report: =>
    @.scan_History.path_Combine("#{@.latest_Usage_Report_Id()}.csv").file_Contents()

  latest_Usage_Report_Id: =>
    @.scan_History.path_Combine('_latest_report').file_Contents().trim()


module.exports = Veracode_Usage_Reports