extends Node3D

var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = $Timer
	timer.start()



func _on_timer_timeout():
	queue_free()
