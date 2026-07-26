extends Document
class_name NewspaperClipping

@onready var title: LineEdit = $Title
@onready var publisher: LineEdit = $Publisher
@onready var body: TextEdit = $Body
	
func write_content():
	var title_and_body = Writer.random_content(DocumentField.FieldType.NEWSPAPER_TITLE_AND_BODY)
	title_and_body = title_and_body.split("|")
	title.text = title_and_body[0]
	body.text = title_and_body[1]
	
	publisher.text = Writer.random_content(DocumentField.FieldType.NEWSPAPER_PUBLISHER)

func get_fields() -> Array[DocumentField]:
	return [
		DocumentField.new(title.text, DocumentField.FieldType.NEWSPAPER_TITLE),
		DocumentField.new(publisher.text, DocumentField.FieldType.NEWSPAPER_PUBLISHER),
		DocumentField.new(body.text, DocumentField.FieldType.NEWSPAPER_BODY),
	]

func set_editable(_editable: bool) -> void:
	if not is_node_ready():
		await ready
		
	editable = _editable
	
	if editable:
		modulate = Color(0.96, 0.96, 0.87)
	else:
		modulate = Color.WHITE
	
	title.editable = editable
	title.focus_mode = FOCUS_ALL if editable else FOCUS_NONE
	
	publisher.editable = editable
	publisher.focus_mode = FOCUS_ALL if editable else FOCUS_NONE
	
	body.editable = editable
	body.focus_mode = FOCUS_ALL if editable else FOCUS_NONE
	body.mouse_behavior_recursive = MOUSE_BEHAVIOR_INHERITED if editable else MOUSE_BEHAVIOR_DISABLED
