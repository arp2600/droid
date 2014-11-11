
# Singleton renderer class. Yes, i know, it is a singleton
class Renderer

	@render: () ->
		# clear the canvas
		@context.setTransform(1,0,0,1,0,0)
		@context.fillStyle = @clear_color
		@context.fillRect 0, 0, @canvas.width, @canvas.height
		# cycle through the render layers and draw all the objects
		for layer, i in @layers
			view = @transforms[i]
			for obj in layer
				model_view = @create_model_view(obj, view)
				mat = model_view.mat
				@context.setTransform(mat[0], mat[3], mat[1], mat[4], mat[2], mat[5])
				obj.draw(@context) if obj.is_visible()
		0

	@create_model_view: (obj, view) ->
		model = new Mat3X3()
		modified = false
		if obj?.scale
			model.scale(obj.scale.x, obj.scale.y)
			modified = true
		if obj?.rotation
			model.rotate(obj.rotation)
			modified = true
		if obj?.pos
			model.translate(obj.pos.x, obj.pos.y)
			modified = true
		if modified
			return Mat3X3.mul(view, model)
		else
			return view

	# Static methods
	@init: (width, height, clear_color) ->
		@clear_color = clear_color
		# Create the canvas and size it
		@canvas = document.createElement 'canvas'
		document.body.appendChild @canvas
		@canvas.height = height
		@canvas.width = width
		@height = @canvas.height
		@width = @canvas.width
		# Get the drawing context from the canvas
		@context = @canvas.getContext '2d'
		# Create an array of 10 layers
		@layers = []
		@layers.push []  for i in [0...10]
		# Each layer needs a transform
		view = new Mat3X3()
		view.scale(1, -1)
		view.translate(@width*0.5, @height*0.5)
		view.scale(@height*0.5, @height*0.5)
		@transforms = []
		@transforms.push view for i in [0...8]
		@transforms.push new Mat3X3() for i in [8...10]

	@add_obj_to_layer: (obj, layer) ->
		@layers[layer].push obj

	@remove_obj: (obj) ->
		for layer in @layers
			for item, i in layer
				if obj is item
					layer.splice(i, 1)
					return 1
		return 0

class RenderObj
	remove_self: ->
		Renderer.remove_obj(@)
	add_to_renderer: (obj, layer) ->
		Renderer.add_obj_to_layer obj, layer
	is_visible: ->
		if @visible? then @visible else true

# A circle render object
class CircleRenderObj extends RenderObj
	constructor: (@pos, @radius, @color) ->
	@create: (pos=new Vec2(), radius=10, color="#F0F", layer=0) ->
		obj = new CircleRenderObj pos, radius, color
		obj.add_to_renderer obj, layer
		obj
	draw: (context) ->
		context.fillStyle = @color
		context.beginPath()
		context.arc 0, 0, @radius, 0, 2*MathEx.pi
		context.fill()
	remove_self: ->
		Renderer.remove_obj(@)

# A rectangle render object
class RectRenderObj extends RenderObj
	constructor: (@pos, @width, @height, @color) ->
	@create: (x, y, width, height, color, layer=0) ->
		obj = new RectRenderObj x, y, width, height, color
		obj.add_to_renderer obj, layer
		obj
	draw: (context) ->
		context.fillStyle = @color
		context.fillRect @x, @y, @width, @height

class TextRenderObj extends RenderObj
	constructor: (@pos, @text, @color, @font)->
		@font = TextRenderObj.default_font unless @font
		@color = TextRenderObj.default_color unless @color
		@scale = new Vec2(1, 1)
	@create: (pos, text, color, font, layer=0) ->
		obj = new TextRenderObj(pos, text, color, font)
		obj.add_to_renderer obj, layer
		obj
	draw: (context) ->
		context.font = @font
		context.fillStyle = @color
		context.fillText(@text, 0, 0)
	@default_font: "20px monaco"
	@default_color: "#0F0"
