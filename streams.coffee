
console.log '~'

stream = require 'stream'
spawn = require('child_process').spawn
util = require 'util'

in1 = new stream.PassThrough objectMode: true
in2 = new stream.PassThrough objectMode: true

tran1 = new (class extends stream.Transform

		_transform: () ->


	)(objectMode: true)

pass1 = new stream.PassThrough objectMode: true


out1 = new stream.PassThrough objectMode: true
out2 = new stream.PassThrough objectMode: true, highWaterMark: 0

# out1.on 'data', (data) ->
# 	console.log data
out1.on 'end', ->
	console.log 'done!'
out1.on 'error', (err) -> console.log err


in1.pipe(pass1)
in2.pipe(pass1)

pass1.pipe(out1)
pass1.pipe(out2)

# console.log process.cwd()

console.log new Date()

proc1 = spawn './scratch.sh'#, cwd: process.cwd()
console.log util.inspect proc1.stdout._readableState
proc1.stdout.pipe(out2)

# proc1.stdout._readableState.highWaterMark = 0
console.log util.inspect proc1.stdout._readableState

setTimeout ->
	console.log util.inspect proc1.stdout._readableState
, 2000


# setTimeout ->
# 	in1.write {sig:1}
# , 1000

# setTimeout ->
# 	in2.write {sig:2}
# , 1000

# setTimeout ->
# 	in2.write {sig:3}
# , 1000

# setTimeout ->
# 	in1.write {sig:4}
# , 1000



out1.on 'data', (data) ->
	console.log 'out1:', data.toString()

setTimeout ->
	out2.on 'data', (data) ->
		console.log 'out2:', data.toString()
, 3000
