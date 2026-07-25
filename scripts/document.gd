@abstract
extends Panel
class_name Document

signal discarded

@export var editable = true: set = set_editable

var velocity: Vector2
var origin_position: Vector2
var entering = true

func _ready() -> void:
	set_editable(editable)
	
	position = (get_parent().size - size) / 2
	origin_position = position
	
	position += Vector2.from_angle(randf_range(-PI * 0.25, -PI * 0.75)) * 500

func _process(delta: float) -> void:
	var dist = position.distance_to(origin_position)
	
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
			accept_event()

func discard():
	velocity = Vector2.from_angle(randf_range(-PI * 0.25, -PI * 0.75)) * 600

@abstract
func write_content() -> void
	
@abstract
func get_fields() -> Array[DocumentField]

@abstract
func set_editable(_editable: bool) -> void
