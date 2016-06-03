# the desired strategy of dealing with errors to retry requet
desiredStrategy = (err, res) ->
  res and 400 <= res.statusCode and res.statusCode < 600

async = require("async")
request = require('requestretry')

defaulConfig_ = 
    maxAttempts: 10
    retryDelay: 5000
    retryStrategy: desiredStrategy

class DataFetch
    constructor: (urls_) ->
        if Object.prototype.toString.call(urls_) != '[object Array]' 
            @URLs = [urls_]
        else
            @URLs = urls_
        @Config = defaulConfig_
        @Data = ''

    setConfigurations : (config_) =>
        for key of config_
            if @Config.hasOwnProperty(key)
                @Config[key] = config_[key]
        return

    startFetch : (callback) ->
        async.each @URLs, 
            ((url_, cb_) =>
                reqConfig = 
                    method: 'GET'
                    url: url_.toString()
                    maxAttempts: @getConfig().maxAttempts
                    retryDelay: @getConfig().retryDelay
                    retryStrategy: @getConfig().retryStrategy
                    headers:
                        'content-type': 'text/plain'
                request reqConfig, (err, res, dat) =>
                    if !err and res.statusCode >= 200 and res.statusCode < 300
                        @appendData dat
                        console.log 'Data fetched from ', url_
                        cb_()
                    else
                        console.log 'Failed to fetch data from ', url_
                        console.log 'Exiting application!'
                        process.exit -1
            ),
            ((err) =>
                if !err
                    callback @getData()
                else
                    callback null
            )

    getConfig : =>
        return @Config

    getData : =>
        return @Data

    appendData : (dat) =>
        @Data += dat
        return

module.exports = DataFetch