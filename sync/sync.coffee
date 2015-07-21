
console.log new Date()

stream = require 'stream'
signals = require './signals'

class Synchronizer extends stream.Transform

	constructor: ->
		super objectMode: true
		@currentFrameGroup = []
		@currentFrame = 0
		@threshold = 35
		@lastFrameStart = 0

	_transform: (signal, encoding, done) ->

		# if device is already in currentFrameGroup
		# or device is beyond fame time threshold
		if (@currentFrameGroup.some (existing) -> existing.device is signal.device) or signal.time - @lastFrameStart > @threshold

			@currentFrameGroup = []
			@lastFrameStart = signal.time
			@currentFrame++


		signal.syncFrame = @currentFrame
		@currentFrameGroup.push signal

		done null, signal

		



sync = new Synchronizer
geny = new signals.Generator
valid = new signals.Validator

# let it flow
geny.on 'data', ->
geny.pipe sync
sync.pipe(valid)

# listen on pipe at random

# wait = ->
# 	waitTime = Math.floor( Math.random() * 1000 )
# 	console.log 'waiting', waitTime
# 	geny.unpipe()
# 	setTimeout run, waitTime

# run = ->
# 	geny.pipe sync
# 	# setTimeout wait, Math.floor( Math.random() * 2000 )

# wait()





