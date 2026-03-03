extends Control

@onready var _overlay: ColorRect = $Overlay
@onready var _pivot: Control = $Pivot
@onready var _mover: Control = $Pivot/Mover
@onready var _bg_strip: ColorRect = $Pivot/Mover/BackgroundStrip
@onready var _flash: ColorRect = $Pivot/Mover/BackgroundStrip/FlashRect
@onready var _portrait: TextureRect = $Pivot/Mover/PortraitRect
@onready var _name_label: Label = $Pivot/Mover/NameLabel

var _tween: Tween

## Fills the template with the provided CutinData.
func setup_cutin(data: CutinData) -> void:
	if not is_inside_tree():
		await ready
		
	if data.character_portrait:
		_portrait.texture = data.character_portrait
		
	_bg_strip.color = data.background_color
	_name_label.modulate = data.fx_color
	_name_label.text = data.title_text

func _ready() -> void:
	# Hide off-screen initially
	_mover.position.x = 1500.0
	_overlay.modulate.a = 0.0
	_pivot.scale.y = 0.0
	
	_play_animations()

func _play_animations() -> void:
	_tween = create_tween()
	_tween.set_parallel(false) # Sequence
	
	# 1. Background darkens
	var p1 = create_tween().set_parallel(true)
	p1.tween_property(_overlay, "modulate:a", 1.0, 0.1)
	
	# 2. Strip opens vertically
	var p2 = create_tween().set_parallel(true)
	p2.tween_property(_pivot, "scale:y", 1.0, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	p2.play()
	await p2.finished
	
	# 3. Mover slashes in from the right
	var p3 = create_tween().set_parallel(true)
	p3.tween_property(_mover, "position:x", -50.0, 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	p3.play()
	
	# Impact flash!
	if has_node("/root/SoleilMotion"):
		var motion = get_node("/root/SoleilMotion")
		if get_viewport().get_camera_2d():
			motion.shake(get_viewport().get_camera_2d(), 20.0, 0.3)
	
	_flash.modulate.a = 1.0
	var p4 = create_tween()
	p4.tween_property(_flash, "modulate:a", 0.0, 0.2)
	
	# 4. Slow drift (tension)
	var p5 = create_tween()
	p5.tween_property(_mover, "position:x", -150.0, 0.6)
	p5.play()
	await p5.finished
	
	# 5. Exit fast to the left
	var p6 = create_tween().set_parallel(true)
	p6.tween_property(_mover, "position:x", -2000.0, 0.15).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	p6.tween_property(_pivot, "scale:y", 0.0, 0.15).set_delay(0.05)
	p6.tween_property(_overlay, "modulate:a", 0.0, 0.2)
	p6.play()
	await p6.finished
	
	queue_free()
