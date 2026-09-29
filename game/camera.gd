extends Camera2D

# Get a reference to the parent node (the player)
@onready var player = get_parent()

# How fast the camera catches up to the player (Lower = smoother, Higher = snappier)
@export var smooth_speed: float = 5.0

func _ready() -> void:
	# TopLevel decouples the camera's position from the player's movement
	# This lets us smoothly lerp it independently instead of it being hard-locked
	top_level = true
	
	if player:
		# Start exactly on the player's position
		global_position = player.global_position

func _process(delta: float) -> void:
	if not player:
		return
		
	# 1. Target destination is always the player's exact global position
	var target_position = player.global_position
	
	# 2. Smoothly slide the camera toward the player on both axes
	var lerp_weight = 1.0 - exp(-smooth_speed * delta)
	global_position = global_position.lerp(target_position, lerp_weight)
