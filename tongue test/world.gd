extends Spatial

export var playerPath = NodePath()
onready var player = get_node(playerPath)





var shopped = false
var shopUp = false

const shop = preload("res://scenes/shop/ShopScene.tscn")
var shopNode = Node


func _process(delta):
	

	if (Input.is_action_just_pressed("fire1") and shopUp == true):
		move("close")


func move(way):
	match way:
		"open":
			player.movementType = 0
			shopUp = true
			shopped = true
			shopNode = shop.instance()
			add_child(shopNode)
			shopNode.get_node("ShopScene").get_node("AnimationPlayer").play("in")
		"close":
			shopNode.get_node("ShopScene").get_node("AnimationPlayer").play("out")
			yield(get_tree().create_timer(.6),"timeout")
			shopNode.queue_free()
			shopUp = false
			player.movementType = 1


func _on_Area_body_entered(body):
	if body == player.get_node("PlayerBody") and shopUp != true:
		move("open")
		player.movementType = 4
		shopUp = true
		shopped = true


func _on_DisableArea_body_exited(body):
		shopped = false
		move("close")


func _on_Area_body_exited(body):
	if body == player.get_node("PlayerBody"):
		shopped = false
