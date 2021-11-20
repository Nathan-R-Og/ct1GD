extends Spatial

export var mainPath = NodePath()
onready var main = get_node(mainPath)
onready var mainBody = main.get_child(0)
export var amountOfPieces = 0
export var pieceSpacing = 0.0
export var pieceTorque = 0.0
export var speed = 0.0


export var amountOfVaultPieces =0


var prevAngle = 0
var prevPos = Vector3(0,0,0)

var CHECKARRAY = []

const tonguePiece = preload("res://tongue test/tongue.tscn")

onready var TIMER = $"../tongueTimer"
onready var TIMERBACK = $"../tongueTimerBack"

var tonggggue = 0


var storageAngle = 0.0

func tongue():
	storageAngle = main.playerAngle
	main.toug = true
	main.movementType = 2
	CHECKARRAY = []
	prevPos = mainBody.global_transform[3]
	prevAngle = 0.0
	tonggggue = 0
	_on_tongueTimer_timeout()

func reel():
	main.movementType = 1
	main.toug = false
	prevPos = Vector3()
	prevAngle = 0.0
	storageAngle = 0.0
	var delet = get_child_count()
	while delet > 0:
		get_child(delet - 1).queue_free()
		delet -= 1


func _on_tongueTimer_timeout():
	if main.toug == false:
		TIMER.stop()
		return
	elif main.toug == true:
		TIMER.start(speed)


	if tonggggue < amountOfPieces:
		var tonque = tonguePiece.instance()
		add_child(tonque)
		
		var angler = fmod(prevAngle, 360.0)
		
		var playerInput = main.playerInput
		var calc = fmod((rad2deg(atan2(playerInput.x,playerInput.z)) + 270), 360.0)
		var playerInfluecne = 0.0
		if playerInput != Vector3(0,0,0):
			playerInfluecne = calc - prevAngle
		else:
			playerInfluecne = storageAngle
		
		
		
		playerInfluecne -= storageAngle
		playerInfluecne /= pieceTorque
		
		angler += playerInfluecne
		tonque.rotation_degrees.y = angler
		tonque.global_transform[3] = prevPos
		tonque.translation.y = 0.0
		if main.toug == false:
			TIMER.stop()
		var tonqueDirMod = Vector3()
		tonqueDirMod.x = cos(deg2rad(angler))
		tonqueDirMod.y = 1.0
		tonqueDirMod.z = sin(deg2rad(angler))
		var baseR = tonque.translation + (tonque.get_node("Position3D").translation * tonqueDirMod)
		var base = tonque.get_node("Position3D").global_transform[3]
		tonque.get_node("SensorArea").connect("area_entered", main, "tongueTouchArea")
		tonque.get_node("SensorArea").connect("body_entered", main, "tongueTouchBody")
		CHECKARRAY.append(prevPos)
		prevAngle = angler
		prevPos = base
		print(angler)
		tonggggue += 1

func latch():
	TIMER.stop()
	main.movementType = 3
	var bulb = preload("res://tongue test/bulb.tscn").instance()
	var node = get_child(get_child_count() - 1)
	add_child(bulb)
	if node == bulb:
		bulb.translation = Vector3(0,0,0)
	else:
		bulb.global_transform[3] = node.get_node("Position3D").global_transform[3]
	bulb.rotation_degrees.y = node.rotation_degrees.y
	return


func vault(speed, input):
	var parseAmp = Vector2(speed.x,speed.z)
	var ankle = rad2deg(atan2(input.z,input.x))
	var newDir =  Vector2(cos(deg2rad(ankle)), sin(deg2rad(ankle)))
	var base = parseAmp * newDir
	var two = sqrt(pow(base.x, 2) + pow(base.y, 2))
	#two == base power in direction
	var outOf = two/main.WALK_MAX_SPEED
	main.velocity.y += outOf * 100
	main.jumping = true
