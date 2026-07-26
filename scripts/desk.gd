extends Control

var NEWSPAPER_CLIPPING = preload("res://documents/newspaperClipping.tscn")
var PACKAGE_LABEL = preload("res://documents/packageLabel.tscn")
var TELEGRAM = preload("res://documents/telegram.tscn")

@onready var originalSlot: Control = $Desk/DeskTop/OriginalSlot
@onready var forgerySlot: Control = $Desk/DeskTop/ForgerySlot

enum State {
	READING_LETTERS,
	FORGING_DOCUMENTS,
	RECEIVING_CRITICISM,
	REACHED_ENDING
}

var state: State = State.READING_LETTERS

func _ready() -> void:
	await get_tree().process_frame
	transition_to_forging()

func transition_to_forging():
	var document_type: PackedScene = next_document_type()
	
	var originalDocument: Document = document_type.instantiate()
	originalDocument.editable = false
	originalDocument.draggable = false
	originalSlot.add_child(originalDocument)
	originalDocument.write_content()
	
	var forgeryDocument: Document = document_type.instantiate()
	forgerySlot.add_child(forgeryDocument)
	
	state = State.FORGING_DOCUMENTS
	
	await forgeryDocument.discarded
	
	var advice = Grader.get_advice(
		originalDocument.get_fields(), 
		forgeryDocument.get_fields())
	originalDocument.discard()
	
	await originalDocument.discarded
	
	if !advice.is_empty():
		transition_to_criticism(advice)
	else:
		transition_to_forging()

func transition_to_criticism(advice: String):
	var criticismTelegram: Telegram = TELEGRAM.instantiate()
	criticismTelegram.editable = false
	forgerySlot.add_child(criticismTelegram)
	criticismTelegram.write_message("Marishka", advice + " -Aleera")
	
	state = State.RECEIVING_CRITICISM
	
	await criticismTelegram.discarded
	
	transition_to_forging()

func next_document_type() -> PackedScene:
	match randi_range(0, 2):
		0:
			return NEWSPAPER_CLIPPING
		1:
			return PACKAGE_LABEL
		2, _:
			return TELEGRAM
