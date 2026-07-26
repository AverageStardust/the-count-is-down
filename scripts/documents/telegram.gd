extends Document
class_name Telegram

@onready var to: LineEdit = $To
@onready var date: LineEdit = $Date
@onready var body: TextEdit = $Body

func _ready() -> void:
	super._ready()
	date.position.x += randi_range(-3, 3)
	date.position.y += randi_range(-2, 2)
	
func write_content():
	to.text = Writer.random_content(DocumentField.FieldType.TELEGRAM_TO)
	date.text = Writer.random_content(DocumentField.FieldType.TELEGRAM_DATE)
	body.text = Writer.random_content(DocumentField.FieldType.TELEGRAM_BODY)

func write_message(_to: String, message: String):
	to.text = _to
	date.text = Writer.random_content(DocumentField.FieldType.TELEGRAM_DATE)
	body.text = message

func get_fields() -> Array[DocumentField]:
	return [
		DocumentField.new(to.text, DocumentField.FieldType.TELEGRAM_TO),
		DocumentField.new(date.text, DocumentField.FieldType.TELEGRAM_DATE),
		DocumentField.new(body.text, DocumentField.FieldType.TELEGRAM_BODY)]

func set_editable(_editable: bool) -> void:
	if not is_node_ready():
		await ready
		
	editable = _editable
	
	if editable:
		modulate = Color(0.96, 0.96, 0.87)
	else:
		modulate = Color.WHITE
	
	to.editable = editable
	to.focus_mode = FOCUS_ALL if editable else FOCUS_NONE
	
	date.editable = editable
	date.focus_mode = FOCUS_ALL if editable else FOCUS_NONE
	
	body.editable = editable
	body.focus_mode = FOCUS_ALL if editable else FOCUS_NONE
	body.mouse_behavior_recursive = MOUSE_BEHAVIOR_INHERITED if editable else MOUSE_BEHAVIOR_DISABLED
