
# base classes

Models =
	_cache: {}


class Models.Thing

	constructor: ->
		@dob = new Date()
		@save()
		Models._cache[@_id] = @

	load: (doc) ->
		for prop of doc
			@[prop] = doc[prop]

	save: ->
		@_id = Things.upsert @doc()

	doc: ->
		doc = {}
		doc._id = @_id
		doc._class = @_class
		return doc


class Models.Greeter extends Models.Thing

	greet: ->
		console.log 'Im '+@myname
		console.log 'I was born '+@dob

	doc: ->
		doc = super()
		doc.myname = @myname
		return doc


# sub class definitions

thingDefinitions = {}

defineThing = (name, def) ->
	if thingDefinitions[name]? then throw new Error("a class defintion for '#{name}' already exists")
	thingDefinitions[name] = def


defineThing 'Thing A', ->
	class extends @Greeter
		myname: 'Alex'

defineThing 'Thing B', ->
	class extends @Greeter
		myname: 'Bob'


for thing of thingDefinitions
	Models[thing] = thingDefinitions[thing].call Models
	Models[thing].prototype._class = thing


# collection

Things =
	count: 0
	_things: []
	upsert: (doc) ->
		if not doc._id?
			doc._id = ++@count
		@_things[doc._id] = JSON.stringify doc
		return doc._id
	find: (id) ->
		@transform JSON.parse @_things[id]
	transform: (doc) ->
		console.log doc
		if not (thing = Models._cache[doc._id])?
			thing = new Models[doc._class]
		thing.load doc
		return thing


######## test

a1 = new Models['Thing A']
a1.greet()
a1.myname = 'Andrew'
id = a1.save()

a2 = Things.find id
a2.greet()

a3 = new Models['Thing A']
a3.greet()



