

class Thing

	@classes =
		Thingtest: @

	@cache = {}

	@define = (name, definition) ->
		definition.prototype._class = name
		@classes[name] = definition

	@new = (name) ->
		instance = new @classes[name]
		@cache[instance._id] = instance

	constructor: ->
		@dob = new Date()
		@save()

	load: (doc) ->
		for prop of doc
			@doc[prop] = doc[prop]

	save: ->
		@_id = Things.insert @doc

	greet: ->
		console.log 'Im '+@doc.myname
		console.log 'I was born '+@dob


thingDefinitions = {}

defineThing = (name, definition) ->
	thingDefinitions[name] = definition


defineThing 'Thing A', ->
	class extends @Thingtest
		doc:
			myname: 'Alex'

defineThing 'Thing B', ->
	class extends @Thingtest
		doc:
			myname: 'Bob'


for thing of thingDefinitions
	Thing.classes[thing] = thingDefinitions[thing].call Thing.classes
	Thing.classes[thing].prototype.doc._class = thing


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
		console.log doc
		if not (thing = Thing.cache[doc._id])?
			thing = new Thing.classes[ doc._class ]
		thing.load doc
		return thing


########

jsontest = JSON.stringify Things

a1 = Thing.new 'Thing A'
a1.greet()
a1.doc.myname = 'Andrew'
id = a1.save()

a2 = Things.find id
a2.greet()


