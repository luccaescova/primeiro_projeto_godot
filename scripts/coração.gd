extends Area2D

var cora := 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	$AnimatedSprite2D.play("collect")
	await $CollisionShape2D.call_deferred("queue_free")
	Globals.coins += cora
	print(Globals.coins)
	return
	
	


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
