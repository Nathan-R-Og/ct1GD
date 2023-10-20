extends Spatial

var tongueTime : float = 0.0
var tongueIteration = 0
var tongueAngleArray = []
var speedScalar = 15.0

var hv = Vector3(1,1,1)
var hdir = Vector3()

var cam_basis = Vector3()
var dir = Vector3() # Where does the player intend to walk to.
var backUpDir = Vector3()
const TURN_SPEED = 40
var hspeed = Vector3()# Horizontal speed.

var Fakedir = Vector3()
var fakeDirdir = 0.0

var staleDir = 0.0


func _ready():
	pass # Replace with function body.
func _process(delta):
	var playerRot = $"../Armature".rotation_degrees.y + 180
	cam_basis = get_node("/root/Stage/Target/Camera").get_global_transform().basis
	dir = Vector3()
	backUpDir.x = cos(deg2rad(playerRot))
	backUpDir.z = sin(deg2rad(playerRot))
	backUpDir = backUpDir.normalized()
	dir = backUpDir
	staleDir = rad2deg(atan2(dir.x, dir.z))
	rotation_degrees.y = $"../Armature".rotation_degrees.y


	Fakedir = Vector3()
	Fakedir = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * cam_basis[0]
	Fakedir += (Input.get_action_strength("move_forward") - Input.get_action_strength("move_backwards")) * cam_basis[2]
	Fakedir.y = 0
	Fakedir = Fakedir.normalized()
	fakeDirdir = rad2deg(atan2(Fakedir.x,Fakedir.z))


	print(String(fakeDirdir) + " input")
	print(String(staleDir) + " stale")


	if Input.is_action_pressed("fire1"):
		tongueTime += delta
		tongueIteration += (tongueTime * 10)
		tongueIteration = floor(tongueIteration)
		tongueThing()
	if Input.is_action_just_released("fire1"):
		tongueTime = 0
		tongueIteration = 0
		var i = get_child_count()
		while i > 0:
			get_child(i - 1).queue_free() 
			i -= 1
func tongueThing():
	var amount = get_child_count()
	if amount == 0:
		print("hwat")
		var tonguePiece = load("res://player/TonguePiece.tscn").instance()
		add_child(tonguePiece)
		tonguePiece.translation.z = 0
		tonguePiece.translation.y = 1.607 
		if Fakedir.x == 0.0 and Fakedir.z == 0.0:
			tonguePiece.rotation_degrees.y = fakeDirdir + 90
		else:
			tonguePiece.rotation_degrees.y = fakeDirdir + 180
	if amount != 0 and amount < 20:
		var tonguePiece = load("res://player/TonguePiece.tscn").instance()
		add_child(tonguePiece)
		var oldPiece = get_child(get_child_count() - 2)
		var oldPieceStarter = oldPiece.get_node("NextPos").global_transform[0]
		var oldpieceOffset = oldPiece.global_transform[0]
		var subtraction = oldpieceOffset - oldPieceStarter/2
		tonguePiece.translation = subtraction + oldPiece.translation
		if Fakedir.x == 0.0 and Fakedir.z == 0.0:
			tonguePiece.rotation_degrees.y = fakeDirdir + 90
		else:
			tonguePiece.rotation_degrees.y = move_toward(tonguePiece.rotation_degrees.y, staleDir + fakeDirdir, 0)

