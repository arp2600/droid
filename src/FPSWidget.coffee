
class FPSWidget
	constructor: (@pos) ->
		@text = TextRenderObj.create(@pos.x, @pos.y, "FPS: ", null, null, 9)
		@frames = 0
		@update_display()
	update: ->
		@frames++
		@update_display() if Time.get_time() - @start > 1000
	update_display: ->
		@text.text = "FPS: " + @frames
		@frames = 0
		@start = Time.get_time()
