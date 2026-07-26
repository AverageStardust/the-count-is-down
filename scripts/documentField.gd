extends RefCounted
class_name DocumentField

enum FieldType {
	NEWSPAPER_TITLE = 0,
	NEWSPAPER_PUBLISHER = 1,
	NEWSPAPER_BODY = 2,
	NEWSPAPER_TITLE_AND_BODY = 9,
	PACKAGE_CONTENTS = 3,
	TRANSYLVANIA_ADDRESS = 4,
	ENGLAND_ADDRESS = 5,
	TELEGRAM_TO = 6,
	TELEGRAM_DATE = 7,
	TELEGRAM_BODY = 8
}

var text: String
var type: FieldType

func _init(_content: String, _type: FieldType) -> void:
	text = _content
	type = _type
