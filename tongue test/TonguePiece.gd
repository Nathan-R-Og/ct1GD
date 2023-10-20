extends Spatial

const tonguePiece = preload("res://tongue test/tongue.tscn")

const tongueBulb = preload("res://tongue test/bulb.tscn")


var inhert = []

var going = false
var HALT = false
var haltStick = null
var stickMode = -1

var animOUT = -1
export var animBACk = .7
var timeDo = 0.0
var animDir = 0.0

export var retractSpeed = .017
var retracting = false



export var timeBetween = .022
var timeDelay = 0.0
export var amount = 700
var currAmount = 0

var playerInput = Vector2()
var dir = Vector3()

var angleDir = 0.0

onready var scriptMom = null

onready var cam_basis = null



func _ready():
	scriptMom = get_parent()
	if scriptMom.name == "PlayerBody":
		scriptMom = scriptMom.get_parent()

	var i = 0
	while i < inhert.size():
		match i:
			0:
				global_transform[3] = inhert[0]
		i += 1
	inhert = []

func _process(delta):
	
	if stickMode == -1:
		translation = scriptMom.get_node("PlayerBody").translation
	
	if Input.is_action_just_released("fire5"):
		retracting = true
		if stickMode > -1:
			stickMode = -1
			scriptMom.latched = false
	
	
	cam_basis = scriptMom.cam_basis
	
	
	if going == true:
		if HALT == false and currAmount < amount and retracting == false:
			cret()
		elif currAmount >= amount:
			animDir = angleDir
			timeDo += delta
			if animBACk > timeDo:
				var parse = (timeDo / 0.017) / 2
				var seperate = int(fmod(parse, 2))
				if animOUT != seperate:
					animOUT = seperate
					match seperate:
						0:
							angleDir = animDir
							$pieces.get_child($pieces.get_child_count() - 1).queue_free()
							currAmount -= 1
						1:
							cret()
							timeDelay = 0
			else:
				retracting = true


	if cam_basis != null:
		playerInput.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		playerInput.y = Input.get_action_strength("move_backwards") - Input.get_action_strength("move_forward")
		var fuck1 = Special.trueLength(cam_basis[2].x, cam_basis[2].z)
		
		var fuckyou1 = Vector3(fuck1.x,cam_basis[2].y, fuck1.y)
		var fuck2 = Special.trueLength(cam_basis[0].x, cam_basis[0].z)
		var fuckyou2 = Vector3(fuck2.x,cam_basis[0].y, fuck2.y)
		
		
		var newparse = Vector2(0,0)
		if playerInput != Vector2(0,0):
			newparse = playerInput.clamped(1)
		
		dir = newparse.x * (fuckyou2)
		dir += newparse.y * (fuckyou1)
		dir.y = 0



	if $pieces.get_child_count() > 0:
		var boofus = get_node_or_null("bulb")
		if boofus == null:
			add_child(tongueBulb.instance())
		else:
			boofus.global_transform[3] = $pieces.get_child($pieces.get_child_count() - 1).get_node("Spatial").get_node("Position3D").global_transform[3]
	elif stickMode == 1:
		pass
	else:
		var boofus = get_node_or_null("bulb")
		if boofus != null:
			boofus.queue_free()

	if retracting == true:
		timeDelay += delta
		if $pieces.get_child_count() > 0:
			if timeDelay >= retractSpeed:
				#id love to do this with a while loop but it REALLY doesnt like it when i dont define them up front
				currAmount -= 1
				var one = $pieces.get_child($pieces.get_child_count() - 1)
				var two = $pieces.get_child($pieces.get_child_count() - 2)
				var three = $pieces.get_child($pieces.get_child_count() - 3)
				one.queue_free()
				if $pieces.get_child_count() > 0 and two != null:
					two.queue_free()
				if $pieces.get_child_count() > 0 and three != null:
					three.queue_free()
				timeDelay -= retractSpeed
		else:
			retracting = false
			currAmount = 0
			_gone()
	

func cret():
	timeDelay += 0.017
	if timeDelay >= timeBetween or currAmount == 0:
		var new = tonguePiece.instance()
		$pieces.add_child(new)
		new.get_node("Spatial").get_node("SensorArea").connect("body_entered", self, "partTouch", [currAmount])
		if currAmount == 0:
			new.translation = Vector3(0.0,-0.5,0.0)
			angleDir = wrapf((scriptMom.get_node("PlayerBody").get_node("PlayerIMG").rotation_degrees.y - 90), 0 , 360)
		else:
			var calc = $pieces.get_child(currAmount - 1).get_node("Spatial").get_node("Position3D").global_transform[3]
			new.global_transform[3] = calc
			if dir != Vector3():
				var want = abs(rad2deg(atan2(dir.z,dir.x)) - 180) - 90
				want = wrapf(want, 0, 360)
				#smooth the line
				var toCoord = Vector2(cos(deg2rad(want)), sin(deg2rad(want)))
				var fromCoord = Vector2(cos(deg2rad(angleDir)), sin(deg2rad(angleDir)))
				var limit = .6
				var turnIf = .3
				var turnLimit = 1.5
				
				while abs(toCoord.x - fromCoord.x) > limit or abs(toCoord.y - fromCoord.y) > limit:
					var xLength = abs(toCoord.x - fromCoord.x)
					var yLength = abs(toCoord.y - fromCoord.y)
					var x = abs(toCoord.x - fromCoord.x) > limit
					var y = abs(toCoord.y - fromCoord.y) > limit
					if x:
						var sing = (int(bool(toCoord.x < fromCoord.x)) * 2) - 1
						
						if xLength >= turnLimit:
							toCoord.y -= turnIf
						toCoord.x += (sing / 5.0)
					if y:
						var sing = (int(bool(toCoord.y < fromCoord.y)) * 2) - 1
						
						if yLength >= turnLimit:
							toCoord.x -= turnIf
						toCoord.y += (sing / 5.0)
				
				var newC = wrapf(rad2deg(atan2(toCoord.y, toCoord.x)), 0, 360)
				angleDir = newC
		timeDelay -= timeBetween
		new.rotation_degrees.y = angleDir
		
		currAmount += 1


func partTouch(body, idx):
	timeDelay = 0.0
	if body != scriptMom.get_node("PlayerBody"):
		var i = $pieces.get_child_count()
		while i > idx:
			$pieces.get_child(i - 1).queue_free()
			i -= 1
		if body.get_node_or_null("special") != null:
			haltStick = body
			HALT = true
			if body.get_node("special").get_node_or_null("CAN") != null:
				stickMode = 1
				scriptMom.movementType = 3
			elif body.get_node("special").get_node_or_null("POLEH") != null:
				stickMode = 2
				scriptMom.movementType = 3
			scriptMom.waitTimer = 0.0
			scriptMom.velocity = Vector3(0,0,0)
		else:
			currAmount -= 1
			retracting = true
		
func balls():
	scriptMom.add_child(self)


func _going():
	going = true
	scriptMom.movementType = 2


func _gone():
	
	stickMode = -1
	retracting = false
	HALT = false
	haltStick = null
	timeDo = 0.0
	currAmount = 0
	angleDir = 0.0
	dir = Vector3()
	playerInput = Vector2()
	var i = $pieces.get_child_count()
	while i > 0:
		$pieces.get_child(i - 1).queue_free()
		i -= 1
	
	
	going = false
	scriptMom.movementType = 1


