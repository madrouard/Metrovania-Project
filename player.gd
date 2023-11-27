extends CharacterBody2D


const dustEffectScene = preload("res://effects/dust_effect.tscn")

@export var acceleration = 512
@export var max_speed = 64
@export var fall_speed = 80
@export var friction = 256
@export var gravity = 200
@export var jump_force = -128

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var coyote_jump_timer = $CoyoteJumpTimer


func _physics_process(delta):
	var input_axis = Input.get_axis("Left", "Right")
	
	handle_movement(delta, input_axis)
	handle_jump(delta)
	handle_gravity(delta)
	animation_handler(input_axis)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_edge = was_on_floor and not is_on_floor()
	if just_left_edge:
		coyote_jump_timer.start()

func handle_movement(delta, input_axis):
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, input_axis * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func handle_jump(delta):
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if  Input.is_action_just_pressed("Jump"):
			velocity.y = jump_force
	if not is_on_floor(): 
		if Input.is_action_just_released("Jump") and velocity.y < jump_force / 2:
			velocity.y = jump_force / 2


func handle_gravity(delta):
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, fall_speed, gravity * delta)

func animation_handler(input_axis):
	if input_axis != 0:
		animation_player.play("walking")
		sprite_2d.scale.x = sign(input_axis)
	else:
		animation_player.play("idle")
		
	if not is_on_floor():
		animation_player.play("jump")

func create_dust_effect():
	var dust_effect = dustEffectScene.instantiate()
	var main = get_tree().current_scene
	main.add_child(dust_effect)
	dust_effect.global_position = global_position
