extends RefCounted
class_name DocumentField

enum FieldType {
	NEWSPAPER_TITLE,
	NEWSPAPER_PUBLISHER,
	NEWSPAPER_BODY,
	PACKAGE_CONTENTS,
	TRANSYLVANIA_ADDRESS,
	ENGLAND_ADDRESS,
	TELEGRAM_TO,
	TELEGRAM_DATE,
	TELEGRAM_BODY
}

var text: String
var type: FieldType

func _init(_content: String, _type: FieldType) -> void:
	text = _content
	type = _type
