# stormbolt API endpoints

@include = ->

    agent = @settings.agent

    @get '/clients': ->
        @send agent.clients.list()

    @get '/clients/:id': ->
        match = agent.clients.get @params.id
        if match?
            @send match
        else
            @send 404

    # proxy operation for stormflash requests
    @all '/proxy/:id@:port/*': ->
        bolt = agent.clients.entries[@params.id]
        port = (Number) @params.port
        if bolt? and bolt.relay? and port in bolt.capability
            @req.target = port
            @req.url = @params[0]
            # pipes @req stream via bolt back up to @res stream
            bolt.relay @req, @res
        else
            @send 404
