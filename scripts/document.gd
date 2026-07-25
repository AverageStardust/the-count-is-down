extends Panel
class_name Document

func get_fields() -> Array[DocumentField]:
	return [] # abstract

func set_editable(set_editable: bool) -> void:
	pass # abstract
