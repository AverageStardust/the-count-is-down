extends Document
class_name NewspaperClipping

@onready var title: LineEdit = $Title
@onready var publisher: LineEdit = $Publisher
@onready var body: TextEdit = $Body

@export var editable = true: set = set_editable

func _ready() -> void:
	title.text = Writer.random_content(DocumentField.FieldType.NEWSPAPER_TITLE)
	publisher.text = Writer.random_content(DocumentField.FieldType.NEWSPAPER_PUBLISHER)
	body.text = Writer.random_content(DocumentField.FieldType.NEWSPAPER_BODY)
	
	set_editable(editable)

func get_fields() -> Array[DocumentField]:
	return [
		DocumentField.new(title.text, DocumentField.FieldType.NEWSPAPER_TITLE),
		DocumentField.new(publisher.text, DocumentField.FieldType.NEWSPAPER_PUBLISHER),
		DocumentField.new(body.text, DocumentField.FieldType.NEWSPAPER_BODY)]

func set_editable(editable: bool) -> void:
	if not is_node_ready():
		await ready
	
	if editable:
		modulate = Color(0.96, 0.96, 0.87)
	else:
		modulate = Color.WHITE
	
	title.editable = editable
	title.selecting_enabled = editable	
	title.focus_mode = FOCUS_ALL if editable else FOCUS_NONE
	
	publisher.editable = editable
	publisher.selecting_enabled = editable
	publisher.focus_mode = FOCUS_ALL if editable else FOCUS_NONE
	
	body.editable = editable
	body.selecting_enabled = editable
	body.focus_mode = FOCUS_ALL if editable else FOCUS_NONE
	body.mouse_behavior_recursive = MOUSE_BEHAVIOR_INHERITED if editable else MOUSE_BEHAVIOR_DISABLED
