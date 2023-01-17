extends Node

export(PackedScene) var torpedo_scene
export(PackedScene) var asteroid_scene
export(PackedScene) var player_ship_scene
export(PackedScene) var collectable_scene
var torpedo_speed = 400
var is_game_over = true
var score
var game_ready = true

func _ready():
	randomize()

func _unhandled_input(event):
	if((event is InputEventJoypadButton && event.button_index == 11 || event is InputEventKey && event.scancode == KEY_SPACE) && game_ready):
		$HUD._on_StartButton_pressed()

func toggle_game_ready():
	game_ready = !game_ready

func new_game():
	toggle_game_ready()
	$Music.play()
	is_game_over = false
	$PlayerShip.start($StartPosition.position)
	$StartTimer.start()
	$PlayerShip.velocity = Vector2.ZERO
	$PlayerShip.rotation = 0
	$HUD.show_message("Get Ready")
	score = 0
	$HUD.update_score(score)
	get_tree().call_group("collectables", "queue_free")
	get_tree().call_group("asteroids", "queue_free")

func increment_score():
	score += 1
	$HUD.update_score(score)
	$AsteroidDestroyed.play()
	if score % 5 == 0:
		spawn_collectable()

func game_over():
	$AsteroidTimer.stop()
	$HUD.show_game_over()
	is_game_over = true
	get_tree().call_group("collectables", "queue_free")

func collectable_collected():
	score += 5
	$HUD.update_score(score)
	$GemCollected.play()

func fire_torpedo():
	if(!is_game_over):
		var torpedo = torpedo_scene.instance()
		var playerShip = get_node("PlayerShip")
		var torpedo_spawn_location = playerShip.position
		var direction = $PlayerShip.rotation
		var torpedo_velocity = Vector2(sin(direction) * torpedo_speed, -cos(direction) * torpedo_speed)
		torpedo.position = torpedo_spawn_location
		torpedo.rotation = direction
		torpedo.linear_velocity = torpedo_velocity
		add_child(torpedo)
		$ShipFire.play()

func spawn_collectable(): 
	var collectable = collectable_scene.instance()
	collectable.connect("collectable_collected", self, "collectable_collected")
	var screenSize = get_viewport().get_visible_rect().size
	var rndX = rand_range(0, screenSize.x)
	var rndY = rand_range(0, screenSize.y)
	collectable.position = Vector2(rndX, rndY)
	call_deferred("add_child", collectable)

func _on_AsteroidTimer_timeout():
	var asteroid = asteroid_scene.instance()
	asteroid.connect("asteroid_destroyed", self, "increment_score")
	var asteroid_spawn_location = get_node("AsteroidPath/AsteroidSpawnLocation")
	asteroid_spawn_location.offset = randi()
	
	var direction = asteroid_spawn_location.rotation + PI / 2
	asteroid.position = asteroid_spawn_location.position
	direction += rand_range(-PI / 4, PI /4)
	asteroid.rotation = direction
	
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	asteroid.linear_velocity = velocity.rotated(direction)
	
	add_child(asteroid)

func _on_StartTimer_timeout():
	$AsteroidTimer.start()
