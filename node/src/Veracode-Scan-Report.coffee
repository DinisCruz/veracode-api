parser = require 'xml2json'


class Veracode_Scan_Report
  constructor: ->
    @.base_Folder    = wallaby?.localProjectDir || '.'.real_Path()
    @.reports_Folder = @.base_Folder      .path_Combine '../../reports'
    @.parsed_Reports = @.reports_Folder   .path_Combine '_scan_Reports'

    if @.reports_Folder.folder_Exists()       # if there is a reports folder, then create the other folders (in case they don't exist)
      @.parsed_Reports.folder_Create()

  scan_Report_Xml: (name)=>
    last_build_id = @.reports_Folder.path_Combine("#{name}/last_build_id")
    if last_build_id.file_Exists()
      report_Xml_File = @.reports_Folder.path_Combine("#{name}/#{last_build_id.file_Contents().trim()}/detailed.xml")
      if report_Xml_File.file_Exists()
        return report_Xml_File.file_Contents()
    return null

  scan_Report_Json: (name)=>
    xml = @.scan_Report_Xml name
    if xml
      return parser.toJson(xml)
    return null

  scans: =>
    @.reports_Folder.folders()
                    .folder_Names()
                    .filter (item)->
                       ['_scan_history', '_scan_Reports'].not_Contains item

  transform_Reports_To_Json: ()=>
    reports = []
    for scan_Name in @.scans()
      report_Json =   @.scan_Report_Json scan_Name
      if report_Json != null
        target_File = @.parsed_Reports.path_Combine("#{scan_Name}.json")
        report_Json.json_Parse().json_Pretty().save_As(target_File)
        if target_File.file_Exists()
          reports.add target_File

    return reports
module.exports = Veracode_Scan_Report

#detailed.xml