extends Control

@export var label: Label

func _ready():
	_update_tip()

func _update_tip():
	var tip = TutorialTips.curr_tip()

	if tip.is_empty():
		visible = false
		return

	label.text = tip

func _on_button_pressed():
	TutorialTips.next_tip()
	_update_tip()
