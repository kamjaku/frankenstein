extends CharacterBody2D

@export var health : int
@export var damage : int
@export var speed : float = 100.0 

# Changed node type to AnimatedSprite2D and fixed the typo path
@onready var animated_sprite: AnimatedSprite2D = $charactersprite 
@onready var damage_emmitter = $damage_emitter # the fun part hit and hurt boxes

enum State { IDLE, WALK, ATTACK }
var current_State: State = State.WALK 


# FIXED: Combined into one clean _ready function and corrected the call name
func _ready() -> void:
	# Make sure hitbox is off by default
	hitbox_shape.disabled = true 
	
	# Listen to the sprite every time the frame changes
	sprite.frame_changed.connect(_on_frame_changed)

func _on_frame_changed() -> void:
	# Only execute this logic if the current playing animation is "punch"
	if sprite.animation == "attack":
		
		# Replace '2' with the frame number where the fist is fully extended
		if sprite.frame == 2: 
			hitbox_shape.disabled = false # Turn Hitbox ON
			
		# Replace '4' with the frame number where the fist pulls back
		elif sprite.frame == 4:
			hitbox_shape.disabled = true # Turn Hitbox OFF


# Call this function when the player presses the attack button
func attack() -> void:
	sprite.play("attack")


func _physics_process(_delta: float) -> void:
	# 1. Reset state if the punch animation finished playing
	if current_State == State.ATTACK and not animated_sprite.is_playing():
		current_State = State.IDLE

	# 2. Process attack input before calculations
	if can_attack() and Input.is_action_just_pressed("attack"):
		current_State = State.ATTACK

	# 3. Calculate movement direction
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed

	# 4. Process state flow, animations, and graphics
	_handle_movement()
	handle_animations() 
	flip_sprites()
	
	# 5. Move the character
	move_and_slide()

func handle_animations() -> void:
	# Matches your exact animation names from the bottom editor panel
	if current_State == State.IDLE:
		animated_sprite.play("idle")
	elif current_State == State.WALK:
		animated_sprite.play("walk")
	elif current_State == State.ATTACK:
		animated_sprite.play("attack")

func _handle_movement() -> void:
	if current_State == State.ATTACK:
		velocity = Vector2.ZERO 
		return 
	
	if can_move(): 
		if velocity.is_zero_approx() or velocity.length() < 0.1:
			current_State = State.IDLE
		else:
			current_State = State.WALK
	else:
		velocity = Vector2.ZERO 
		current_State = State.IDLE 

func flip_sprites() -> void:  
	if velocity.x > 0: 
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true

func can_attack() -> bool:
	return current_State == State.IDLE or current_State == State.WALK

func can_move() -> bool:
	return current_State == State.IDLE or current_State == State.WALK

# THIS FIXES THE ATTACK STATE BUG:
func _on_animation_finished() -> void:
	if animated_sprite.animation == "attack":
		current_State = State.IDLE

# FIXED: Standardised naming with the signal connection above

func on_damage_(_damage_reciever: Area2D) -> void:
	_damage_reciever.get_parent().get_damage
	print("damage")

# ok hit and hurt box time
@onready var sprite: AnimatedSprite2D = $charactersprite
@onready var hitbox_shape: CollisionShape2D = $damage_emitter/CollisionShape2D
