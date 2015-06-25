
console.log new Date()

stream = require 'stream'
spawn = require('child_process').spawn
util = require 'util'
split = require 'split'

in1 = new stream.PassThrough #objectMode: true
in2 = new stream.PassThrough objectMode: true

timeIn = null

tran1 = new (class extends stream.Transform

		_transform: (data, encoding, done) ->
			done null, JSON.stringify(data)

	)(objectMode: true, highWaterMark: 2)

pass1 = new stream.PassThrough #objectMode: true, highWaterMark: 3



proc1 = spawn 'cat'#, stdio: [procin, process.stdout, process.stderr]#, cwd: process.cwd()
# console.log util.inspect proc1.stdin._readableState, {depth: 4}
proc1.stdin._writableState.highWaterMark = 0
proc1.stdout._readableState.highWaterMark = 0
# in1.pipe(proc1.stdin)
# proc1.stdout.pipe(out2)



# time based backpressure where object mode doesn't work
# their will be a max delta allowed between the earliest time stamp out and the latest time stamp in


class PressureValve
	write: (data) ->
		if @outStream? and not @leaking
			if @leaking = not @outStream.write data
				console.log 'tube full...'
				@outStream.once 'drain', =>
					@leaking = no
					console.log 'tube drained'

		else
			console.log 'data dropped: '+ JSON.stringify data
			console.log proc1.stdin._writableState.buffer.length


	pipe: (@outStream) -> @outStream



procTran = new (class extends stream.Transform

	constructor: (@maxTimeDelta) ->
		opts =
			objectMode: true
			highWaterMark: 200
		super(opts)
		@proc = spawn 'cat'
		@proc.stdout.pipe(split()).on 'data', (data) =>
			data = JSON.parse data
			@timeOut = data.ts
			if @timeIn - @timeOut < @maxTimeDelta
				@emit 'timeDrain'
			@push data


	_transform: (data, encoding, done) ->
		@timeIn = data.ts
		console.log @timeIn - @timeOut
		@proc.stdin.write JSON.stringify(data)+'\n'
		if @timeIn - @timeOut > @maxTimeDelta
			console.log 'time buffer full'
			@once 'timeDrain', =>
				console.log 'time buffer drain'
				done()
		else
			done()

)(13)









# out1 = new stream.PassThrough readableObjectMode: true#, highWaterMark: 2
out2 = new stream.PassThrough {objectMode: true, highWaterMark: 2}




# out1.on 'data', (data) ->
# 	console.log data
# out1.on 'end', ->
# 	console.log 'done!'
# out1.on 'error', (err) -> console.log err


# in1.pipe(pass1)
# in2.pipe(pass1)

# pass1.pipe(out1)
# pass1.pipe(out2)

# console.log process.cwd()


in3 = new PressureValve
# procin = new stream.Writable





# in3.pipe(tran1).pipe(proc1.stdin)
# proc1.stdout.pipe(out2)

in3.pipe(procTran).pipe(out2)

setInterval ->
	in3.write {ts: Date.now()}
, 10



# setTimeout ->
# out2.on 'data', (data) ->
# 	process.stdout.write JSON.stringify data
# , 10000


# pass1.pipe(pass1)



# proc1.stdout._readableState.highWaterMark = 1
# console.log util.inspect proc1.stdout._readableState

# setTimeout ->
# 	console.log util.inspect proc1.stdout._readableState
# , 2000



# setTimeout ->
# 	in1.write {sig:1}
# , 1000

# setTimeout ->
# 	in2.write {sig:2}
# , 2000

# setTimeout ->
# 	in2.write {sig:3}
# , 3000

# setTimeout ->
# 	in1.write {sig:4}
# , 4000


# setTimeout ->
# 	out1.on 'data', (data) ->
# 		process.stdout.write '1>> '+data#.toString()
# , 10000


# setTimeout ->
# 	out2.on 'data', (data) ->
# 		process.stdout.write data#.toString()
# , 3000


module.exports =
	procTran: procTran

