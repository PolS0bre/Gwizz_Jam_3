extends Node3D

var tut_pos = 0

var final_pos = false

@onready var child_nodes = get_children(false)
var UI_Nodes
var videoPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	UI_Nodes = [child_nodes[0], child_nodes[1], child_nodes[2]]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("move_left"):
		if tut_pos > 0:
			tut_pos -= 1
			for child in UI_Nodes:
				child.visible = false
			child_nodes[tut_pos].visible = true
			
			for grandson in child_nodes[tut_pos].get_children(false):
				if grandson.name == "VideoStreamPlayer":
					if videoPlayer != null:
						videoPlayer.stop()
					videoPlayer = grandson
					videoPlayer.play()
			
			final_pos = false
		
	elif Input.is_action_just_pressed("move_right"):
		if tut_pos < UI_Nodes.size() - 1:
			tut_pos += 1
			for child in UI_Nodes:
				child.visible = false
			child_nodes[tut_pos].visible = true
			
			for grandson in child_nodes[tut_pos].get_children(false):
				if grandson.name == "VideoStreamPlayer":
					if videoPlayer != null:
						videoPlayer.stop()
					videoPlayer = grandson
					videoPlayer.play()
			
			if tut_pos == UI_Nodes.size() - 1:
				final_pos = true
	
	if Input.is_action_just_pressed("cross"):
		if final_pos:
			Transition.change_scene("res://Scenes/test_level_combat.tscn")
