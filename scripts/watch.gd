extends Sprite2D
class_name Watch

signal time_finished

@onready var hand = $WatchHand

var _is_set = false
var _time_left = 0
var _total_time = 1

func _process(delta: float) -> void:
	_time_left = max(0, _time_left - delta)
	
	if _time_left == 0 && _is_set:
		time_finished.emit()
		_is_set = false
	
	var target_rotation = get_target_rotation()
	hand.rotation = lerp(hand.rotation, target_rotation, delta * 2.4)
	hand.rotation = move_toward(hand.rotation, target_rotation, delta * 0.5)

func set_time(seconds: float):
	_time_left = seconds
	_total_time = seconds
	_is_set = true

func get_target_rotation() -> float:
	return _time_left / _total_time * TAU * 0.8
