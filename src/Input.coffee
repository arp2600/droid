
class Input
	@keys = []
	@keys.push(false) for i in [0...127]
	@keydown: (event) =>
		@keys[event.keyCode] = true
	@keyup: (event) =>
		@keys[event.keyCode] = false
	@get_key: (key) ->
		return @keys[key.charCodeAt(0)] if key?.charCodeAt
		@keys[key]
document.addEventListener('keydown',Input.keydown)
document.addEventListener('keyup',Input.keyup)

