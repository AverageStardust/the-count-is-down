extends GraderRule
class_name ReplaceGaveRule

func get_advice() -> String:
	return "Grave dirt is too suspicious, make it \"Specialty\" dirt"

func find_edits(field: DocumentField) -> Array[RuleEdit]:
	var edits: Array[RuleEdit] = []
	var index: int = 0
	
	while true:
		index = field.text.findn("Grave", index)
		
		if index == -1:
			break
		else:
			edits.append(RuleEdit.new(index, index + 5, "Specialty"))
			index += 5
	
	return edits
