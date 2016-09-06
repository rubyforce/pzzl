extends Node2D

# TODO:
# 1. scale depends on screen resolution and width x height on mobile devices

# Pzzl box that should be droppped.
var box = preload("res://box.tscn")

const BOX_WIDTH = 40
const BOX_HEIGHT = 40
const NUMBER_OF_TYPE_BLOCKS = 4 # range(0, 4) -> 5 blocks
const WINDOW_WIDTH = 12 		# number of columns
const WINDOW_HEIGHT = 20		# number of rows

# States
const INIT = 0
const GAME = 1
const GAMEOVER = 2
const SCORES = 3
const ABOUT = 4

var state = INIT
var boxes = []


# Game Manager
# - should game behaviuor
# - should work on pregeneration world
# - should load scenes specific

func _ready():
	var size = self.get_viewport().get_rect().size

	for i in range(0, 20):
		boxes.append([])

		for j in range(0, 12):
			var box = _box_create(i, j)
			# box.set_scale(Vector2(scale, scale))
			self.add_child(box)
			
func _box_create(i, j):
	var box
	if _box_exists(i, j):
		box = boxes[i][j]
	else:
		box = _get_box(i, j)
	boxes[i].append(box)

	box.set_pos(Vector2(BOX_WIDTH * j + BOX_WIDTH / 2, BOX_HEIGHT * i + BOX_HEIGHT / 2))
	box.set_scale(Vector2(BOX_WIDTH / 256.0, BOX_HEIGHT / 256.0))
	return box

func _get_box(i, j):
	var instance = box.instance()

	var type = randi() % NUMBER_OF_TYPE_BLOCKS
	instance._type = type
	instance._set_texture_by("box" + str(type))
	instance.connect("bomb", self, "_run_bomb", [i, j, type]);

	return instance

func _box_exists(i, j):
	if boxes[i] == null:
		boxes[i] = []
	if boxes.size() <= i or boxes[i].size() <= j:
		return false
	return boxes[i][j] != null
	
func _run_bomb(i, j, type):
	for instance in _boxes_area(i, j, type):
		instance._play()

var BOMB_SIZE = 3

func _boxes_area(i, j, type):
	var collection = _boxes_area_recursive([], i, j, type)

	if collection.size() > BOMB_SIZE:
		return collection
	else:
		return []

func _boxes_area_recursive(collection, i, j, type):
	if i >= WINDOW_HEIGHT or i < 0:
		return collection
	if j >= WINDOW_WIDTH or j < 0:
		return collection

	if collection.has(boxes[i][j]):
		return collection

	if boxes[i][j]._type == type:
		collection.append(boxes[i][j])
	else:
		return collection
		
	_boxes_area_recursive(collection, i + 1, j, type)
	_boxes_area_recursive(collection, i, j + 1, type)
	_boxes_area_recursive(collection, i - 1, j, type)
	_boxes_area_recursive(collection, i, j - 1, type)
	
	return collection