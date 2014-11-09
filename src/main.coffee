## Currently a wrapper for javascripts default math library
class MathEx
	@acos: Math.acos
	@asin: Math.asin
	@atan: Math.atan
	@atan2: Math.atan2
	@cos: Math.cos
	@deg2rad: Math.PI / 180
	@pi: Math.PI
	@rad2deg: 180 / Math.PI
	@sin: Math.sin
	@tan: Math.tan

## A class for performing operations with 2 dimensional vectors
class Vec2
	## Methods
	constructor: (@x=0, @y=0) ->
	mag: -> Math.sqrt(@x**2 + @y **2)
	scale: (x, y) ->
		if y? then @x *= x; @y *= y
		else @x *= x.x; @y *= x.y
	normalize: ->
		mag = @mag()
		@x = @x/mag; @y = @y/mag
		mag
	rotate: (radians) ->
		sin = MathEx.sin(radians)
		cos = MathEx.cos(radians)
		x = @x; y = @y
		@x = cos * x - sin * y
		@y = sin * x + cos * y
		@
	rotation: -> Math.atan2(@y, @x)
	set: (x, y) ->
		if y? then @x = x; @y = y
		else @x = x.x; @y = x.y
		@
	to_string: -> @x + ", " + @y

	## Static Methods
	@add: (lhs, rhs) -> new Vec2(lhs.x + rhs.x, lhs.y + rhs.y)
	@div: (lhs, rhs) -> new Vec2(lhs.x / rhs.x, lhs.y / rhs.y)
	@mul: (lhs, rhs) -> new Vec2(lhs.x * rhs.x, lhs.y * rhs.y)
	@sub: (lhs, rhs) -> new Vec2(lhs.x - rhs.x, lhs.y - rhs.y)
	@dot: (lhs, rhs) -> lhs.x * rhs.x + lhs.y + rhs.y
	@angle_between: (lhs, rhs) -> lhs.rotation() - rhs.rotation()

class Canvas
	constructor: (width=650, height=400, bg_color="#000000") ->
		# Create the canvas and size it
		@canvas = document.createElement 'canvas'
		document.body.appendChild @canvas
		@canvas.height = height
		@canvas.width = width
		# Get the drawing context from the canvas
		@ctx = @canvas.getContext '2d'
		@context = @ctx
		@fill_rect(0, 0, width, height, bg_color)

	fill_rect: (x, y, width, height, color="#000") ->
		@ctx.fillStyle = color
		@ctx.fillRect(x, y, width, height)

	fill_circle: (x, y, r, color="#000") ->
		@ctx.fillStyle = color
		@ctx.beginPath()
		@ctx.arc(x, y, r, 0, 2*MathEx.pi)
		@ctx.fill()

class window.Game
	constructor: ->
		@canvas = new Canvas(650, 400, "#000")

		Renderer.init()
		CircleRenderObj.create 10, 35, 30, "rgba(0, 0, 255, 0.5)", 7
		CircleRenderObj.create 20, 10, 10, "red", 5
		CircleRenderObj.create 40, 70, 25, "green", 5
		CircleRenderObj.create 0, 0, 200, "yellow", 3

		@loop() # Enter the game loop

	# The main game loop
	loop: =>
		Renderer.fetch().render(@canvas)
		setTimeout @loop, 20

### *******************************************************************
	Renderer stuff. 
	Call Renderer.init()
	Create render objs with the classes create method (i.e CircleRenderObj.create 10, 10, 5, "red", 5)
	Call Renderer.fetch().render(canvas) (note, canvas refers to the canvas interface class declared ( Canvas ))
******************************************************************* ###

# Singleton renderer class. Yes, i know, it is a singleton
class Renderer
	constructor: (@clear_color) ->
		# Create an array of 10 layers
		@layers = []
		@layers.push []  for i in [0...10]
	@init: (clear_color="#000") -> @instance = new Renderer(clear_color)
	@fetch: -> @instance
	add_obj_to_layer: (obj, layer) ->
		@layers[layer].push obj
	render: (canvas) ->
		canvas.context.fillStyle = @clear_color
		canvas.context.fillRect 0, 0, canvas.canvas.width, canvas.canvas.height
		for layer in @layers
			for obj in layer
				obj.draw(canvas.context) if obj.visible
		0

# A circle render object
class CircleRenderObj
	constructor: (@x, @y, @radius, @color) ->
		@visible = true
	@create: (x=0, y=0, radius=10, color="#F0F", layer=0) ->
		obj = new CircleRenderObj x, y, radius, color
		renderer = Renderer.fetch()
		renderer.add_obj_to_layer obj, layer
		obj
	draw: (context) ->
		context.fillStyle = @color
		context.beginPath()
		context.arc @x, @y, @radius, 0, 2*MathEx.pi
		context.fill()

# A rectangle render object
class RectRenderObj
	constructor: (@x, @y, @width, @height, @color) ->
		@visible = true
	@create: (x, y, width, height, color, layer=0) ->
		obj = new RectRenderObj x, y, width, height, color
		renderer = Renderer.fetch()
		renderer.add_obj_to_layer obj, layer
		obj
	draw: (context) ->
		context.fillStyle = @color
		context.fillRect @x, @y, @width, @height

