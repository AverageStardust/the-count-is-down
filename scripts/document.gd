extends Panel
class_name Document

signal discarded

@export var editable = true: set = set_editable
@onready var sfx_player = $"../../../../AudioStreamPlayerSFX"
@onready var sfx_player2 = $"../../../../AudioStreamPlayerSFX2"
@onready var writing_player = $"../../../../AudioStreamPlayerWriting"

var velocity: Vector2
var origin_position: Vector2
var entering = true
var changing = false
var editTime = 0.0

func _ready() -> void:
	set_editable(editable)
	
	position = (get_parent().size - size) / 2
	origin_position = position
	
	position += Vector2.from_angle(randf_range(-PI * 0.25, -PI * 0.75)) * 500
	
	sfx_player.stream = load("res://resources/audio/PaperDown.wav")
	sfx_player.play()
	sfx_player2.stream = load("res://resources/audio/Bats.wav")
	sfx_player2.play()
	for node in get_children():
		if node is Panel:
			print("skipping panel")
			continue
		elif node is LineEdit:
			print("LineEdit")
			node.text_changed.connect(_on_line_edit_text_changed)
		elif node is TextEdit:
			print("TextEdit")
			node.text_changed.connect(_on_text_edit_text_changed)
		

func _on_line_edit_text_changed(_new_text: String) -> void:
	#print(new_text)
	if !changing:
		writing_player.stream_paused = false
	editTime = 0.6
	changing = true

func _on_text_edit_text_changed() -> void:
	#print(new_text)
	if !changing:
		writing_player.stream_paused = false
	editTime = 0.6
	changing = true

func _process(delta: float) -> void:
	var dist = position.distance_to(origin_position)
	
	if editTime > 0.0:
		editTime = editTime - delta
		if writing_player.is_playing() == false:
			changing = true
			writing_player.play()
	elif changing:
		writing_player.stream_paused = true
		changing = false
	
	if entering:
		move_to_center(delta)
		
		if dist < 40:
			entering = false
	else:
		position += velocity * delta
		
		if dist < 80:
			move_to_center(delta)
		elif dist < 800:
			move_to_edge(delta)
		else:
			queue_free()
			discarded.emit()

func move_to_center(delta: float):
	position = position \
		.lerp(origin_position, delta * 2.5) \
		.move_toward(origin_position, delta * 25)

func move_to_edge(delta: float):
	position = position.lerp(position * 2 - origin_position, delta * 2.5)

func _gui_input(event):
	if editable && event is InputEventMouseMotion:
		if event.button_mask & 1:
			position += event.relative
			sfx_player.stream = load("res://resources/audio/LiftPaper.wav")
			sfx_player.play()
			accept_event()

func discard():
	sfx_player.stream = load("res://resources/audio/PaperMove.wav")
	sfx_player.play()
	#sfx_player2.stream = load("res://resources/audio/Bats.wav")
	#sfx_player2.play()
	velocity = Vector2.from_angle(randf_range(-PI * 0.25, -PI * 0.75)) * 600

func write_content() -> void:
	pass # abstract

func get_fields() -> Array[DocumentField]:
	return [] # abstract

func set_editable(set_editable: bool) -> void:
	pass # abstract
