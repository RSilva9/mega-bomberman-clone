extends StaticBody2D

@onready var area_2d: Area2D = $Area2D
var exploded: bool = false
const TILE_SIZE: int = 32
const EXPLOSION = preload("res://scenes/explosion.tscn")

func _on_area_2d_body_exited(body: Node2D) -> void:
	collision_layer += 2

func place_bomb(pos: Vector2):
	global_position = snap_to_grid(pos)
	await get_tree().create_timer(2.0).timeout
	if(!exploded):
		explode()

func explode():
	exploded = true
	call_deferred("add_child", EXPLOSION.instantiate())
	await get_tree().create_timer(1.0).timeout
	self.queue_free()

func snap_to_grid(pos: Vector2) -> Vector2:
	return Vector2(
		floor(pos.x / TILE_SIZE) * TILE_SIZE,
		floor(pos.y / TILE_SIZE) * TILE_SIZE
	)
