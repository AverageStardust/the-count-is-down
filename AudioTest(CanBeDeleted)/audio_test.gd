extends Node2D

@onready var audio_player = $Button/AudioStreamPlayer
#@onready var audio_player = $Button2/AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.pressed.connect(_on_button_pressed) 
	$Button2.pressed.connect(_on_button_pressed2)
	
func _on_button_pressed():
	audio_player.play()
func _on_button_pressed2():
	audio_player.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
