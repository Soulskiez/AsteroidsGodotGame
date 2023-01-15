extends RigidBody2D

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Area2D_body_entered(body):
	if ("Asteroid" in body.name) && !("Torpedo" in body.name):
		queue_free()
