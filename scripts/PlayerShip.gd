extends Area2D

signal ship_hit
signal torpedo_fired

export var speed = 8
export var rotation_speed = 100
export var max_speed = 200

var velocity
var screen_size

func _ready():
	hide()
	screen_size = get_viewport_rect().size
	velocity = Vector2.ZERO

func _process(delta):
	var input_detected = false
	if Input.is_action_pressed("move_right") && velocity.x + speed < max_speed:
		velocity.x += speed
		input_detected = true
	if Input.is_action_pressed("move_left") && velocity.x - speed > max_speed * -1:
		velocity.x -= speed
		input_detected = true
	if Input.is_action_pressed("move_down") && velocity.y + speed < max_speed:
		velocity.y += speed
		input_detected = true
	if Input.is_action_pressed("move_up") && velocity.y - speed > max_speed * -1:
		velocity.y -= speed
		input_detected = true
	if Input.is_action_pressed("rotate_right"):
		rotation += (PI / 64)
	if Input.is_action_pressed("rotate_left"):
		rotation -= (PI / 64)
	if Input.is_action_just_pressed("fire_gun"):
		fire_weapon()
	
	if velocity.length() > 0:
		position += velocity * delta
		$AnimatedSprite.play()
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)
	$AnimatedSprite.play()
	
	if input_detected:
		$AnimatedSprite.play()
		$AnimatedSprite.animation = "engine_on"
	else:
		$AnimatedSprite.animation = "idle"

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func fire_weapon():
	emit_signal("torpedo_fired")


func _on_PlayerShip_body_entered(body):
	if !("Torpedo" in body.name):
		hide()
		emit_signal("ship_hit")
		$ShipDestroyed.play()
		$CollisionShape2D.set_deferred("disabled", true)
