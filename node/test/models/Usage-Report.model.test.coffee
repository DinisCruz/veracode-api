Veracode_Usage_Reports = require '../../src/Veracode-Usage-Reports'
Usage_Report           = require '../../src/models/Usage-Report.model'

describe 'models | Usage-Reports', ->
  usage_Reports = null
  usage_Report  = null

  beforeEach ->
    usage_Reports = new Veracode_Usage_Reports()
    usage_Report  = new Usage_Report()

  it 'constructor', ->
    using usage_Report, ->
      @._keys().assert_Is ['Account','Enterprise','App','App ID','Version','Version ID','Is Latest Pub Build','Analysis Type','Vsa','Business Unit','Business Owner','Business Owner Email','Archer Name','Language','Version Created','Submitted','Published','Published To Enterprise','Next Build Published','Business Days To Publish','Met SLO','Policy','Policy Compliance','Min Required Level','Published Level','Mitigated Level','Score','Mitigated Score','Rating','Published Rating','Mitigated Rating','Assess Type','Assurance Level','Lifecycle Stage','Tags','Vendor','Bytes Uploaded','KB Uploaded','Analysis Size KB','Lines Of Code','Dyn Scan Window Requested','Dyn Scan Window Start','Dyn Scan Window Stop','Dyn Scan Start','Dyn Scan Stop','Elapsed Dyn Days','Dyn Links Visited','Flaws','Very High Flaws','High Flaws','Medium Flaws','Low Flaws','Very Low Flaws','Api Abuse','Authentication Issues','Command Or Argument Injection','Credentials Management','Crlf Injection','cross-site scripting (xss)','Cryptographic Issues','Deployment Configuration','Directory Traversal','Encapsulation','Error Handling','Information Leakage','Insecure Dependencies','Insufficient Input Validation','Race Conditions','Server Configuration','Session Fixation','Sql Injection','Time And State','Untrusted Initialization','Untrusted Search Path','New Flaws','Flaws From Prev Build','Flaws Remediated','Flaws Regressed','Flaws Mitigated','Owasptext Flaws','Count Of Fix For Policy Flaws','Teams','Custom 1','Custom 2','Custom 3','Custom 4','Custom 5','Deployment Method','Submitter Name','Submitter Email','Submitted By Api Account','Custom 6','Custom 7','Custom 8','Custom 9','Custom 10','Custom 11','Custom 12','Custom 13','Custom 14','Custom 15','Custom 16','Custom 17','Custom 18','Custom 19','Custom 20','Custom 21','Custom 22','Custom 23','Custom 24','Custom 25']


  it 'Parse_Entry', (done)->
    report_Raw = usage_Reports.latest_Usage_Report()
    csv_Data   = report_Raw.split_Lines().second()
    Usage_Report.Parse_Entry csv_Data, (data)->
      data.values().assert_Is csv_Data.split(',')
      data._keys().size().assert_Is 111
      done()

  it 'Parse (bad data)', (done)->
    Usage_Report.Parse_Entry null, (data)->
      assert_Is_Null data
      Usage_Report.Parse_Entry "", (data)->
        assert_Is_Null data
        Usage_Report.Parse_Entry "this,\"line\",is,invalid h\"ere\"", ()->
          console.log data
          done()


  it 'Parse_File', ->
    console.log '...'

