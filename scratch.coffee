

class Thing
	method: -> console.log 'hey'

thing = new Thing

thing.prop = 0

thing.method()
console.log thing.prop