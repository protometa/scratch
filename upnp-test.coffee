
util = require 'util'
ssdp = require 'node-ssdp'
request = require 'request'
XML = require 'pixl-xml'

ssdpc = new ssdp.Client

ssdpc.on 'response', (headers, status, rinfo) ->
	# console.log headers
	request headers.LOCATION, (err, res) ->
		if err then return console.error err
		try
			info = XML.parse res.body.replace /\r*\n/g, ''
			# console.log info
		catch err
			return console.error err
		if info.device.modelName is 'SNV-6012M'
			console.log "#{info.device.friendlyName} @ #{info.device.presentationURL}"

console.log 'Searching for SAMSUNG SNV-6012M cameras...'
ssdpc.search('urn:schemas-upnp-org:service:WANIPConnection:1');



# ssdps = new ssdp.Server

# ssdps.addUSN('upnp:rootdevice')

# ssdps.on 'advertise-alive', (headers) ->
# 	console.log 'alive'
# 	console.log util.inspect headers

# ssdps.on 'advertise-bye', (headers) ->
# 	console.log 'bye'

# ssdps.start()

# process.on 'exit', ->
# 	console.log 'stopping'
# 	server.stop()

