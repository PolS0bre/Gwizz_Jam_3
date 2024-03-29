extends Node3D
class_name Boxer

var attack_speed = 1.0
var attack_dmg = 1.0
var direction = []
var att_type = []

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
	origin_pos = position
	CombatManager.enemy = self
	
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
	pass

func _on_area_3d_body_entered(body):
	if CombatManager.attacking:		
		var instance = CombatManager.hit_obj.instantiate()
		var pos = body.position
		instance.position = pos
		add_child(instance)
		$"../SFX_Audio".stream = load("res://Audio/Punch.mp3")
		$"../SFX_Audio".volume_db = 12.0
		$"../SFX_Audio".play()

func defend(attack):
	pass
