@abstract
extends Node
class_name GraderRule

@abstract
func get_advice() -> String

@abstract
func find_edits(field: DocumentField) -> Array[RuleEdit]

func apply_edits(field: DocumentField) -> DocumentField:
	var edits = find_edits(field)
	var text: String = field.text
	var offset: int = 0
	
	for edit in edits:
		text = (
			text.substr(0, edit.start + offset) +
			edit.replacement_text +
			text.substr(edit.end + offset, text.length() - edit.end - offset))
		
		offset += edit.replacement_text.length() - (edit.end - edit.start)
	
	return DocumentField.new(text, field.type)

func erase_edits(field: DocumentField) -> DocumentField:
	var edits = find_edits(field)
	var text: String = field.text
	var offset: int = 0
	
	for edit in edits:
		text = (
			text.substr(0, edit.start + offset) +
			text.substr(edit.end + offset, text.length() - edit.end - offset))
		
		offset -= edit.end - edit.start
	
	return DocumentField.new(text, field.type)

func relative_edit_score(field: DocumentField, rel_field: DocumentField, rel_pos: Array[int]) -> float:
	var edits = find_edits(field)
	var dist: int = 0
	var length: int = 0
	
	for edit in edits:
		var rel_replacement_text = rel_field.text.substr(
			rel_pos[edit.start], 
			rel_pos[edit.end] - rel_pos[edit.start])
		
		dist += Grader.lev_dist(edit.replacement_text, rel_replacement_text)
		length += edit.replacement_text.length()
	
	if length == 0:
		return 0
	
	return float(dist) / float(length)


class RuleEdit:
	var start: int
	var end: int
	var replacement_text: String
	
	func _init(_start: int, _end: int, _replacement_text: String) -> void:
		start = _start
		end = _end
		replacement_text = _replacement_text
