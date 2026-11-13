extends CharacterBody2D

enum State { LEFT, RIGHT, IDLE }

@export var speed: float = 100.0
@export var time_between_moves: float = 2.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_right: RayCast2D = $RayCastRight
@onready var ray_left: RayCast2D = $RayCastLeft

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_state: State = State.IDLE
var decision_timer: float = 0.0
var direction: int = 0

func _physics_process(delta: float) -> void:
	# 1. Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Pick a new direction when the timer runs out
	decision_timer -= delta
	if decision_timer <= 0.0:
		decision_timer = time_between_moves
		current_state = State.values().pick_random()

	if current_state == State.RIGHT and ray_right.is_colliding():
		current_state = State.LEFT
		decision_timer = time_between_moves
	elif current_state == State.LEFT and ray_left.is_colliding():
		current_state = State.RIGHT
		decision_timer = time_between_moves

	# 4. Update animations and movement direction
	match current_state:
		State.LEFT:
			animated_sprite.flip_h = false
			animated_sprite.play("run")
			direction = -1
		State.RIGHT:
			animated_sprite.flip_h = true
			animated_sprite.play("run")
			direction = 1
		State.IDLE:
			animated_sprite.play("idle")
			direction = 0

	# 5. Move the character
	velocity.x = direction * speed
	move_and_slide()
