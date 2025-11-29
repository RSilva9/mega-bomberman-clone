extends CharacterBody2D

const SPEED = 85.0
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D
var bomb = preload("res://scenes/bomb.tscn")


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity.x = direction.x * SPEED
		animate(direction)
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		anim_sprite.play("idle_front")
		
	move_and_slide()


func animate(direction: Vector2):
	if direction.x > 0:
		anim_sprite.flip_h = true
		anim_sprite.play("walk_side")
	elif direction.x < 0:
		anim_sprite.flip_h = false
		anim_sprite.play("walk_side")
	elif direction.y < 0:
		anim_sprite.play("walk_back")
	elif direction.y > 0:
		anim_sprite.play("walk_front")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("place_bomb"):
		if !area_2d.has_overlapping_bodies():
			var bomb_instance = bomb.instantiate()
			get_tree().root.add_child(bomb_instance)
			bomb_instance.place_bomb(global_position)
