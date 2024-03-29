extends CharacterBody3D


const SPEED = 5.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var cam_focus = $Camera_focus
@onready var visual = $Player_Sprite
@onready var dialog_canvas = $"../DialogCanvas"

var iso_angles
var interact_obj
var is_interacting

func _ready():
	iso_angles = deg_to_rad(45)
	interact_obj = null
	
func _physics_process(delta):
	if !is_interacting:
		handle_cam()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("move_left", "move_right", "move_front", "move_back")
	
		if input_dir != Vector2(0,0):
			var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			direction = direction.rotated(Vector3(0, 1, 0), iso_angles)
			if direction:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
		
			move_and_slide()
	
		if Input.is_action_just_pressed("cross"):
			if interact_obj != null:
				is_interacting = true
				interact_obj.action_interact()
	else:
		if Input.is_action_just_pressed("cross"):
			dialog_canvas.visible = false
			is_interacting = false

func handle_cam():
	if Input.is_action_just_pressed("cam_left"):
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(
			self,
			"rotation:y",
			self.rotation.y + PI/2,
			0.5
		)
	elif Input.is_action_just_pressed("cam_right"):
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(
			self,
			"rotation:y",
			self.rotation.y - PI/2,
			0.5
		)


func _on_interact_area_body_entered(body):
	if body.is_in_group("Interactible"):
		body.get_parent().get_node("Interact_Icon").visible = true
		interact_obj = body.get_parent()


func _on_interact_area_body_exited(body):
	if body.is_in_group("Interactible"):
		body.get_parent().get_node("Interact_Icon").visible = false
		interact_obj = null
