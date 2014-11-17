
class FPSWidget
	constructor: (@pos) ->
		Renderer.add_obj_to_layer(@, RenderLayers.ui_widgets)
		@frames = 0
		@update_rate=500
		@update_display()
		@scale = new Vec2(1,-1)
	update: ->
		@frames++
		@update_display() if Time.get_time() - @start > @update_rate
	update_display: ->
		@text = "FPS: " + (@frames * (1000/@update_rate))
		@frames = 0
		@start = Time.get_time()
	draw: (context) ->
		context.font = "20px monaco"
		context.fillStyle = Colors.hud_text
		context.fillText(@text, 0, 0)


