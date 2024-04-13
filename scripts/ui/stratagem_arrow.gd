extends TextureRect

@export var up_image: Texture2D
@export var down_image: Texture2D
@export var right_image: Texture2D
@export var left_image: Texture2D

func set_path_part(path_part: Stratagem.PathPart):
	if path_part == Stratagem.PathPart.UP:
		texture = up_image
	elif path_part == Stratagem.PathPart.DOWN:
		texture = down_image
	elif path_part == Stratagem.PathPart.RIGHT:
		texture = right_image
	elif path_part == Stratagem.PathPart.LEFT:
		texture = left_image
