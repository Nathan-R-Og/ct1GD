extends Area

enum Anim {
	FLOOR,
	AIR,
}

const SHOOT_TIME = 1.5
const SHOOT_SCALE = 2
const CHAR_SCALE = Vector3(0.3, 0.3, 0.3)
const MAX_SPEED = 4.5
const TURN_SPEED = 40
const JUMP_VELOCITY = 8.5
const BULLET_SPEED = 20
const AIR_IDLE_DEACCEL = false
const ACCEL = 14.0
const DEACCEL = 14.0
# AIR FRICTION \/
const AIR_ACCEL_FACTOR = 0.8
const SHARP_TURN_THRESHOLD = 140

var movement_dir = Vector3()
var linear_velocity = Vector3()
var jumping = false
var prev_shoot = false
var shoot_blend = 0
var jumps = 0
var baseJumps = 2
var jumpHold = 0.0
var jumpHoldInc = 0.0

var tonguing = false







var cam_basis = Vector3()
var dir = Vector3() # Where does the player intend to walk to.



onready var whatTHeFuck = get_node("/root/Stage/Target/Camera").get_global_transform().basis



var anim = Anim


var vv = 0.0
var hv = Vector3()





func _physics_process(delta):

	vv = linear_velocity.y # Vertical velocity.
	hv = Vector3(linear_velocity.x, 0, linear_velocity.z) # Horizontal velocity.

	var hdir = hv.normalized() # Horizontal direction.
	var hspeed = hv.length() # Horizontal speed.

	# Player input.
	if tonguing == false:
#since i cant understand what the fuck basis does, let me put it laymens terms
# row 1 = x = left 1 right -1, y = 0 (????), z = forward 1 backwards - 1
# row 2 = x = (top down) backwards 1 forwards -1, y = how centered the y level is, 0-1, z = (top down) left 1 right -1
# row 3 = x = basically flipped row 1 z, y = distance away from level, polar of row 2 y, bottom -1 top 1, z = row 1 x
		cam_basis = get_node("/root/Stage/Target/Camera").get_global_transform().basis
		dir = Vector3()
		dir = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * cam_basis[0]
		dir += (Input.get_action_strength("move_backwards") - Input.get_action_strength("move_forward")) * cam_basis[2]
		dir.y = 0
		dir = dir.normalized()


#button commands
	var jump_attempt = Input.is_action_just_pressed("jump")
	var shoot_attempt = Input.is_action_pressed("shoot")

	var sharp_turn = hspeed > 0.1 and rad2deg(acos(dir.dot(hdir))) > SHARP_TURN_THRESHOLD

	if dir.length() > 0.1 and !sharp_turn:
		if hspeed > 0.001:
			hdir = adjust_facing(hdir, dir, delta, 1.0 / hspeed * TURN_SPEED, Vector3.UP)
		else:
			hdir = dir

		if hspeed < MAX_SPEED:
			hspeed += ACCEL * delta
	else:
		hspeed -= DEACCEL * delta
		if hspeed < 0:
			hspeed = 0

	hv = hdir * hspeed

	var mesh_xform = get_node("/root/Stage/Player/").get_transform()
	var facing_mesh = -mesh_xform.basis[0].normalized()
	facing_mesh = (facing_mesh - Vector3.UP * facing_mesh.dot(Vector3.UP)).normalized()

	if hspeed > 0:
		facing_mesh = adjust_facing(facing_mesh, dir, delta, 1.0 / hspeed * TURN_SPEED, Vector3.UP)
	var m3 = Basis(-facing_mesh, Vector3.UP, -facing_mesh.cross(Vector3.UP).normalized()).scaled(CHAR_SCALE)




#jump
	if jumping and vv == 0:
		jumping = false
	linear_velocity = hv + Vector3.UP * vv







#the facings stuff maybe?????
func adjust_facing(p_facing, p_target, p_step, p_adjust_rate, current_gn):
	var n = p_target # Normal.
	var t = n.cross(current_gn).normalized()

	var x = n.dot(p_facing)
	var y = t.dot(p_facing)

	var ang = atan2(y,x)
#turn range?
	if abs(ang) < 0.001: # Too small.
		return p_facing

	var s = sign(ang)
#turn amount?
	ang = (ang) * (s/1)

	var turn = ang * p_adjust_rate * p_step
	var a
	if ang < turn:
		a = ang
	else:
		a = turn
	ang = (ang - a) * s

	return (n * cos(ang) + t * sin(ang)) * p_facing.length()
