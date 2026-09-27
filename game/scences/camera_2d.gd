extends Camera2D

@export var player: CharacterBody2D

# Tracks the furthest right position the camera has allowed
var max_x: float = 0.0

func _ready() -> void:
	if player:
		# Start the tracker at the player's initial spawn position
		max_x = player.position.x
		position = player.position

func _process(_delta: float) -> void:
	if player:
		# Only update max_x if the player moves further right
		if player.position.x > max_x:
			max_x = player.position.x
		
		# Set camera position using the locked X axis, but follow Y normally
		position = Vector2(max_x, player.position.y)
