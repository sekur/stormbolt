@include = ->

    cloudflashbolt = require('./boltlib')
    bolt = new cloudflashbolt    
    bolt.configure (res) =>
        if res instanceof Error
             console.log 'error: ' + res
    
    @get '/*': -> 
        console.log 'IN GET' + @request.path
        if @request.path == '/cname'
            bolt.listBoltClients (res) =>
                unless res instanceof Error
                    @send res
                else
                    @next res
        else
            bolt.sendDataToClient @request, (res) =>                
                resData = JSON.parse res                
                @response.status(resData.status)
                # commented for now as issues seen with express version
                #@response.set(resData.headers)
                console.log 'resData.data: ' + resData.data
                if resData.status == 200 || resData.status == 204 || resData.status == 202
                    @send resData.data
                else
                    console.log 'in else' + JSON.stringify resData                    
                    @next resData.data                
                   

    @post '/*': ->        
        console.log 'IN POST'        
        bolt.sendDataToClient @request, (res) =>
            resData = JSON.parse res                
            @response.status(resData.status)
            #@response.set(resData.headers)
            if resData.status == 200 || resData.status == 204 || resData.status == 202
                @send resData.data
            else
                console.log 'in else'
                @next resData.data 
    @put '/*': ->        
        console.log 'IN PUT'        
        bolt.sendDataToClient @request, (res) =>
            resData = JSON.parse res                
            @response.status(resData.status)
            #@response.set(resData.headers)
            if resData.status == 200 || resData.status == 204 || resData.status == 202
                @send resData.data
            else
                console.log 'in else'
                @next resData.data 

    @del '/*': ->        
        console.log 'IN DEL'        
        bolt.sendDataToClient @request, (res) =>
            resData = JSON.parse res                
            @response.status(resData.status)
            #@response.set(resData.headers)
            if resData.status == 200 || resData.status == 204 || resData.status == 202
                @send resData.data
            else
                console.log 'in else'
                @next resData.data 
