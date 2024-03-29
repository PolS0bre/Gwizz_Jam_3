extends CanvasLayer

var changed = false
@onready var CombatManager = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if CombatManager.finished && !changed:
		$"../Combat_Audio".stop()
		$"../SFX_Audio".volume_db = -5.0
		match CombatManager.winner:
			0:#draw
				$WinLose.texture = load("res://Sprites/UI/Empate Box.png")
				$"../SFX_Audio".stream = load("res://Audio/Round End.mp3")
				$"../SFX_Audio".play()
				$WinLose/WL_Text.text = "DRAW"
			1:#player win
				$WinLose.texture = load("res://Sprites/UI/Win Box.png")
				$"../SFX_Audio".stream = load("res://Audio/Win Sound.mp3")
				$"../SFX_Audio".play()
				$WinLose/WL_Text.text = "YOU WIN"
			2:#enemy win
				$WinLose.texture = load("res://Sprites/UI/Lose Box.png")
				$"../SFX_Audio".stream = load("res://Audio/Lose Sound.mp3")
				$"../SFX_Audio".play()
				$WinLose/WL_Text.text = "YOU LOSE"
			_:
				pass
		$AnimationPlayer.play('winner')
		changed = true
