
# Return the time
class Time
	@get_time: ->
		new Date().getTime()
	@start = new Date().getTime()

