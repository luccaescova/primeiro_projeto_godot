extends CharacterBody2D

enum PlayerState {
	idle,
	walk,
	jump,
	fall
}


@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@export var max_speed = 180.0
@export var acceleration = 100
@export var desceleration = 100
const JUMP_VELOCITY = -300.0

var jump_count = 0
@export var max_jump_count = 2
var status: PlayerState


func move(delta):
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, desceleration * delta)
	if direction < 0:
		anim.flip_h = true
	elif direction > 0:
		anim.flip_h = false	
		


func _ready() -> void:
	go_to_idle_state()

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match status:
		PlayerState.idle:
			idle_state(delta)
		PlayerState.walk:
			walk_state(delta)	
		PlayerState.jump:
			jump_state(delta)
		PlayerState.fall:
			fall_state(delta)
	move_and_slide()

func go_to_idle_state():
	status = PlayerState.idle
	anim.play("idle")
	
func go_to_walk_state():
	status = PlayerState.walk
	anim.play("walk")
	
func go_to_jump_state():
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY
	jump_count += 1
	
func go_to_fall_state():
	status = PlayerState.fall
	anim.play("fall")
	
func idle_state(delta):
	move(delta)
	if velocity.x != 0:
		go_to_walk_state()
		return
	
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
	
	
func walk_state(delta):
	move(delta)
	if velocity.x == 0:
		go_to_idle_state()
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
	
		
	
func jump_state(delta):
	move(delta)
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
	if velocity.y > 0:
		go_to_fall_state()
		return	
	

func fall_state(delta):
	move(delta)
	
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return
	
	if is_on_floor():
		jump_count = 0
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()
		return
	pass

func can_jump() -> bool:
	return jump_count < max_jump_count
	
