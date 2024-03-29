extends Node3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("cross"):
		Transition.change_scene("res://Scenes/test_level_overworld.tscn")
