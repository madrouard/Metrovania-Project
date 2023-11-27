extends Node2D


@onready var blaster_sprite = $BlasterSprite
@onready var muzzle = $BlasterSprite/Muzzle


func _process(delta):
	blaster_sprite.rotation = get_local_mouse_position().angle()
