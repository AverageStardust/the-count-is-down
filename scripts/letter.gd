extends Panel
class_name Letter

@onready var body: RichTextLabel = $Body

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func deliver(message: String):
	if !is_node_ready():
		await ready
	
	body.text = message
	visible = true
