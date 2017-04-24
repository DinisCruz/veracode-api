parser = require 'xml2json'

require 'fluentnode'

class Veracode_Scan_Report
  constructor: ->
    @.base_Folder    = wallaby?.localProjectDir || '.'.real_Path()
    @.reports_Folder = @.base_Folder      .path_Combine '../../reports'
    @.scan_Reports   = @.reports_Folder   .path_Combine '_scan_Reports'
    @.parsed_Reports = @.scan_Reports     .path_Combine 'parsed_Xml'


    if @.reports_Folder.folder_Exists()       # if there is a reports folder, then create the other folders (in case they don't exist)
      @.scan_Reports  .folder_Create()
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
      return parser.toJson(xml, object: true)
    else
      console.log "failed toload #{name}"
    return null

  scans: =>
    @.reports_Folder.folders()
                    .folder_Names()
                    .filter (item)->
                       ['_scan_history', '_scan_Reports'].not_Contains item

  transform_Reports_To_Json: ()=>
    reports = []
    for scan_Name in @.scans()
      target_File = @.parsed_Reports.path_Combine("#{scan_Name}.json")

      xml_Checksum = @.scan_Report_Xml(scan_Name).checksum()

      if target_File.file_Contents() is null or target_File.file_Contents().not_Contains xml_Checksum    # skip if report has already been calculated
        report_Json =   @.scan_Report_Json scan_Name
        if report_Json != null
          report_Json.xml_Checksum = xml_Checksum                 # add xml_Checksum to saved json file
          report_Json.json_Pretty().save_As(target_File)
      if target_File.file_Exists()
        reports.add target_File

    return reports

  create_Report_Stats: ()=>
    target_File = @.scan_Reports.path_Combine 'stats.json'

    stats =
      number_of_Scans     : 0       #
      uploaded_Kb         : 0       # KB Uploaded
      analysis_bytes      : 0       # Analysis Size KB
      analysis_Mb         : 0       # Analysis Size KB
      lines_of_code       : 0       # Lines Of Code
      flaws_total         : 0       # detailedreport.total_flaws
      flaws_not_mitigated : 0       # flaws_not_mitigated
      flaws_very_high     : 0       # detailedreport['static-analysis'].modules.module.numflawssev5
      flaws_high          : 0       # detailedreport['static-analysis'].modules.module.numflawssev4
      flaws_medium        : 0       # detailedreport['static-analysis'].modules.module.numflawssev3
      flaws_low           : 0       # detailedreport['static-analysis'].modules.module.numflawssev2
      flaws_very_low      : 0       # detailedreport['static-analysis'].modules.module.numflawssev1

    for scan_Name in @.scans() #.splice(1) #.take(10)
      scan_File = @.parsed_Reports.path_Combine("#{scan_Name}.json")
      scan_Data = scan_File.load_Json()
      if not scan_Data.detailedreport
        console.log  scan_Name
      if scan_Data.detailedreport
        using stats, ->
          @.number_of_Scans++
          @.flaws_total         += Number scan_Data.detailedreport.total_flaws
          @.flaws_not_mitigated += Number scan_Data.detailedreport.flaws_not_mitigated
          @.analysis_bytes      += Number scan_Data.detailedreport['static-analysis'].analysis_size_bytes
          for module in scan_Data.detailedreport['static-analysis'].modules.module
            @.flaws_very_high   += Number module.numflawssev5
            @.flaws_high        += Number module.numflawssev4
            @.flaws_medium      += Number module.numflawssev3
            @.flaws_low         += Number module.numflawssev2
            @.flaws_very_low    += Number module.numflawssev1

          #console.log module
          #console.log severity.level

      #console.log scan_Data
    stats.analysis_Mb =  Math.floor(stats.analysis_bytes / (1024 * 1024))
    stats.json_Pretty().save_As target_File
    return target_File

module.exports = Veracode_Scan_Report

#detailed.xml