extends Spatial


var lookSensitivity : float = 15
var minLookAngle : float = -90.0
var maxLookAngle : float = 90.0
var moveWith : bool = true




var stickDelta : Vector2 = Vector2()
var mouseDelta : Vector2 = Vector2()

onready var player = get_node("/root/Stage/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# if move
	mouseDelta.x = ((Input.get_action_strength("rstickright")-Input.get_action_strength("rstickleft")))*10
	mouseDelta.y = ((Input.get_action_strength("rstickup")-Input.get_action_strength("rstickdown")))*10






func _process(delta):
	if moveWith == true:
		translation.x = get_node("/root/Stage/Player").translation.x
		translation.y = get_node("/root/Stage/Player").translation.y + 4
		translation.z = get_node("/root/Stage/Player").translation.z



	#set the rotation vecotr to the mouse speed y and x, but also mutliply by time and look sensitivuity
	var rot = Vector3(-mouseDelta.y, mouseDelta.x, 0) * lookSensitivity * delta
	
	rotation_degrees.x += (rot.x)
	rotation_degrees.x = clamp(rotation_degrees.x, -40, 40)
	if rotation_degrees.y > 360:
		rotation_degrees.y = 0
	if rotation_degrees.y < 0:
		rotation_degrees.y = 360
	rotation_degrees.y -= (rot.y)
	
	#set blank
	mouseDelta = Vector2()


