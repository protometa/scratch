

arr = [{a:1},{a:1},{a:1},{a:1}]

# console.assert !!(arr.reduce (prev, cur) ->
# 	console.log 'sdfs'
# 	if prev.a is cur.a then cur.a else false

# 	), 'not uniform'


console.log !!(arr.reduce (prev, cur) ->
	console.log prev.a, cur.a
	if prev.a is cur.a then cur else false)

