extends Node3D

var attack_speed = 1.0
var attack_dmg = 1.0
var direction = []
var att_type = []
var direction_sprites = [
	preload("res://Sprites/Button_Icons/Left_Icon.png"),
	preload("res://Sprites/Button_Icons/Right_Icon.png"),
	preload("res://Sprites/Button_Icons/Up_Icon.png"),
	preload("res://Sprites/Button_Icons/Down_Icon.png")
]
var attack_sprites = [
	preload("res://Sprites/Button_Icons/X_Icon.png"),
	preload("res://Sprites/Button_Icons/Tri_Icon.png"),
	preload("res://Sprites/Button_Icons/Circ_Icon.png"),
	preload("res://Sprites/Button_Icons/Square_Icon.png"),
]

var origin_pos
var is_blocking = false
var health

@onready var CombatManager = $".."
@onready var Att_UI = $GUI/Attack_UI
@onready var Def_UI = $GUI/Defense_UI
@onready var General_UI = $GUI/General_UI

@onready var Player_Bar = $GUI/General_UI/PlayHPBar
@onready var Enemy_Bar = $GUI/General_UI/EnemyHPBar

@export var randomStrength: float = 0.075
@export var shakeFade: float = 4.0
var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0

func _ready():
	origin_pos = position
	health = 100
	CombatManager.player = self
	CombatManager.general_UI = $GUI/General_UI

func apply_shake():
	shake_strength = randomStrength

func randomOffset() -> Vector3:
	return Vector3(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength), 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if CombatManager.finished == false:
		if shake_strength > 0:
			shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
			$Camera3D.h_offset = randomOffset().x
			$Camera3D.v_offset = randomOffset().y
		
	#Player Attacking
		if CombatManager.attacking:
			position = lerp(position, origin_pos, 0.15)
			if direction.size() < 4 && !CombatManager.to_attack:
				get_attack()
			elif direction.size() == 4 && !CombatManager.to_attack:
				CombatManager.to_attack = true
			elif CombatManager.to_attack && !CombatManager.in_action:
				CombatManager.in_action = true
				CombatManager.spawn_att(att_type, direction)
	#Player Defending
		else:
			if Input.is_action_pressed("move_left"):
				position = lerp(position, origin_pos + Vector3(-0.15, 0, 0), 0.15)
			elif Input.is_action_pressed("move_right"):
				position = lerp(position, origin_pos + Vector3(0.15, 0, 0), 0.15)
			elif Input.is_action_pressed("move_back"):
				position = lerp(position, origin_pos + Vector3(0, -0.15, 0), 0.15)
			else:
				position = lerp(position, origin_pos, 0.15)
	else:
		if Input.is_action_just_pressed("cross"):
			Transition.change_scene("res://Scenes/test_level_overworld.tscn")

func update_att_ui():
	var dir_index = 0
	var att_index = 0
	for directions in direction:
		Att_UI.get_child(dir_index + 1, false).texture = direction_sprites[directions]
		dir_index += 1
	
	for attack in att_type:
		Att_UI.get_child(att_index + 5, false).texture = attack_sprites[attack]
		att_index += 1

func get_attack():
	#Check left attacks
	if Input.is_action_pressed("move_left"):
		if Input.is_action_just_pressed("cross"):
			direction.push_back(0)
			att_type.push_back(0)
			update_att_ui()
		elif Input.is_action_just_pressed("uppercut"):
			direction.push_back(0)
			att_type.push_back(1)
			update_att_ui()
		elif Input.is_action_just_pressed("hook"):
			direction.push_back(0)
			att_type.push_back(2)
			update_att_ui()
		elif Input.is_action_just_pressed("jab"):
			direction.push_back(0)
			att_type.push_back(3)
			update_att_ui()
	#Check Right attacks
	elif  Input.is_action_pressed("move_right"):
		if Input.is_action_just_pressed("cross"):
			direction.push_back(1)
			att_type.push_back(0)
			update_att_ui()
		elif Input.is_action_just_pressed("uppercut"):
			direction.push_back(1)
			att_type.push_back(1)
			update_att_ui()
		elif Input.is_action_just_pressed("hook"):
			direction.push_back(1)
			att_type.push_back(2)
			update_att_ui()
		elif Input.is_action_just_pressed("jab"):
			direction.push_back(1)
			att_type.push_back(3)
			update_att_ui()
	#Check Up attacks
	elif  Input.is_action_pressed("move_front"):
		if Input.is_action_just_pressed("cross"):
			direction.push_back(2)
			att_type.push_back(0)
			update_att_ui()
		elif Input.is_action_just_pressed("uppercut"):
			direction.push_back(2)
			att_type.push_back(1)
			update_att_ui()
		elif Input.is_action_just_pressed("hook"):
			direction.push_back(2)
			att_type.push_back(2)
			update_att_ui()
		elif Input.is_action_just_pressed("jab"):
			direction.push_back(2)
			att_type.push_back(3)
			update_att_ui()
	#Check Down attacks
	elif  Input.is_action_pressed("move_back"):
		if Input.is_action_just_pressed("cross"):
			direction.push_back(3)
			att_type.push_back(0)
			update_att_ui()
		elif Input.is_action_just_pressed("uppercut"):
			direction.push_back(3)
			att_type.push_back(1)
			update_att_ui()
		elif Input.is_action_just_pressed("hook"):
			direction.push_back(3)
			att_type.push_back(2)
			update_att_ui()
		elif Input.is_action_just_pressed("jab"):
			direction.push_back(3)
			att_type.push_back(3)
			update_att_ui()


func heal(hp_add):
	var prev_health = health
	health += hp_add
	if health > 100:
		health = 100
	
	Player_Bar.get_child(0, false).value = health
	
	if prev_health < health:
		Player_Bar.get_child(1, false).start()
	else:
		Player_Bar.value = health

func _on_collision_area_body_entered(body):
	var dead = false
	if !CombatManager.attacking:
		var punch_dmg = body.get_parent().get_damage()
		
		CombatManager.was_hit = true
		
		var prev_hp = health
		
		health -= punch_dmg
		Player_Bar.value = health
		
		$"../SFX_Audio".stream = load("res://Audio/Punch.mp3")
		$"../SFX_Audio".volume_db = 12.0
		$"../SFX_Audio".play()
		apply_shake()
		
		if health < 0:
			health = 0
		
		if prev_hp > health:
			Player_Bar.get_child(1, false).start()
		else:
			Player_Bar.get_child(0, false).value = health
		
		CombatManager.enemy_hit += 1
		if health > 0:
			pass
		elif health <= 0 && !dead:
			CombatManager.winner = 2
			CombatManager.finished = true
			dead = true

func _on_player_timer_timeout():
	Player_Bar.get_child(0, false).value = health
	Player_Bar.value = health

func _on_enemy_timer_timeout():
	Enemy_Bar.get_child(0, false).value = CombatManager.enemy.health
	Enemy_Bar.value = CombatManager.enemy.health
