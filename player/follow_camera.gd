extends Camera

const MAX_HEIGHT = 2.0
const MIN_HEIGHT = 0

export var min_distance = 0.5
export var max_distance = 3.5
export var angle_v_adjust = 0.0
export var autoturn_ray_aperture = 25
export var autoturn_speed = 50

var collision_exception = []

func _ready():
	# Find collision exceptions for ray.
	var node = self
	while node:
		if node is RigidBody:
			collision_exception.append(node.get_rid())
			break
		else:
			node = node.get_parent()
	set_physics_process(true)
	# This detaches the camera transform from the parent spatial node.
	set_as_toplevel(true)


func _physics_process(dt):

	var pos = get_global_transform().origin

	var delta = pos

	# Regular delta follow.

	# Check ranges.
	if delta.length() < min_distance:
		delta = delta.normalized() * min_distance
	elif  delta.length() > max_distance:
		delta = delta.normalized() * max_distance

	# Check upper and lower height.
	delta.y = clamp(delta.y, MIN_HEIGHT, MAX_HEIGHT)

	# Check autoturn.
	var ds = PhysicsServer.space_get_direct_state(get_world().get_space())







	# Turn a little up or down.
	var t = get_transform()
	t.basis = Basis(t.basis[0], deg2rad(angle_v_adjust)) * t.basis
	set_transform(t)
