extends CharacterBody2D

const SPEED = 125.0
const JUMP_VELOCITY = -300.0
const DECELERATION = 800.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("water_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get input direction
	var direction := Input.get_axis("water_move_left", "water_move_right")

	# Flip Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play Animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	# Movement & Deceleration
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)

	move_and_slide()
