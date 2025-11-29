extends Node2D

@onready var center: Sprite2D = $Center
@onready var middle: Sprite2D = $Middle
@onready var end: Sprite2D = $End
@onready var tilemap = get_tree().current_scene.get_node("TileMapLayer")
@export var max_distance = 2
const TILE_SIZE: int = 32


func _ready() -> void:
	expand_explosion()
	await get_tree().create_timer(1.0).timeout
	self.queue_free()


func expand_explosion():
	var directions = [
		{ "dir": Vector2(0, -1), "rot": -90 },
		{ "dir": Vector2(0,  1), "rot":  90 },
		{ "dir": Vector2(-1, 0), "rot": 180 },
		{ "dir": Vector2( 1, 0), "rot":   0 },
	]
	for data in directions:
		for step in range(1, max_distance + 1):
			var offset = data.dir * step * TILE_SIZE
			var world_pos = center.global_position + offset
			var cell = tilemap.local_to_map(world_pos)
			var tile_data = tilemap.get_cell_tile_data(cell)
			
			if(tile_data == null):
				if(step < max_distance):
					spawn_explosion_piece(world_pos, data.rot)
				else:
					spawn_explosion_end(world_pos, data.rot)
				continue
			
			var breakable = tile_data.get_custom_data("breakable")
			if breakable:
				tilemap.set_cell(cell, -1)  # Borra la celda
				spawn_explosion_end(world_pos, data.rot)
				break
			else:
				break


func spawn_explosion_piece(pos: Vector2, rot: float):
	var piece = middle.duplicate()
	add_child(piece)
	piece.visible = true
	piece.global_position = pos
	piece.rotation_degrees = rot

func spawn_explosion_end(pos: Vector2, rot: float):
	var piece = end.duplicate()
	add_child(piece)
	piece.visible = true
	piece.global_position = pos
	piece.rotation_degrees = rot

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(!body.exploded):
		body.explode()
