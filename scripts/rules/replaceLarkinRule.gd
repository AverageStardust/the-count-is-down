extends GraderRule
class_name ReplaceLarkinRule

func get_advice() -> String:
	return "We wanted that info to seem unreliable. Address it from \"P Walter\" instead"

func find_edits(field: DocumentField) -> Array[RuleEdit]:
	var edits: Array[RuleEdit] = []
	var index: int = 0
	
	while true:
		index = field.text.findn("M Larkin", index)
		
		if index == -1:
			break
		else:
			edits.append(RuleEdit.new(index, index + 8, "Hank"))
			index += 8
	
	return edits
