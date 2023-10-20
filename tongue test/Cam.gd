extends Spatial


export var playerPath = NodePath()
onready var player = get_node(playerPath)

var rot = Vector3(0,0,0)
var playerInput = Vector2()

var offset = Vector3(0,0,0)
export var camOffset = Vector3(0,0,0)
export var camAngleOffset = Vector3(-41.848,0,0)

var fakeZoom = 1.0
var zoomInc = 0.2

export var panLimits = Vector2()
onready var tween = $Camera/Tween

var parseRot = Vector3()
export var limits1 = Vector2(-41.848,314.85)
func _process(delta):
	translation = (player.translation + player.get_node("PlayerBody").translation)
	rotation_degrees = Vector3(parseRot.x - camAngleOffset.x, rot.y, rot.z)
	$Camera.rotation_degrees = camAngleOffset


	if Input.is_action_just_pressed("panLEFT"):
		offset += Vector3(-1,0,0)
		offset.x = clamp(offset.x, panLimits.x, panLimits.y)
		funny()
	if Input.is_action_just_pressed("panRIGHT"):
		offset += Vector3(1,0,0)
		offset.x = clamp(offset.x, panLimits.x, panLimits.y)
		funny()
	if Input.is_action_just_pressed("panIN"):
		fakeZoom = clamp(fakeZoom - zoomInc, zoomInc, 2)
		funny()
	if Input.is_action_just_pressed("panOUT"):
		fakeZoom = clamp(fakeZoom + zoomInc, zoomInc, 2)
		funny()


	playerInput.x = Input.get_action_strength("rstickright") - Input.get_action_strength("rstickleft")
	playerInput.y = Input.get_action_strength("rstickdown") - Input.get_action_strength("rstickup")
	
	rot += Vector3(playerInput.y,  playerInput.x, 0) * 2
	rot.x = wrapf(rot.x, 0, 360)
	rot.y = wrapf(rot.y, 0, 360)
	rot.z = wrapf(rot.z, 0, 360)
	if rot.x > -limits1.x and rot.x < 180:
		rot.x = -limits1.x
	if rot.x < limits1.y and rot.x > 180:
		rot.x = limits1.y
	
	parseRot.x = wrapf(rot.x + camAngleOffset.x, 0, 360)
	parseRot.y = wrapf(rot.y + camAngleOffset.y, 0, 360)
	parseRot.z = wrapf(rot.z + camAngleOffset.z, 0, 360)
func funny():
		tween.interpolate_property($Camera, "translation",
		$Camera.translation, offset + (camOffset * fakeZoom), 0.5,
		Tween.TRANS_EXPO, Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(0.2),"timeout")
