extends Document
class_name NewspaperClipping

@onready var title: LineEdit = $Title
@onready var publisher: LineEdit = $Publisher
@onready var body: TextEdit = $Body

func _init() -> void:
	title.text = "Random Title"
	publisher.text = "Random Publisher"
	body.text = "Random Body"

func get_fields() -> Array[DocumentField]:
	return [
		DocumentField.new(title.text, DocumentField.FieldType.NEWSPAPER_TITLE),
		DocumentField.new(publisher.text, DocumentField.FieldType.NEWSPAPER_PUBLISHER),
		DocumentField.new(body.text, DocumentField.FieldType.NEWSPAPER_BODY)]
