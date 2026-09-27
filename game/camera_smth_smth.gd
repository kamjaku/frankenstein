extends Camera2D


@export var lead_distance: float = 80.0  # How far ahead the camera looks
@export var shift_speed: float = 20.0     # How fast the camera shifts sides

func _process(delta: float) -> void:
	# 1. Access the parent player node
	var player = get_parent() as CharacterBody2D
	if not player:
		return

	# 2. Check if the player is actively moving
	if player.velocity.length() > 10.0:
		# Calculate a look-ahead target vector based on player velocity direction
		var target_offset = player.velocity.normalized() * lead_distance
		
		# Smoothly slide the camera's visual offset towards that target point
		offset = offset.lerp(target_offset, shift_speed * delta)
	else:
		# If standing still, slowly center the camera back onto the player
		offset = offset.lerp(Vector2.ZERO, shift_speed * delta)
