extends Node

var attacking = true
var in_action = false
var to_attack = false
var finished = false
var winner = 0

var round = 1
var boxes = 0
var was_hit = false

var enemy_hit = 0
var player_hit = 0

var player
var enemy
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

@onready var hit_obj = preload("res://Objects/Combat/sprite_hit.tscn")

@onready var empty_sprite = preload("res://Sprites/Button_Icons/Empty.png")

var att_type


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
	if boxes == 8:
		change_round()
	else:
		boxes += 1
		if !was_hit:
			attacking = !attacking
		else:
			was_hit = false
		
		for index in range(1, 9):
			player.Att_UI.get_child(index, false).texture = empty_sprite
		
		if !finished:
			player.Att_UI.visible = attacking
			player.Def_UI.visible = !attacking
			to_attack = false
			in_action = false

func change_round():
	if !finished:
		round += 1
		player.General_UI.get_child(5, false).text = "ROUND " + str(round)
		attacking = !attacking
		player.Att_UI.visible = attacking
		player.Def_UI.visible = !attacking
		$"SFX_Audio".volume_db = -10.0
		$"SFX_Audio".stream = load("res://Audio/Round End.mp3")
		$"SFX_Audio".play()
		await get_tree().create_timer(2.5).timeout
		boxes = 0
		player.heal(20)
		enemy.heal(20)
		was_hit = false
		to_attack = false
		in_action = false
	
	if round == 5:
		if player_hit > enemy_hit:
			finished = true
			winner = 1
			Transition.change_scene("res://Scenes/test_level_overworld.tscn")
		elif player_hit == enemy_hit:
			finished = true
			winner = 0
			Transition.change_scene("res://Scenes/test_level_overworld.tscn")
		else:
			finished = true
			winner = 2
			Transition.change_scene("res://Scenes/test_level_overworld.tscn")
