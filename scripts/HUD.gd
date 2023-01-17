extends CanvasLayer

signal start_game
signal game_ready

func _ready():
	$Message.text = "Destroy and Dodge the Asteroids!"

func update_score(score):
	$Score.text = str(score)

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$Message.text = "Destroy and Dodge the Asteroids!"
	$Message.show()
	$Instructions.show()
	$InstructionsController.show()
	$InstructionsStart.show()
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	emit_signal("game_ready")

func _on_MessageTimer_timeout():
	$Message.hide()

func _on_StartButton_pressed():
	$StartButton.hide()
	$Instructions.hide()
	$InstructionsStart.hide()
	$InstructionsController.hide()
	emit_signal("start_game")
