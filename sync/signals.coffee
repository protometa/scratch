
stream = require 'stream'
shuffle = require 'shuffle-array'
util = require 'util'


logNormRandom = (mean=1, variance=1) ->
	mu = Math.log( mean / Math.sqrt( 1 + variance / mean * mean ))
	sigma = Math.sqrt( Math.log( 1 + variance / mean * mean ))
	Math.exp( mu + sigma * Math.random() )

randomInt = (max) -> Math.floor((Math.random() * max) + 1)

start = Date.now()

class exports.Generator extends stream.Readable

	constructor: (@frameRate=25) ->
		# @deviation is log normal distribution scale factor
		super objectMode: true
		@index = 0
		@devices = ['A', 'B', 'C'].map (name) ->
			device = {name: name}
			device.actualFrame = 0
			device.frameOffset = randomInt(10)
			return device

		frameInterval = 1000/@frameRate

		setInterval =>
			console.log 'master frame:', Date.now() - start

			@devices.forEach (device) =>
				setTimeout =>
					device.actualFrame++
					if not device.dropping
						@push
							device: device.name
							actualFrame: device.actualFrame
							frame: device.actualFrame + device.frameOffset
							time: Date.now() - start
						if Math.random() < .005
							console.log device.name, 'dropping...'
							device.dropping = true
					else
						if Math.random() < .05
							console.log device.name, 'restored...'
							delete device.dropping

				, logNormRandom(25,1)

		, frameInterval


	_read: -> true



class exports.Validator extends stream.Writable

	constructor: ->
		super objectMode: true
		@currentFrameGroup = []
		@currentFrame = 0

	_write: (signal, encoding, done) ->

		console.log signal

		if signal.actualFrame < @currentFrame
			console.warn 'frame is out of order'

		@currentFrame = signal.actualFrame

		if not (@currentFrameGroup.every (existingSignal) -> existingSignal.syncFrame is signal.syncFrame)
			console.assert !!(@currentFrameGroup.reduce (prev, cur) -> if prev.actualFrame is cur.actualFrame then cur else false),
				"current frame group doesnt have the same actual frames: \n#{util.inspect @currentFrameGroup}"
			@currentFrameGroup = []

		@currentFrameGroup.push signal

		done()





