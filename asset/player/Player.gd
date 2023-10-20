extends Spatial


var playerInput = Vector2()
export var movementType = 1

export var camPath = NodePath()
onready var cam = get_node(camPath)

var cam_basis = null

onready var PlayerBody = $PlayerBody
export var deadZone = 0.15
export var Friction = 0.48
export var walkLimit = 5.0
export var speed = 120.0
export var runFriction = 0.96
export var runLimit = 14.0
export var runpeed = 298.0
export var Jumpspeed = 14.5
export var gravity = 0.45
export var snap = 0.003

var dirXXX = 0.0
var renderDir = ""


var jumping = false

var velocity = Vector3()

onready var Anim = $PlayerBody/PlayerIMG

onready var bonker = $PlayerBody/bonk
var bonked = false
var bonk = false

var running = false

var lock = false

var frame = 0.0
var animation = []
var frameCOUNT = 0
var frameSYNTAX = ""

var do = null
var doing = false
var doable = true

var mix = 0.0

var tongueAble = false

export var sprite = true

var waitTimer = 0.0
export var waitTillIN = 0.5
var tick = .017
var ticks = 0.0
var latched = false
var latchTimer = 1.0
var latchDelay = 0.5
var latchDelayTimer = 0.0
var delayflag = false

onready var tongues = null

var latchLaunch = false

var climbable = true

func _ready():
	tongues = $TonguePiece2

