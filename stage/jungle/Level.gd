extends Spatial

export var playerPath = NodePath()
onready var player = get_node(playerPath)


var playerCheckpoint = 0


func _ready():
	$Music.play()
	player.get_node("PlayerBody").global_transform[3] = $start.global_transform[3]
	var i = 0
	while i < $Checkpoints.get_child_count():
		var checkpoint = $Checkpoints.get_child(i)
		if checkpoint.get_child_count() > 0:
			var collide = checkpoint.get_child(0)
			collide.connect("body_entered", self, "area", [i + 1])
		i += 1


func _process(delta):
	$BG.global_transform[3] = player.get_node("PlayerBody").global_transform[3] * .85
	$BG.global_transform[3].y = 104.813

func area(body, idx):
	if body == player.get_node("PlayerBody"):
		playerCheckpoint = idx



func _on_death_body_entered(body):
	if body == player.get_node("PlayerBody"):
		body.global_transform[3] = $Checkpoints.get_child(playerCheckpoint - 1).global_transform[3]
		player.velocity = Vector3()
