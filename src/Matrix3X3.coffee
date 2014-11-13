
class Mat3X3
	constructor: ->
		@mat = [1, 0, 0, 0, 1, 0, 0, 0, 1]
	copy: (mat) ->
		@mat[i] = item for item, i in mat.mat
	load_identity: ->
		@mat = [1, 0, 0, 0, 1, 0, 0, 0, 1]
	# Multiply two matrices
	@mul: (lhs, rhs) ->
		out = new Mat3X3()
		out.mat[0] = lhs.mat[0]*rhs.mat[0] + lhs.mat[1]*rhs.mat[3] + lhs.mat[2]*rhs.mat[6]
		out.mat[1] = lhs.mat[0]*rhs.mat[1] + lhs.mat[1]*rhs.mat[4] + lhs.mat[2]*rhs.mat[7]
		out.mat[2] = lhs.mat[0]*rhs.mat[2] + lhs.mat[1]*rhs.mat[5] + lhs.mat[2]*rhs.mat[8]
		out.mat[3] = lhs.mat[3]*rhs.mat[0] + lhs.mat[4]*rhs.mat[3] + lhs.mat[5]*rhs.mat[6]
		out.mat[4] = lhs.mat[3]*rhs.mat[1] + lhs.mat[4]*rhs.mat[4] + lhs.mat[5]*rhs.mat[7]
		out.mat[5] = lhs.mat[3]*rhs.mat[2] + lhs.mat[4]*rhs.mat[5] + lhs.mat[5]*rhs.mat[8]
		out.mat[6] = lhs.mat[6]*rhs.mat[0] + lhs.mat[7]*rhs.mat[3] + lhs.mat[8]*rhs.mat[6]
		out.mat[7] = lhs.mat[6]*rhs.mat[1] + lhs.mat[7]*rhs.mat[4] + lhs.mat[8]*rhs.mat[7]
		out.mat[8] = lhs.mat[6]*rhs.mat[2] + lhs.mat[7]*rhs.mat[5] + lhs.mat[8]*rhs.mat[8]
		out
	# Create and return a rotation matrix
	@rotation: (angle) ->
		cos_theta = MathEx.cos(angle)
		sin_theta = MathEx.sin(angle)
		out = new Mat3X3()
		out.mat[0] = cos_theta
		out.mat[1] = sin_theta
		out.mat[3] = -sin_theta
		out.mat[4] = cos_theta
		out

	rotate: (angle) ->
		temp = Mat3X3.mul(Mat3X3.rotation(angle), @)
		@mat = temp.mat
		@
	# Create and return a scale matrix
	@scale: (x, y) ->
		out = new Mat3X3()
		out.mat[0] = x
		out.mat[4] = y
		out
	scale: (x, y) ->
		temp = Mat3X3.mul(@, Mat3X3.scale(x, y))
		@mat = temp.mat
		@

	@translation: (x, y) ->
		out = new Mat3X3()
		out.mat[2] = x
		out.mat[5] = y
		out
	
	translate: (x, y) ->
		temp = Mat3X3.mul(Mat3X3.translation(x, y), @)
		@mat = temp.mat
		@

