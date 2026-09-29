
extends StaticBody2D

@onready var damage_reciever = $damage_reciever


func _ready() -> void:
	damage_reciever.damage_recieved.connect(on_recieve_damage.bind())
	
func on_recieve_damage(damage : int ) -> void: 
	print(damage)
	queue_free()
