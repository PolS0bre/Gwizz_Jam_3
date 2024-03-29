extends Node3D

var attacking = true
var in_action = false
var to_attack = false
var finished = false
var player
var enemy
var timer_change = 5.0

var general_UI

var att_pos = [
	Vector3(-0.15, 0, 0),
	Vector3(0.15, 0, 0),
	Vector3(0, 0.1175, 0),
	Vector3(0, -0.1175, 0)
]
var attack_types = [
	preload("res://Objects/Combat/Punches/cross.tscn"),
	preload("res://Objects/Combat/Punches/uppercut.tscn"),
	preload("res://Objects/Combat/Punches/hook.tscn"),
	preload("res://Objects/Combat/Punches/jab.tscn")
]
@onready var empty_sprite = preload("res://Sprites/Button_Icons/Empty.png")
@onready var hit_obj = preload("res://Objects/Combat/sprite_hit.tscn")

func _ready():
	player.General_UI.visible = false
	player.Def_UI.visible = false
	player.Att_UI.get_child(9, false).visible = false

func spawn_att(punches, direction):
	await get_tree().create_timer(0.5).timeout
	player.Att_UI.visible = false
	if attacking:
		var index = 0
		for punch in punches:
			var instance = attack_types[punch].instantiate()
			var pos = att_pos[direction[index]] + Vector3(0, 1.2175, 1.25)
			instance.position = pos
			add_child(instance)
			index = index + 1
			enemy.defend(direction[index-1])
			await get_tree().create_timer(0.5).timeout
	else:
		var index = 0
		for punch in punches:
			var instance = attack_types[punch].instantiate()
			var pos = att_pos[direction[index]] + Vector3(0, 1.2175, -1.25)
			instance.position = pos
			add_child(instance)
			index = index + 1
			await get_tree().create_timer(0.5).timeout
	await get_tree().create_timer(3.5).timeout
	punches.clear()
	direction.clear()
	
	for index in range(1, 9):
		player.Att_UI.get_child(index, false).texture = empty_sprite
		
	if !finished:
		player.Att_UI.visible = attacking
		to_attack = false
		in_action = false
		
func _process(delta):
	if Input.is_action_just_pressed("change_att") && timer_change <= 0.0:
		player.Att_UI.visible = !attacking
		await get_tree().create_timer(0.5).timeout
		attacking = !attacking
		timer_change = 5.0
		
	if Input.is_action_just_pressed("quit") && timer_change <= 0.0:
		Transition.change_scene("res://Scenes/test_level_overworld.tscn")
	
	timer_change -= delta