func _process(delta):
	
	if latchDelayTimer > 0:
		latchDelayTimer -= delta
	else:
		delayflag = false
	
	
	if sprite:
		var g = cam.get_parent().rotation_degrees.y
		var mix = wrapf((dirXXX - g) + 180,0, 360)
		
		
		if mix <= 22.5 or mix > 337.5:
			renderDir = "right"
		elif mix > 22.5 and mix <= 67.5:
			renderDir = "upright"
		elif mix > 67.5 and mix <= 112.5:
			renderDir = "up"
		elif mix > 112.5 and mix <= 157.5:
			renderDir = "upleft"
		elif mix > 157.5 and mix <= 202.5:
			renderDir = "left"
		elif mix > 202.5 and mix <= 247.5:
			renderDir = "downleft"
		elif mix > 247.5 and mix <= 292.5:
			renderDir = "down"
		elif mix > 292.5 and mix <= 337.5:
			renderDir = "downright"
		
		$PlayerBody/PlayerIMG/MeshInstance.play(renderDir + frameSYNTAX)
	
	
		if $PlayerBody/PlayerIMG/MeshInstance.playing == true:
			frame += delta
			var i = 0
			while i < animation.size():
				var sss = animation[i][0]
				if sss == $PlayerBody/PlayerIMG/MeshInstance.animation:
					var size = $PlayerBody/PlayerIMG/MeshInstance.frames.get_frame_count($PlayerBody/PlayerIMG/MeshInstance.animation)
					frameCOUNT = int(floor((fmod(frame,animation[i][1]) / animation[i][1]) * size))
					break
				i += 1
		else:
			frame = 0
			frameCOUNT = 0
		$PlayerBody/PlayerIMG/MeshInstance.frame = frameCOUNT
		
		
		animation.resize(1)
		animation[0] = [renderDir, 0.5]
		
		
	
	cam_basis = cam.get_global_transform().basis
	
	
	
	playerInput.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	playerInput.y = Input.get_action_strength("move_backwards") - Input.get_action_strength("move_forward")
	
	
	
	
	match movementType:
		0:
			var dir = Vector3()
			dir = 0 * cam_basis[0]
			dir += 0 * cam_basis[2]
			dir.y = 0
			dir = dir.normalized()
			
			
			var directionalPower = sqrt(pow(dir.x,2) + pow(dir.z,2))
			if abs(directionalPower) < speed * deadZone:
				var catch = Vector2(velocity.x, velocity.z)
				catch = catch.move_toward(Vector2(0,0), Friction)
				velocity = Vector3(catch.x,velocity.y,catch.y)
			if PlayerBody.is_on_floor():
				velocity.y = 0
			else:
				velocity.y -= gravity
			
			$PlayerBody/CollisionShape.rotation_degrees.y = dirXXX
			$PlayerBody/PlayerIMG.rotation_degrees.y = dirXXX



			
			PlayerBody.move_and_slide_with_snap(velocity, Vector3(0,-snap,0), Vector3.UP)
		1:
			tongueAble = true
			running = Input.is_action_pressed("fire2")
			lock = Input.is_action_pressed("fire6")
			
			
			
			
			
			var newparse = Vector2(0,0)
			if playerInput != Vector2(0,0):
				newparse = playerInput.clamped(1)
			
			
			
			
			var dir = Vector3()
			var fuck1 = Special.trueLength(cam_basis[2].x, cam_basis[2].z)
			
			var fuckyou1 = Vector3(fuck1.x,cam_basis[2].y, fuck1.y)
			var fuck2 = Special.trueLength(cam_basis[0].x, cam_basis[0].z)
			var fuckyou2 = Vector3(fuck2.x,cam_basis[0].y, fuck2.y)
			
			dir = newparse.x * (fuckyou2)
			dir += newparse.y * (fuckyou1)
			dir.y = 0

			
			var newParse = 0.0
			var newDir = dir
			
			
			
			
			if playerInput != Vector2(0,0):
				dirXXX = rad2deg(-atan2(dir.z,dir.x)) + 180
			$PlayerBody/CollisionShape.rotation_degrees.y = dirXXX
			$PlayerBody/PlayerIMG.rotation_degrees.y = dirXXX

			
			if $PlayerBody.is_on_floor():
				#print(climbable)
				pass
			
			
			var directionalPower = sqrt(pow(newDir.x,2) + pow(newDir.z,2))

		

			if lock == true:
				newDir = Vector3(0,0,0)

			if latchLaunch == false:
				if running == false:
					if abs(directionalPower) < speed * deadZone:
						var catch = Vector2(velocity.x, velocity.z)
						catch = catch.move_toward(Vector2(0,0), Friction)
						velocity = Vector3(catch.x,velocity.y,catch.y)
					
					var c = Vector2(velocity.x, velocity.z)
					c = c.clamped(walkLimit)
					velocity.x = c.x
					velocity.z = c.y
					
					velocity += (newDir * speed) * delta
				else:
					if abs(directionalPower) < runpeed * deadZone:
						var catch = Vector2(velocity.x, velocity.z)
						catch = catch.move_toward(Vector2(0,0), runFriction)
						velocity = Vector3(catch.x,velocity.y,catch.y)
					
					
					var c = Vector2(velocity.x, velocity.z)
					c = c.clamped(walkLimit)
					velocity.x = c.x
					velocity.z = c.y
					
					velocity += (newDir * runpeed) * delta
					

			if jumping == false:
				velocity.y = PlayerBody.move_and_slide_with_snap(velocity, Vector3(0,-snap,0), Vector3.UP, true, 4, deg2rad(75), false).y
			else:
				velocity = PlayerBody.move_and_slide_with_snap(velocity, Vector3(0,-snap,0), Vector3.UP, true, 4, deg2rad(75), false)
			

			
		

				
				
			if PlayerBody.is_on_floor():
				latchLaunch = false
				doable = true
				if sprite:
					frameSYNTAX = ""
				if Input.is_action_pressed("fire6"):
					if sprite:
						frameSYNTAX = "_c"
					lock = true
				if abs(round(velocity.x)) == 0 and abs(round(velocity.z)) == 0:
					if sprite:
						$PlayerBody/PlayerIMG/MeshInstance.stop()
						$PlayerBody/PlayerIMG/MeshInstance.frame = 0
				bonk = false
				if Input.is_action_just_pressed("fire1"):
					if sprite:
						frameSYNTAX = "_jump"
					jumping = true
					velocity.y += Jumpspeed
			else:
				doable = false
				velocity.y -= gravity
				if bonked == true and bonk == false:
					bonk = true
					bonked = false
					velocity.y = 0
			


			
			
			
			
			


			if Input.is_action_just_released("fire1"):
				jumping = false

			
		
			if Input.is_action_just_pressed("fire2") and doable and do != null and doing == false:
				do.get_parent().do()
				velocity = Vector3()
				doing = true
				movementType = 0

		2:
			var newparse = Vector2(0,0)
			if playerInput != Vector2(0,0):
				newparse = playerInput.clamped(1)
			var dir = Vector3()
			var fuck1 = Special.trueLength(cam_basis[2].x, cam_basis[2].z)
			var fuckyou1 = Vector3(fuck1.x,cam_basis[2].y, fuck1.y)
			var fuck2 = Special.trueLength(cam_basis[0].x, cam_basis[0].z)
			var fuckyou2 = Vector3(fuck2.x,cam_basis[0].y, fuck2.y)
			dir = newparse.x * (fuckyou2)
			dir += newparse.y * (fuckyou1)
			dir.y = 0
			var newParse = 0.0
			var newDir = Vector3(0,0,0)
			#if playerInput != Vector2(0,0):
			#	dirXXX = rad2deg(-atan2(dir.z,dir.x)) + 180
			#$PlayerBody/CollisionShape.rotation_degrees.y = dirXXX
			#$PlayerBody/PlayerIMG.rotation_degrees.y = dirXXX
			var directionalPower = sqrt(pow(newDir.x,2) + pow(newDir.z,2))
			if running == false:
				if abs(directionalPower) < speed * deadZone:
					var catch = Vector2(velocity.x, velocity.z)
					catch = catch.move_toward(Vector2(0,0), Friction)
					velocity = Vector3(catch.x,velocity.y,catch.y)
				
				var c = Vector2(velocity.x, velocity.z)
				c = c.clamped(walkLimit)
				velocity.x = c.x
				velocity.z = c.y
				
				velocity += (newDir * speed) * delta
			else:
				if abs(directionalPower) < runpeed * deadZone:
					var catch = Vector2(velocity.x, velocity.z)
					catch = catch.move_toward(Vector2(0,0), runFriction)
					velocity = Vector3(catch.x,velocity.y,catch.y)
				var c = Vector2(velocity.x, velocity.z)
				c = c.clamped(walkLimit)
				velocity.x = c.x
				velocity.z = c.y
				velocity += (newDir * runpeed) * delta
			if jumping == false:
				velocity.y = PlayerBody.move_and_slide_with_snap(velocity, Vector3(0,-snap,0), Vector3.UP, true, 4, deg2rad(45), false).y
			else:
				velocity = PlayerBody.move_and_slide_with_snap(velocity, Vector3(0,-snap,0), Vector3.UP, true, 4, deg2rad(45), false)
			if PlayerBody.is_on_floor():
				doable = true
				if sprite:
					frameSYNTAX = ""
				if Input.is_action_pressed("fire6"):
					if sprite:
						frameSYNTAX = "_c"
					lock = true
				if abs(round(velocity.x)) == 0 and abs(round(velocity.z)) == 0:
					if sprite:
						$PlayerBody/PlayerIMG/MeshInstance.stop()
						$PlayerBody/PlayerIMG/MeshInstance.frame = 0
				bonk = false
				if Input.is_action_just_pressed("fire1"):
					if sprite:
						frameSYNTAX = "_jump"
					jumping = true
					velocity.y += Jumpspeed
			else:
				doable = false
				velocity.y -= gravity
				if bonked == true and bonk == false:
					bonk = true
					bonked = false
					velocity.y = 0


			
			
			
			
			


			if Input.is_action_just_released("fire1"):
				jumping = false

			
		
			if Input.is_action_just_pressed("fire2") and doable and do != null and doing == false:
				do.get_parent().do()
				velocity = Vector3()
				doing = true
				movementType = 0



		3:
			print([latched, delayflag, latchLaunch])
			match tongues.stickMode:
				1:
					if latched == false:
						waitTimer += delta
						if waitTimer >= waitTillIN:
							ticks += delta
							if ticks > tick:
								if tongues.get_node("pieces").get_child_count() > 0:
									var one = tongues.get_node("pieces").get_child(0)
									var two = tongues.get_node("pieces").get_child(1)
									var three = tongues.get_node("pieces").get_child(3)
									one.queue_free()
									$PlayerBody.translation = (tongues.get_node("pieces").get_child(0).global_transform[3] - global_transform[3]) + Vector3(0,.5,0)
									var diss = tongues.get_node("pieces").get_child(0).rotation_degrees.y + 90
									$PlayerBody/CollisionShape.rotation_degrees.y = diss
									$PlayerBody/PlayerIMG.rotation_degrees.y = diss
									if tongues.get_node("pieces").get_child_count() > 0 and two != null:
										two.queue_free()
										$PlayerBody.translation = (tongues.get_node("pieces").get_child(0).global_transform[3] - global_transform[3]) + Vector3(0,.5,0)
										var diss2 = tongues.get_node("pieces").get_child(0).rotation_degrees.y + 90
										$PlayerBody/CollisionShape.rotation_degrees.y = diss2
										$PlayerBody/PlayerIMG.rotation_degrees.y = diss2
									ticks -= tick
									if Input.is_action_just_released("fire5") and tongues.get_node("pieces").get_child_count() > 0:
										var diss2 = $PlayerBody/CollisionShape.rotation_degrees.y
										diss2 = wrapf(diss2, 0, 360)
										var makeVelocity = Vector2(cos(deg2rad(diss2)), sin(deg2rad(diss2)))
										print([diss2,makeVelocity])
										var ify = Vector3(-makeVelocity.x, 0, makeVelocity.y) * 20
										tongues._gone()
										latchDelayTimer = latchDelay
										latched = false
										delayflag = true
										velocity = ify
										latchLaunch = true
										waitTimer = 0.0
										ticks = 0.0
								else:
									latched = true
									ticks = 0
									waitTimer = 0.0
					else:
						ticks = 0.0
						waitTimer += delta
						if waitTimer > latchTimer:
							latched = false
							tongues._gone()
							latchDelayTimer = latchDelay
							delayflag = true
							waitTimer = 0.0
						elif Input.is_action_just_pressed("fire1"):
							latched = false
							velocity = Vector3()
							velocity.y += Jumpspeed * .75
							tongues._gone()
							latchDelayTimer = latchDelay
							delayflag = true
							waitTimer = 0.0

				
	if tongueAble == true:
		if Input.is_action_just_pressed("fire5") and delayflag == false:
			tongues._going()


func _on_bonk_body_entered(body):
	bonked = true


func _on_interact_body_entered(body):
	if body != $PlayerBody:
		if body != do:
			do = body


func _on_interact_body_exited(body):
	if body != $PlayerBody:
		if body == do:
			do = null


func _on_wallSlide_body_entered(body):
	if body != $PlayerBody:
		if body.get_node_or_null("special") != null:
			var balls = body.get_node("special").get_node_or_null("STOP")
			climbable = balls != null


func _on_wallSlide_body_exited(body):
	if body != $PlayerBody:
		climbable = true
