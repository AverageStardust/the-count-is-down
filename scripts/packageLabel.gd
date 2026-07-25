extends Document
class_name PackageLabel

@onready var contents: TextEdit = $Contents
@onready var from: TextEdit = $From
@onready var to: TextEdit = $To

@export var editable = true: set = set_editable

func _ready() -> void:
	contents.text = Writer.random_content(DocumentField.FieldType.PACKAGE_CONTENTS)
	from.text = Writer.random_content(DocumentField.FieldType.TRANSYLVANIA_ADDRESS)
	to.text = Writer.random_content(DocumentField.FieldType.ENGLAND_ADDRESS)
	
	set_editable(editable)

func get_fields() -> Array[DocumentField]:
	return [
		DocumentField.new(contents.text, DocumentField.FieldType.PACKAGE_CONTENTS),
		DocumentField.new(from.text, DocumentField.FieldType.TRANSYLVANIA_ADDRESS),
		DocumentField.new(to.text, DocumentField.FieldType.ENGLAND_ADDRESS)]

func set_editable(editable: bool) -> void:
	if not is_node_ready():
		await ready
	
	if editable:
		modulate = Color(0.96, 0.96, 0.87)
	else:
		modulate = Color.WHITE
	
	contents.editable = editable
	contents.selecting_enabled = editable	
	contents.focus_mode = FOCUS_ALL if editable else FOCUS_NONE
	contents.mouse_behavior_recursive = MOUSE_BEHAVIOR_INHERITED if editable else MOUSE_BEHAVIOR_DISABLED
	
	from.editable = editable
	from.selecting_enabled = editable
	from.focus_mode = FOCUS_ALL if editable else FOCUS_NONE
	from.mouse_behavior_recursive = MOUSE_BEHAVIOR_INHERITED if editable else MOUSE_BEHAVIOR_DISABLED
	
	to.editable = editable
	to.selecting_enabled = editable
	to.focus_mode = FOCUS_ALL if editable else FOCUS_NONE
	to.mouse_behavior_recursive = MOUSE_BEHAVIOR_INHERITED if editable else MOUSE_BEHAVIOR_DISABLED
