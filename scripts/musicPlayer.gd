extends AudioStreamPlayer

@onready var audio_player = self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_player.play()
	pass # Replace with function body.

func _fade(delta, goal):
	var curVol = audio_player.volume_db
	if curVol > goal:
		while curVol > goal:
			audio_player.volume_db - (0.1 * delta)
	elif curVol < goal: 
		while curVol < goal:
			audio_player.volume_db + (0.1 * delta)
	else:
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if audio_player.is_playing() == false:
		audio_player.play()
