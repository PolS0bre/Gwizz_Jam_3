extends Node3D
class_name Punch

var damage
var speed
var lifetime = 4.0

@onready var CombatManager = $".."

func get_damage():
	return damage
