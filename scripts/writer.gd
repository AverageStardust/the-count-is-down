extends Node

var story: WriterStory = preload("res://resources/story.tres")

var usaged_tags: Dictionary[DocumentField.FieldType, PackedByteArray]

func _init():
	for type in DocumentField.FieldType.values():
		usaged_tags[type] = PackedByteArray()
		
		if story.text.has(type):
			usaged_tags[type].resize(story.text[type].size())

func random_content(type: DocumentField.FieldType) -> String:
	var type_usage_tags = usaged_tags[type]
	
	# find how many texts of this type are unused
	var ununused_count: int = 0
	for used_tag in type_usage_tags:
		if used_tag == 0:
			ununused_count += 1
	
	# pick the Nth unused text of this type
	var roll: int = randi_range(1, ununused_count)
	var picked_text: String
	
	# find the Nth unused text of this type
	for i in type_usage_tags.size():
		if type_usage_tags[i] == 0:
			roll -= 1
			if roll == 0:
				picked_text = story.text[type][i]
				type_usage_tags[i] = 1
				break
	
	# if all texts of this type have now been used once, set them all as unused
	if ununused_count - 1 == 0:
		for i in type_usage_tags.size():
			type_usage_tags[i] = 0
	
	return picked_text
