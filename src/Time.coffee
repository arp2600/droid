
# Return the time
class Time
	@delta_time = 0
	@get_time: ->
		new Date().getTime()
	@start = new Date().getTime()
	@previous_frame = @start
	@update: ->
		temp = @get_time()
		@delta_time = (temp - @previous_frame) * 0.001
		@previous_frame = temp


