extends Spatial


export var playerPath = NodePath()
onready var player = get_node(playerPath)
onready var playerBODY = player.get_child(0)

func _process(delta):
	translation = player.translation + playerBODY.translation


	var playerInput = Vector2()
	playerInput.x =  (Input.get_action_strength("rstickright")) - (Input.get_action_strength("rstickleft"))
	playerInput.y =  (Input.get_action_strength("rstickdown")) - (Input.get_action_strength("rstickup"))
	
	rotation_degrees.y += playerInput.x


