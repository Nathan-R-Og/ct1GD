extends Node2D


func _ready():
	OS.window_fullscreen = true

func _on_Button_pressed():
	get_tree().change_scene("res://stage/stage.tscn")
