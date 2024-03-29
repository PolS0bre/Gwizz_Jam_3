extends Punch

var spawn_position = []
var time_move

# Called when the node enters the scene tree for the first time.
func _ready():
	damage = 10
	if CombatManager.attacking:
		speed = -5.65
		rotate_y(deg_to_rad(90))
	else:
		speed = 5.65
		rotate_y(deg_to_rad(-90))
	time_move = 0.1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(time_move <= 0.0):
		position =  position + (-Vector3.FORWARD * speed * delta)
	else:
		time_move -= delta
	
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()
