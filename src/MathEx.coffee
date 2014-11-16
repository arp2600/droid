
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
	
	@clamp: (value, min=-1, max=1) ->
		Math.max(min, Math.min(value, max))
