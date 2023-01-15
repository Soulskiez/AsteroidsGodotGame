extends Area2D

signal collectable_collected

func _on_Collectable_area_entered(area):
	if ("PlayerShip" in area.name):
		emit_signal("collectable_collected")
		queue_free()
