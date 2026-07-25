extends Control

var NEWSPAPER_CLIPPING = preload("res://documents/newspaperClipping.tscn")

@onready var originalSlot: Control = $Desk/DeskTop/OriginalSlot
@onready var forgerySlot: Control = $Desk/DeskTop/ForgerySlot

var originalDocument: Document
var forgeryDocument: Document

enum State {
	READING_LETTERS,
	FORGING_DOCUMENTS,
	RECEIVING_CRITICISM,
	REACHED_ENDING
}

var state: State = State.READING_LETTERS

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	match(state):
		State.READING_LETTERS:
			transition_to_forging()
		
		State.FORGING_DOCUMENTS:
			pass 
		
		State.RECEIVING_CRITICISM:
			pass 
		
		State.REACHED_ENDING:
			pass 

func transition_to_forging():
	originalDocument = NEWSPAPER_CLIPPING.instantiate()
	forgeryDocument = NEWSPAPER_CLIPPING.instantiate()
	
	originalDocument.editable = false
	forgeryDocument.editable = true
	
	originalSlot.add_child(originalDocument)
	forgerySlot.add_child(forgeryDocument)
	
	originalDocument.write_content()
	
	state = State.FORGING_DOCUMENTS
	
	await forgeryDocument.discarded
	
	originalDocument.discard()
	await originalDocument.discarded
	
	transition_to_forging()
