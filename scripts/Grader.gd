extends Node

var rules: Array[GraderRule] = [ReplaceDraculaRule.new()]

var lev_mat = []
var m
var n

func get_advice(original: Array[DocumentField], forgery: Array[DocumentField]) -> String:
	var original_length: int = 0
	var forgery_length: int = 0
	var goal_score: float = 0
	var worst_rule_score: float = 0
	var worst_rule = rules[0]
		
	for i in original.size():
		original_length += original[i].text.length()
		forgery_length += forgery[i].text.length()
		goal_score += goal_dist(original[i], forgery[i])
		
		lev_dist(forgery[i].text, original[i].text)
		var relative_positions = rel_pos()
		
		for rule in rules:
			var rule_score = rule.relative_edit_score(original[i], forgery[i], relative_positions)
			
			if rule_score > worst_rule_score:
				worst_rule_score = rule_score
				worst_rule = rule
	
	goal_score /= float(original_length)
	
	if worst_rule_score > 0.4:
		if goal_score + 0.1 > worst_rule_score:
			if forgery_length < original_length * 0.6:
				return "You must have missed copying something, this is too empty."
			else:
				return "You've made too many changes unnecessary, it just looks fake."
		else:
			return worst_rule.get_advice()
	else:
		return ""
		

func goal_dist(original_field: DocumentField,forgery_field: DocumentField) -> int:
	for rule in rules:
		original_field = rule.apply_edits(original_field)
	
	return lev_dist(forgery_field.text, original_field.text)

## Creates levenshtein matrix and returns levenshtein distance
func lev_dist(input: String, target: String) -> int: 
	m = input.length() + 1 # lev dis algorithm adds empty space in beginning
	n = target.length() + 1
	lev_mat.resize(n*m)
	
	for i in range(0, n):
		lev_mat[i * m] = i;
	
	var line = []
	
	for j in range(m):
		lev_mat[j] = j
		line.append(j)
	
	for i in range(n - 1):
		line = []
		line.append(lev_mat[(i + 1)*m])
		
		for j in range(m-1):
			var sub_cost = 1
			if target[i] == input[j]: sub_cost = 0
			
			lev_mat[(i+1)*m + j+1] = min(
				lev_mat[i*m + j + 1] + 1,     # deletion
				lev_mat[(i + 1) * m + j] + 1, # insertion
				lev_mat[i*m + j] + sub_cost   # substitution
			)
			line.append(lev_mat[(i+1)*m + j+1])
	
	return lev_mat[n*m-1]
	
## uses existing levenshtein matrix to return an array of locations in one string relative to another.
## e.g. arr[target index] = input index
func rel_pos() -> Array[int]:
	var j = m-1
	var prev = lev_mat[n*m-1]+1
	var similar: Array[int]
	similar.resize(n-1)
	
	if j == 0:
		similar.fill(0)
		return similar
	
	for i in range(n - 1, 0, -1):
		if (lev_mat[i*m + j] < prev or lev_mat[i*m + j] == lev_mat[i*m + j - 1]): 
			similar[i-1] = j-1
		prev = lev_mat[i*m + j]
		
		while lev_mat[i*m + j - 1] < prev:
			j -= 1
			similar[i - 1] = j - 1
			prev = lev_mat[i*m + j]
	
	return similar
