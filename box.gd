extends Area2D

const TEXTURES = {
	box0 = [
		"spritesheet_backtiles.BackTile_01",
		"spritesheet_backtiles.BackTile_02",
		"spritesheet_backtiles.BackTile_03",
		"spritesheet_backtiles.BackTile_04"
	],
	box1 = [
		"spritesheet_backtiles.BackTile_07",
		"spritesheet_backtiles.BackTile_08",
		"spritesheet_backtiles.BackTile_09",
		"spritesheet_backtiles.BackTile_10"
	],
	box2 = [
		"spritesheet_backtiles.BackTile_11",
		"spritesheet_backtiles.BackTile_12",
		"spritesheet_backtiles.BackTile_13",
		"spritesheet_backtiles.BackTile_14"
	],
	box3 = [
		"spritesheet_backtiles.BackTile_15",
		"spritesheet_backtiles.BackTile_16",
		"spritesheet_backtiles.BackTile_17",
		"spritesheet_backtiles.BackTile_18"
	]
}

var _type

# Matrix positions in the collection
signal bomb

func _play():
	get_node("sprite/animation").play("default")

func _input_event( viewport, event, shape_idx ):
	if (event.type == InputEvent.MOUSE_BUTTON):
		if (event.is_pressed()):
			emit_signal("bomb")

func _set_texture_by(name):
	var frames = SpriteFrames.new()
	
	for r in TEXTURES[name]:
		var texture = ResourceLoader.load("res://assets/sprites/generated/" + r + ".atex")
		frames.add_frame("default", texture)

	get_node("sprite").set_sprite_frames(frames)