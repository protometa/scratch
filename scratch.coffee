

class Thing
	@classes = {}
	constructor: ->
		@save()
	load: (doc) ->
		for prop of doc
			@[prop] = doc[prop]
	save: ->
		doc = {}
		for prop of @
			doc[prop] = @[prop]
		@_id = Things.insert doc
		
Thing.classes.A = class extends Thing
	_class: 'A'
	name: 'Alex'
	greet: ->
		console.log 'im '+@name

Thing.classes.B = class extends Thing
	_class: 'B'
	name: 'Bob'
	greet: ->
		console.log 'im '+@name

Things =
	count: 0
	_things: []
	insert: (doc) ->
		doc._id ?= ++@count
		@_things[doc._id] = JSON.stringify doc
		return doc._id
	find: (id) ->
		@transform JSON.parse @_things[id]
	transform: (doc) ->
		thing = new Thing.classes[ doc._class ]
		thing.load doc
		return thing


########

jsontest = JSON.stringify Things

a1 = new Thing.classes.A
a1.greet()
a1.name = 'Andrew'
id = a1.save()

a2 = Things.find id
a2.greet()


