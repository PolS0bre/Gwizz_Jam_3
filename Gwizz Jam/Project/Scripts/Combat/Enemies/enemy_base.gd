extends Node3D

var attack_speed = 1.0
var attack_dmg = 1.0
var direction = []
var att_type = []
var sprites_enemy = [
	preload("res://Sprites/Enemies/Alan.png"),
	preload("res://Sprites/Enemies/Glep.png"),
	preload("res://Sprites/Enemies/MrFrog.png")
]
var enemy_icons = [
	preload("res://Sprites/Enemies/Alan Icon.png"),
	preload("res://Sprites/Enemies/Glep Icon.png"),
	preload("res://Sprites/Enemies/MrFrog Icon.png")
]

var origin_pos
var is_blocking = false
var health = 100
var timer_att = 3.5
var rng
var att_pos = [
	Vector3(-0.15, 0, 0),
	Vector3(0.15, 0, 0),
	Vector3(0, 0.1175, 0),
	Vector3(0, -0.1175, 0)
]
@onready var CombatManager = $".."

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	rng.randomize()
	rng.randomize()
	var index_enemy = randi_range(0, sprites_enemy.size()-1)
	$Sprite3D.texture = sprites_enemy[index_enemy]
	origin_pos = position
	CombatManager.enemy = self
	CombatManager.general_UI.get_child(1, false).texture = enemy_icons[index_enemy]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if CombatManager.finished == false:
		#Player is attacking ==> ENEMY DEFEND
		if CombatManager.attacking:
			
			pass
		#Player is defending ==> ENEMY ATTACK
		else:
			if !CombatManager.to_attack && direction.size() != 4:
				rng.randomize() 
				while direction.size() != 4:
					att_type.push_back(rng.randi_range(0, 3))
					direction.push_back(rng.randi_range(0, 3))
				CombatManager.to_attack = true
				await get_tree().create_timer(2.5).timeout
			elif CombatManager.to_attack && !CombatManager.in_action:
				CombatManager.in_action = true
				CombatManager.spawn_att(att_type, direction)

func heal(hp_add):
	var prev_health = health
	health += hp_add
	if health > 100:
		health = 100
		
	CombatManager.player.Enemy_Bar.get_child(0, false).value = health
	
	if prev_health < health:
		CombatManager.player.Enemy_Bar.get_child(1, false).start()
	else:
		CombatManager.player.Enemy_Bar.value = health

func _on_area_3d_body_entered(body):
	var dead = false
	if CombatManager.attacking:
		var punch_dmg = body.get_parent().get_damage()
		
		CombatManager.was_hit = true
		
		var prev_hp = health
		
		health -= punch_dmg
		CombatManager.player.Enemy_Bar.value = health
		
		if health < 0:
			health = 0
		
		var instance = CombatManager.hit_obj.instantiate()
		var pos = body.position
		instance.position = pos
		add_child(instance)
		$"../SFX_Audio".stream = load("res://Audio/Punch.mp3")
		$"../SFX_Audio".volume_db = 12.0
		$"../SFX_Audio".play()
		
		if prev_hp > health:
			CombatManager.player.Enemy_Bar.get_child(1, false).start()
		else:
			CombatManager.player.Enemy_Bar.get_child(0, false).value = health
		
		CombatManager.player_hit += 1
		if health > 0:
			pass
		elif health <= 0 && !dead:
			CombatManager.winner = 1
			CombatManager.finished = true
			dead = true

func defend(attack):
		rng.randomize()
		var number = rng.randf_range(0, 100)
		
		await get_tree().create_timer(0.275).timeout
		
		if number <= 18:
			position = origin_pos + att_pos[attack]
		else:
			var direction_move = 5
			while direction_move == 5 || direction_move == attack:
				direction_move = rng.randi_range(0, 3)
			position = origin_pos + att_pos[direction_move]
			
		await get_tree().create_timer(1.0).timeout
		position = origin_pos
