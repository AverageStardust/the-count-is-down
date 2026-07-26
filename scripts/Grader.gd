extends Node

var rules: Array[GraderRule] = [ReplaceDraculaRule.new()]

var lev_mat = []
var m
var n

func get_advice(original: Array[DocumentField], forgery: Array[DocumentField]) -> String:
	var worst_accuracy_score: float = 0
	var worst_length_score: float = 0
	var worst_rule_score: float = 0
	var worst_rule = rules[0]
		
	for i in original.size():
		var original_length: int = original[i].text.length()
		var goal_dist: int = goal_dist(original[i], forgery[i])
		var accuracy_score =  float(goal_dist) / float(original_length)
		worst_accuracy_score = max(worst_accuracy_score, accuracy_score)
			
		var forgery_length: int = forgery[i].text.length()
		var length_score = abs(original_length - forgery_length) / original_length
		worst_length_score = max(worst_length_score, length_score)
			
		lev_dist(forgery[i].text, original[i].text)
		var relative_positions: Array[int] = rel_pos()
		
		for rule in rules:
			var rule_score = rule.relative_edit_score(original[i], forgery[i], relative_positions)
			
			if rule_score > worst_rule_score:
				worst_rule_score = rule_score
				worst_rule = rule
	
	if worst_accuracy_score > 0.35 or worst_rule_score > 0.35:
		if worst_length_score > 0.2:
			return "You missed copying something, the last forgery looks too empty."
		elif worst_rule_score > worst_accuracy_score + 0.1:
			return worst_rule.get_advice()
		else:
			return "You made unnecessary changes, the last forgery looks fake."
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
## e.g. arr[original index] = forgery index
func rel_pos() -> Array[int]:
	var j = m-1
	var prev = lev_mat[n*m-1]+1
	var similar: Array[int]
	similar.resize(n)
	
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
	
	similar[n - 1] = similar[n - 2] + 1
	
	return similar
