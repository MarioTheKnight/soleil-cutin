extends Control

@onready var _overlay: ColorRect = $Overlay
@onready var _poster: ColorRect = $PosterPanel
@onready var _portrait: TextureRect = $PosterPanel/PortraitRect
@onready var _name_label: Label = $PosterPanel/NameLabel
@onready var _flash: ColorRect = $PosterPanel/FlashRect

var _tween: Tween

func setup_cutin(data: CutinData) -> void:
	if not is_inside_tree():
		await ready
		
	if data.character_portrait:
		_portrait.texture = data.character_portrait
		
	_poster.color = data.background_color
	_name_label.modulate = data.fx_color
	_name_label.text = data.title_text

func _ready() -> void:
	# Initial positioning (hidden off-screen left, but tilted)
	_poster.position.x = -600.0
	_poster.rotation_degrees = -10.0
	_overlay.modulate.a = 0.0
	
	_play_animations()

func _play_animations() -> void:
	_tween = create_tween()
	
	# 1. Overlay fades in
	_tween.tween_property(_overlay, "modulate:a", 1.0, 0.2)
	
	# 2. Poster smashes in from the left and straightens out
	var p1 = create_tween().set_parallel(true)
	p1.tween_property(_poster, "position:x", 50.0, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	p1.tween_property(_poster, "rotation_degrees", 0.0, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	
	# Small delay before flash
	await get_tree().create_timer(0.2).timeout
	
	_flash.modulate.a = 1.0
	var f_tween = create_tween()
	f_tween.tween_property(_flash, "modulate:a", 0.0, 0.3)
	
	if has_node("/root/SoleilMotion"):
		var motion = get_node("/root/SoleilMotion")
		if get_viewport().get_camera_2d():
			motion.shake(get_viewport().get_camera_2d(), 10.0, 0.4)
			
	# Hold for reading (tension)
	await get_tree().create_timer(1.2).timeout
	
	# 3. Exit by sliding up and fading overlay
	var out_tween = create_tween().set_parallel(true)
	out_tween.tween_property(_poster, "position:y", -1000.0, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	out_tween.tween_property(_overlay, "modulate:a", 0.0, 0.3)
	
	await out_tween.finished
	queue_free()
