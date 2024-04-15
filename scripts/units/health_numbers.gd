extends Control

@export var number_scene: PackedScene

@export var damage_color: Color
@export var heal_color: Color

func _on_damage_recieved(damage):
	var instance = number_scene.instantiate()
	instance.text = "-" + str(damage)
	instance.modulate = damage_color
	instance.position = get_parent().global_position
	add_child(instance)
	var new_position = instance.position + Vector2(randf_range(-20, 20), -60)
	var tween = instance.create_tween().set_parallel(true)
	tween.tween_property(instance, "position", new_position, 0.5)
	tween.tween_property(instance, "rotation", randf_range(deg_to_rad(-25), deg_to_rad(25)), 0.5)
	tween.tween_property(instance, "modulate:a", 0, 0.5)
	tween.chain().tween_callback(func(): instance.queue_free())

func _on_heal_recieved(heal):
	var instance = number_scene.instantiate()
	instance.text = "+" + str(heal)
	instance.modulate = heal_color
	instance.position = get_parent().global_position
	add_child(instance)
	var new_position = instance.position + Vector2(randf_range(-20, 20), -60)
	var tween = instance.create_tween().set_parallel(true)
	tween.tween_property(instance, "position", new_position, 0.5)
	tween.tween_property(instance, "modulate:a", 0, 0.5)
	tween.tween_property(instance, "rotation", randf_range(deg_to_rad(-25), deg_to_rad(25)), 0.5)
	tween.chain().tween_callback(func(): instance.queue_free())
