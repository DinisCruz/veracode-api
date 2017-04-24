Veracode_Scan_Report = require '../src/Veracode-Scan-Report'

describe.only 'Veracode-Usage-Reports', ->
  scan_Report = null

  beforeEach ->
    scan_Report = new Veracode_Scan_Report()

  it 'constructor', ->
    using scan_Report, ->
      @.base_Folder   .assert_Folder_Exists()
      @.reports_Folder.assert_Folder_Exists()
      @.parsed_Reports.assert_Folder_Exists()

  it 'scan_Report_Json', ->
    using scan_Report.scan_Report_Json('account'), ->
      @.json_Parse()['detailedreport']['severity'].size().assert_Is 6

  it 'scan_Report_Xml', ->
    using scan_Report.scan_Report_Xml('account'), ->
      @.assert_Contains "<?xml version"

    assert_Is_Null scan_Report.scan_Report_Xml('aaaa')

  it 'scans', ->
    using scan_Report.scans(), ->
      @.size().assert_Bigger_Than 10
      @.assert_Not_Contains '_scan_history'
      @.assert_Not_Contains '_scan_Reports'
      @.assert_Contains 'account'

  it 'transform_Reports_To_Json',->
    using scan_Report.transform_Reports_To_Json(), ->
      @.size().assert_Bigger_Than 10

