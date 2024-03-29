extends Node3D

@export var world_sprite : Texture
@export var icon_sprite : Texture
@export var username : String
@export var phrase : String

@onready var dialog_canvas = $"../DialogCanvas"

func _ready():
	$Sprite_Character.texture = world_sprite

func action_interact():
	dialog_canvas.get_child(0, false).text = username
	dialog_canvas.get_child(1, false).text = phrase
	dialog_canvas.get_child(2, false).texture = icon_sprite
	dialog_canvas.visible = true
