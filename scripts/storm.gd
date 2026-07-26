extends AudioStreamPlayer

@onready var audio_player = self
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if audio_player.is_playing() == false:
		audio_player.play()
