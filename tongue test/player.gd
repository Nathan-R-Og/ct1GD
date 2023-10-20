extends Spatial


var direction = "right"


export var WALK_FORCE = 0.5
export var WALK_MAX_SPEED = 0.5
export var STOP_FORCE = 0.25
export var baseGravity = 0.15
export var gravity = 0.0
export var JUMP_SPEED = 0.5


export var movementType = 1



var velocity = Vector3()
#jumpstuff
var jumps = 0
export var baseJumps = 1
export var jumpHold = 0.0
export var jumpHoldInc = 0.001
var jumping = false




export var cameraPath = NodePath()
onready var camera = get_node(cameraPath)
onready var cameraNODE = camera.get_node("Camera")
var camBasis = Basis()


var playerInput = Vector3()
var playerAngle = 0.0

var toug = false


var spinBro = 0.0
var spinBroTime = 0.0

var latchBroTime = 0.0
export var latchBroTimeUp = 0.0
var latchONTime = 0.0
export var latchBroTimeGoTo = 0.0
var latched = false
var latchAfter = false
var latchAfterTime = 0.0
export var latchAfterDelay = 0.0
var on = false



var wee = 0

func _process(delta):
	if latchAfter == true:
		latchAfterTime += delta
		print(latchAfterTime)
		if latchAfterTime >= latchAfterDelay:
			latchAfter = false
	else:
		latchAfterTime = 0.0
	camBasis = cameraNODE.global_transform.basis
		
		
		
	playerInput = Vector3()
	playerInput = ((Input.get_action_strength("move_right")) - (Input.get_action_strength("move_left"))) * camBasis[0]
	playerInput += ((Input.get_action_strength("move_backwards")) - (Input.get_action_strength("move_forward"))) * camBasis[2]
	playerInput.y = 0
	if latched == false and movementType != 3:
		$TonguePiece.global_transform[3] = $KinematicBody.global_transform[3]
		$TonguePiece.rotation_degrees = $KinematicBody.rotation_degrees


	match movementType:
		1:
			var walk = Vector3()
			# Horizontal movement code. First, get the player's input.
			walk.x = WALK_FORCE * playerInput.x
			walk.z = WALK_FORCE * playerInput.z
			# Slow down the player if they're not trying to move.
			if abs(walk.x) < STOP_FORCE * 0.05:
				# The velocity, slowed down a bit, and then reassigned.
				velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
			else:
				velocity.x += walk.x * delta
			# Clamp to the maximum horizontal movement speed.
			velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)
			if abs(walk.z) < STOP_FORCE * 0.05:
				# The velocity, slowed down a bit, and then reassigned.
				velocity.z = move_toward(velocity.z, 0, STOP_FORCE * delta)
			else:
				velocity.z += walk.z * delta
			# Clamp to the maximum horizontal movement speed.
			velocity.z = clamp(velocity.z, -WALK_MAX_SPEED, WALK_MAX_SPEED)
			# Vertical movement code. Apply gravity.
			if $KinematicBody.is_on_floor() == false:
				velocity.y -= gravity * delta
				if wee == 0 and jumping == false:
					velocity.y = 0.0
					wee = 1



			#set jumps to base and jumphold to 0
			if $KinematicBody.is_on_floor():
				jumping = false
				wee = 0
				latchAfter = false
				jumps = baseJumps
				jumpHold = 0
			# Check for jumping. $KinematicBody.is_on_floor()() must be called after movement code. (for the first jump lol)
			if Input.is_action_just_pressed("jump") and jumps == baseJumps and $KinematicBody.is_on_floor():
				jumping = true
				#$JumpSound.play()
				velocity.y = JUMP_SPEED
				#then ya sub one. why? thats how the world works.
				jumps -= 1
			elif Input.is_action_just_pressed("jump") and jumps > 0 and jumps < baseJumps:
				jumping = true
				#$JumpSound.play()
				velocity.y = JUMP_SPEED
				#then ya sub one. why? thats how the world works.
				jumps -= 1
	# jumphold????
			if Input.is_action_pressed("jump") and velocity.y > 0 and $KinematicBody.is_on_floor() == false:
				#increment based on clamp, so you dont go fucking flying lmaooo
				jumpHold = clamp(jumpHold + ((delta/4.5)* jumpHoldInc), 0, .8)
				velocity.y += jumpHold



			$KinematicBody.move_and_slide(velocity, Vector3.UP)
			




	#             ANIMATIONS
	#
	#
	#
	#
	#
	#           BAYBEEEEEEEEEEEEEEEEEEEE
	#
	#
	#

			if direction == "right":
				$KinematicBody/icon.flip_h = false
			if direction == "left":
				$KinematicBody/icon.flip_h = true



			#to the right
			if Input.is_action_pressed("move_right"):
				direction = "right"
			#to the left
			if Input.is_action_pressed("move_left"):
				direction = "left"
			
			
			

			
			
			
			
			
			
			
			

			
			
			
			
			if playerInput != Vector3(0,0,0):
				playerAngle = fmod((rad2deg(atan2(playerInput.x,playerInput.z)) + 270), 360.0)
				$KinematicBody.rotation_degrees.y = playerAngle + 90





			if Input.is_action_just_pressed("fire1") and latchAfter == false:
				$TonguePiece.tongue()
			if Input.is_action_just_pressed("trigger") and $KinematicBody.is_on_floor():
				$TonguePiece.vault(velocity, playerInput)
		2:
			var walk = Vector3()
			# Horizontal movement code. First, get the player's input.
			velocity.x = 0.0
			velocity.z = 0.0
			if $KinematicBody.is_on_floor() == false:
				velocity.y -= gravity * delta
			
			velocity = $KinematicBody.move_and_slide(velocity, Vector3.UP)
			
			
			
			if Input.is_action_just_released("fire1"):
				$TonguePiece.reel()
			
			
			#set jumps to base and jumphold to 0
			if $KinematicBody.is_on_floor():
				jumping = false
				wee = 0
				latchAfter = false
				jumps = baseJumps
				jumpHold = 0
			# Check for jumping. $KinematicBody.is_on_floor()() must be called after movement code. (for the first jump lol)
			if Input.is_action_just_pressed("jump") and jumps == baseJumps and $KinematicBody.is_on_floor():
				jumping = true
				#$JumpSound.play()
				velocity.y = JUMP_SPEED
				#then ya sub one. why? thats how the world works.
				jumps -= 1
		3:
			print($TonguePiece.get_child_count())
			latchBroTime += delta
			if on:
				latchONTime += delta
			if latched == false and latchBroTime > latchBroTimeGoTo:
				latched = true
				while $TonguePiece.get_child_count() > 2:
					var destPos = $TonguePiece.get_child(0).global_transform[3]
					if $TonguePiece.get_child(0).get_node_or_null("Position3D") != null and $TonguePiece.get_child_count() > 2:
						var position3d = $TonguePiece.get_child(0).get_node("Position3D")
						$KinematicBody.global_transform[3] = position3d.global_transform[3]
					$KinematicBody.rotation_degrees.y = ($TonguePiece.get_child(0).rotation_degrees.y + playerAngle) + 90
					$TonguePiece.get_child(0).queue_free()
					yield(get_tree().create_timer(0.025),"timeout")
				on = true
			if $TonguePiece.get_child_count() == 2:
				on = true
				latched = true

			
			
			
			if Input.is_action_just_released("fire1") or latchONTime >= latchBroTimeUp or (Input.is_action_just_pressed("jump") and not on):
				velocity.y = 0
				latched = false
				$TonguePiece.reel()
				latchAfter = true
				on = false
			elif Input.is_action_just_pressed("jump") and on:
				var position3d = $TonguePiece.get_child(0).get_node_or_null("Position3D")
				if position3d != null:
					$KinematicBody.global_transform[3] = position3d.global_transform[3]
				jumpHoldInc = 0.0
				jumpHold = 0.0
				jumping = true
				latched = false
				#$JumpSound.play()
				velocity.y = JUMP_SPEED
				jumps -= 1
				$TonguePiece.reel()
				latchAfter = true
				on = false
		4:
			var walk = Vector3()
			# Slow down the player if they're not trying to move.
			if abs(walk.x) < STOP_FORCE * 0.05:
				# The velocity, slowed down a bit, and then reassigned.
				velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
			else:
				velocity.x += walk.x * delta
			# Clamp to the maximum horizontal movement speed.
			velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)
			if abs(walk.z) < STOP_FORCE * 0.05:
				# The velocity, slowed down a bit, and then reassigned.
				velocity.z = move_toward(velocity.z, 0, STOP_FORCE * delta)
			else:
				velocity.z += walk.z * delta
			# Clamp to the maximum horizontal movement speed.
			velocity.z = clamp(velocity.z, -WALK_MAX_SPEED, WALK_MAX_SPEED)
			# Vertical movement code. Apply gravity.
			if $KinematicBody.is_on_floor() == false:
				velocity.y -= gravity * delta
				if wee == 0 and jumping == false:
					velocity.y = 0.0
					wee = 1
			
			velocity = $KinematicBody.move_and_slide(velocity, Vector3.UP)
			jumpHoldInc = 0.0
			jumpHold = 0.0
			latched = false
			latchAfter = true
			on = false
func tongueTouchArea(area):
	print(area.name)

func tongueTouchBody(body):
	if body != $KinematicBody:
		print(body.name)
		if latched == false:
			latchBroTime = 0.0
			latchONTime = 0.0
			$TonguePiece.latch()
