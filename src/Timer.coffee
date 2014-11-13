
class Timer
	constructor: ->
		@start()
	start: ->
		@start_time = Time.get_time()
	elapsed_time: ->
		Time.get_time() - @start_time

