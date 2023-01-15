extends RigidBody2D

signal asteroid_destroyed

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var asteroid_image_location = "res://art/asteroid" + str(rng.randi_range(1, 3)) +".png"
	var image = load(asteroid_image_location)
	$Sprite.texture = image

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Area2D_body_entered(body):
	if !("Asteroid" in body.name) && ("Torpedo" in body.name):
		emit_signal("asteroid_destroyed")
		queue_free()
