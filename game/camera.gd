extends Node2D

@onready var player = $player
@onready var camera = $camera

# How fast the camera catches up to the player (Lower = smoother, Higher = snappier)
@export var smooth_speed: float = 5.0

func _ready() -> void:
	if player:
		# Center the camera on the player instantly at the start of the game
		camera.position = player.position

func _process(delta: float) -> void:
	if not player:
		return
		
	# 1. Target destination is always the player's exact position
	var target_position = player.position
	
	# 2. Smoothly slide the camera toward the player on both axes
	# Using 1.0 - exp() keeps the smoothing identical across different frame rates
	var lerp_weight = 1.0 - exp(-smooth_speed * delta)
	camera.position = camera.position.lerp(target_position, lerp_weight)
