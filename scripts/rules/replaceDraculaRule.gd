extends GraderRule
class_name ReplaceDraculaRule

func get_advice() -> String:
	return "It seems like something about Dracula got out, make sure to replace his name with Hank"

func find_edits(field: DocumentField) -> Array[RuleEdit]:
	var edits: Array[RuleEdit] = []
	var index: int = 0
	
	while true:
		index = field.text.findn("dracula", index)
		
		if index == -1:
			break
		else:
			edits.append(RuleEdit.new(index, index + 7, "Hank"))
			index += 7
	
	return edits
