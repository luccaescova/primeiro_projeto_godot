extends Control


@onready var corações_count: Label = $"Container/corações_conter/coracoes_count" as Label


func _ready() -> void:
	
	corações_count.text = str("%04d" % Globals.coins) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	corações_count.text = str("%04d" % Globals.coins)
	pass
