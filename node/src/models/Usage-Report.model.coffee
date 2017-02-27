csv = require('csv');

class Usage_Report

  constructor: ->
    @['Account']              = ''
    @['Enterprise']           = ''
    @['App']                  = ''
    @['App ID']               = ''
    @['Version']              = ''
    @['Version ID']           = ''
    @['Is Latest Pub Build']  = ''
    @['Analysis Type']        = ''
    @['Vsa']                  = ''
    @['Business Unit']        = ''
    @['Business Owner']       = ''
    @['Business Owner Email'] = ''
    @['Archer Name']          = ''
    @['Language']             = ''
    @['Version Created']      = ''
    @['Submitted']            = ''
    @['Published']            = ''
    @['Published To Enterprise']  = ''
    @['Next Build Published']     = ''
    @['Business Days To Publish'] = ''
    @['Met SLO']              = ''
    @['Policy']               = ''
    @['Policy Compliance']    = ''
    @['Min Required Level']   = ''
    @['Published Level']      = ''
    @['Mitigated Level']      = ''              # todo: format the rest of these
    @['Score']         = ''
    @['Mitigated Score']         = ''
    @['Rating']         = ''
    @['Published Rating']         = ''
    @['Mitigated Rating']         = ''
    @['Assess Type']         = ''
    @['Assurance Level']         = ''
    @['Lifecycle Stage']         = ''
    @['Tags']         = ''
    @['Vendor']         = ''
    @['Bytes Uploaded']         = ''
    @['KB Uploaded']         = ''
    @['Analysis Size KB']         = ''
    @['Lines Of Code']         = ''
    @['Dyn Scan Window Requested']         = ''
    @['Dyn Scan Window Start']         = ''
    @['Dyn Scan Window Stop']         = ''
    @['Dyn Scan Start']         = ''
    @['Dyn Scan Stop']         = ''
    @['Elapsed Dyn Days']         = ''
    @['Dyn Links Visited']         = ''
    @['Flaws']         = ''
    @['Very High Flaws']         = ''
    @['High Flaws']         = ''
    @['Medium Flaws']         = ''
    @['Low Flaws']         = ''
    @['Very Low Flaws']         = ''
    @['Api Abuse']         = ''
    @['Authentication Issues']         = ''
    @['Command Or Argument Injection']         = ''
    @['Credentials Management']         = ''
    @['Crlf Injection']         = ''
    @['cross-site scripting (xss)']         = ''
    @['Cryptographic Issues']         = ''
    @['Deployment Configuration']         = ''
    @['Directory Traversal']         = ''
    @['Encapsulation']         = ''
    @['Error Handling']         = ''
    @['Information Leakage']         = ''
    @['Insecure Dependencies']         = ''
    @['Insufficient Input Validation']         = ''
    @['Race Conditions']         = ''
    @['Server Configuration']         = ''
    @['Session Fixation']         = ''
    @['Sql Injection']         = ''
    @['Time And State']         = ''
    @['Untrusted Initialization']         = ''
    @['Untrusted Search Path']         = ''
    @['New Flaws']         = ''
    @['Flaws From Prev Build']         = ''
    @['Flaws Remediated']         = ''
    @['Flaws Regressed']         = ''
    @['Flaws Mitigated']         = ''
    @['Owasptext Flaws']  = ''
    @['Count Of Fix For Policy Flaws'] = ''
    @['Teams']             =  ''
    @['Custom 1']          = ''
    @['Custom 2']          = ''
    @['Custom 3']          = ''
    @['Custom 4']          = ''
    @['Custom 5']          = ''
    @['Deployment Method'] = ''
    @['Submitter Name']    = ''
    @['Submitter Email']   = ''
    @['Submitted By Api Account']      = ''
    @['Custom 6']          = ''
    @['Custom 7']          = ''
    @['Custom 8']          = ''
    @['Custom 9']          = ''
    @['Custom 10']         = ''
    @['Custom 11']         = ''
    @['Custom 12']         = ''
    @['Custom 13']         = ''
    @['Custom 14']         = ''
    @['Custom 15']         = ''
    @['Custom 16']         = ''
    @['Custom 17']         = ''
    @['Custom 18']         = ''
    @['Custom 19']         = ''
    @['Custom 20']         = ''
    @['Custom 21']         = ''
    @['Custom 22']         = ''
    @['Custom 23']         = ''
    @['Custom 24']         = ''
    @['Custom 25']         = ''


Usage_Report.Parse_Entry = (csv_Data, callback)->

  return callback null if not csv_Data        # send null if there no data passed
  csv.parse csv_Data, (err, data)->
    if err or data.length < 1
      callback null                           # or there was an error with parsing
    else
      usage_Report = new Usage_Report()       # create Usage_Report
      fields       = usage_Report._keys()     # get is fields

      for item, index  in data.first()        # for each csv value
        usage_Report[fields[index]] = item    # assign it to Usage_Report (note that this is depending on the correct order

      callback usage_Report                   # send object create as callback

Usage_Report.Parse_File = (file, callback)->
  if not (file?.file_Not_Exists())
    callback null
  else
    callback {}

module.exports = Usage_Report