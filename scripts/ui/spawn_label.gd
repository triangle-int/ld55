extends Label

var tween: Tween

func _ready():
	hide_text()
	PlayerSummon.state_updated.connect(state_updated)

func state_updated(state: PlayerSummonClass.State):
	if state == PlayerSummonClass.State.ARMY:
		hide_text()
	elif state == PlayerSummonClass.State.BUFFS:
		show_text()
	elif state == PlayerSummonClass.State.AWAIT_POSITION:
		show_text()

func show_text():
	visible = true
	if tween != null:
		tween.kill()
	
	modulate.a = 0.3
	tween = create_tween().set_loops()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	tween.chain().tween_property(self, "modulate:a", 0.3, 0.5)

func hide_text():
	visible = false
	if tween != null:
		tween.kill()
