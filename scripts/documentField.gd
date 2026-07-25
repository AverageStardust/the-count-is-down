extends RefCounted
class_name DocumentField

enum FieldType {
	NEWSPAPER_TITLE,
	NEWSPAPER_PUBLISHER,
	NEWSPAPER_BODY,
}

var content: String
var type: FieldType

func _init(_content: String, _type: FieldType) -> void:
	content = _content
	type = _type
