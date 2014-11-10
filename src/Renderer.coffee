### *******************************************************************
	Renderer stuff. 
	Call Renderer.init()
	Create render objs with the classes create method (i.e CircleRenderObj.create 10, 10, 5, "red", 5)
	Call Renderer.fetch().render(canvas) (note, canvas refers to the canvas interface class declared ( Canvas ))
******************************************************************* ###

class Canvas
	constructor: (width=650, height=400, bg_color="#000000") ->
		# Create the canvas and size it
		@canvas = document.createElement 'canvas'
		document.body.appendChild @canvas
		@canvas.height = height
		@canvas.width = width
		@height = @canvas.height
		@width = @canvas.width
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

	fill_style: (color) ->
		@context.fillStyle = color

# Singleton renderer class. Yes, i know, it is a singleton
class Renderer
	constructor: (@clear_color) ->
		# Create an array of 10 layers
		@layers = []
		@layers.push []  for i in [0...10]

	add_obj_to_layer: (obj, layer) ->
		@layers[layer].push obj

	remove_obj: (obj) ->
		for layer in @layers
			for item, i in layer
				if obj is item
					layer.splice(i, 1)
					return 1
		return 0

	render: (canvas) ->
		# clear the canvas
		canvas.fill_rect 0, 0, canvas.width, canvas.height, @clear_color
		# cycle through the render layers and draw all the objects
		for layer in @layers
			for obj in layer
				obj.draw(canvas.context) if obj.is_visible()
		0

	# Static methods
	@fetch: -> @instance
	@init: (clear_color="#000") -> @instance = new Renderer(clear_color)

class RenderObj
	remove_self: ->
		Renderer.fetch().remove_obj(@)
	add_to_renderer: (obj, layer) ->
		Renderer.fetch().add_obj_to_layer obj, layer
	is_visible: ->
		if @visible? then @visible else true

# A circle render object
class CircleRenderObj extends RenderObj
	constructor: (@x, @y, @radius, @color) ->
	@create: (x=0, y=0, radius=10, color="#F0F", layer=0) ->
		obj = new CircleRenderObj x, y, radius, color
		obj.add_to_renderer obj, layer
		obj
	draw: (context) ->
		context.fillStyle = @color
		context.beginPath()
		context.arc @x, @y, @radius, 0, 2*MathEx.pi
		context.fill()
	remove_self: ->
		Renderer.fetch().remove_obj(@)

# A rectangle render object
class RectRenderObj extends RenderObj
	constructor: (@x, @y, @width, @height, @color) ->
	@create: (x, y, width, height, color, layer=0) ->
		obj = new RectRenderObj x, y, width, height, color
		obj.add_to_renderer obj, layer
		obj
	draw: (context) ->
		context.fillStyle = @color
		context.fillRect @x, @y, @width, @height

class TextRenderObj extends RenderObj
	constructor: (@x, @y, @text, @color, @font)->
		@font = TextRenderObj.default_font unless @font
		@color = TextRenderObj.default_color unless @color
	@create: (x, y, text, color, font, layer=0) ->
		obj = new TextRenderObj(x, y, text, color, font)
		obj.add_to_renderer obj, layer
		obj
	draw: (context) ->
		context.font = @font
		context.fillStyle = @color
		context.fillText(@text, @x, @y)
	@default_font: "20px monaco"
	@default_color: "#0F0"
