extends Area2D


func _on_body_entered(_body: Node2D) -> void:
	print("Plus one coin!")
	queue_free()
