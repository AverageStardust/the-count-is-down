extends Control


#const START_LETTER = "The start"
#const SUCCESS_LETTER = "The end :)"
const FAIL_LETTER = "    My dearest Marishka, \nDracula has been found and killed. I far we are next. Run and hide, or they'll find you."

const START_LETTER = "    Dear Marishka,\nOur beloved Count has begun expanding towards England. He left a paper trail that must be covered. Aleera and I will sent them and you must correct them. Dracula is Hank, Grave Dirt is Specialty Dirt, and M. Larkin is P. Walter.\nCold Regards, Verona"
const GOOD_END_LETTER = "     Marvelous Marishka, Your work never ceases to impress. The Count has secured his new territory in England. Return to us safe and sound, my love.\nOurs truly, Verona"

const LETTER_SCENE_POSITION = 340
const SCENE_SWITCH_RANGE = 12

var NEWSPAPER_CLIPPING = preload("res://documents/newspaperClipping.tscn")
var PACKAGE_LABEL = preload("res://documents/packageLabel.tscn")
var TELEGRAM = preload("res://documents/telegram.tscn")

@onready var originalSlot: Control = $Desk/DeskTop/OriginalSlot
@onready var forgerySlot: Control = $Desk/DeskTop/ForgerySlot
@onready var watch: Watch = $Desk/DeskTop/LeftSpacer/Watch
@onready var undeilvered_letters: Array[Letter] = [
	$Desk/DeskDrawer/Letters/Letter,
	$Desk/DeskDrawer/Letters/Letter2,
	$Desk/DeskDrawer/Letters/Letter3,
	$Desk/DeskDrawer/Letters/Letter4
]

enum State {
	READING_LETTERS,
	FORGING_DOCUMENTS,
	RECEIVING_CRITICISM,
	REACHED_ENDING
}

var state: State = State.READING_LETTERS
var open_documents = []
var on_letters_screen: bool = true
var switch_screen_cooldown: float = 2.0
var on_switch_area = false

func _ready() -> void:
	await get_tree().process_frame
	
	if on_letters_screen:
		position.y = -LETTER_SCENE_POSITION
	else:
		position.y = 0
	
	deliver_letter(START_LETTER)

func _process(delta: float) -> void:
	var target_y: float = 0
	if on_letters_screen:
		target_y = -LETTER_SCENE_POSITION
	
	position.y = lerp(position.y, target_y, delta * 3.0)
	position.y = move_toward(position.y, target_y, delta * 45.0)
	
	if !on_switch_area or switch_screen_cooldown > 0.8:
		switch_screen_cooldown = max(0, switch_screen_cooldown - delta)
	
	match state:
		State.READING_LETTERS:
			if on_letters_screen == false:
				watch.set_time(120)
				watch.time_finished.connect(transition_to_end)
				transition_to_forging()
		State.FORGING_DOCUMENTS, State.RECEIVING_CRITICISM, State.REACHED_ENDING:
			pass # nothing

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var window_height = get_viewport().get_visible_rect().size.y
		if event.position.y < SCENE_SWITCH_RANGE:
			if switch_screen_cooldown <= 0:
				on_letters_screen = false
			
			on_switch_area = true
		elif event.position.y > window_height - SCENE_SWITCH_RANGE:
			if switch_screen_cooldown <= 0:
				on_letters_screen = true
			
			on_switch_area = true
		else:
			on_switch_area = false

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
	open_documents = [originalDocument, forgeryDocument]
	
	await forgeryDocument.discarded
	open_documents = [forgeryDocument]
	
	var advice = Grader.get_advice(
		originalDocument.get_fields(), 
		forgeryDocument.get_fields())
	originalDocument.discard()
	
	await originalDocument.discarded
	open_documents = []
	
	if state == State.REACHED_ENDING:
		return
	
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
	open_documents = [criticismTelegram]
	
	await criticismTelegram.discarded
	open_documents = []
	
	if state == State.REACHED_ENDING:
		return
	
	transition_to_forging()

func transition_to_end():
	if Grader.get_fail_ratio() < 0.5: deliver_letter(GOOD_END_LETTER)
	else : deliver_letter(FAIL_LETTER)
	
	state = State.REACHED_ENDING
	
	for document in open_documents:
		document.discard()
	
	open_documents = []
	
	on_letters_screen = true
	switch_screen_cooldown = INF

func deliver_letter(message: String):
	var letter = undeilvered_letters.pop_front()
	letter.deliver(message)

func next_document_type() -> PackedScene:
	match randi_range(0, 2):
		0:
			return NEWSPAPER_CLIPPING
		1:
			return PACKAGE_LABEL
		2, _:
			return TELEGRAM
