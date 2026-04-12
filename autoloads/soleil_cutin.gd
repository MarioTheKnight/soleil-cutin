## Global manager for invoking dynamic cut-in animations over the gameplay.
extends CanvasLayer

var _cutin_templates = {
	"horizontal_slash": preload("res://addons/soleil_cutin/scenes/horizontal_slash_cutin.tscn"),
	"vertical_poster": preload("res://addons/soleil_cutin/scenes/vertical_poster_cutin.tscn"),
	"animated_horizontal_slash": preload("res://addons/soleil_cutin/scenes/animated_horizontal_slash_cutin.tscn"),
	"video_horizontal_slash": preload("res://addons/soleil_cutin/scenes/video_horizontal_slash_cutin.tscn")
}

func _ready() -> void:
	# Ensure cut-ins render above everything else including transitions
	layer = 110

## Registers a custom cut-in template for later use via play_cutin().
## [param template_id]: The string key to identify the template.
## [param template_scene]: The PackedScene of the cut-in template.
func register_template(template_id: String, template_scene: PackedScene) -> void:
	if template_scene == null:
		push_error("SoleilCutin: Cannot register a null template_scene for id '%s'." % template_id)
		return
	_cutin_templates[template_id] = template_scene

## Triggers a specific cut-in animation across the screen using a direct PackedScene.
## [param cutin_scene]: The PackedScene of the cut-in to play.
## [param data]: The CutinData resource containing the visual parameters.
func play_custom_cutin(cutin_scene: PackedScene, data: CutinData) -> void:
	if cutin_scene == null:
		push_error("SoleilCutin: No cutin_scene provided.")
		return
		
	var cutin_instance = cutin_scene.instantiate()
	add_child(cutin_instance)
	
	if cutin_instance.has_method("setup_cutin"):
		cutin_instance.setup_cutin(data)

## Triggers a specific cut-in animation across the screen.
## [param template_id]: The id of the cut-in style ("horizontal_slash" or "vertical_poster").
## [param data]: The CutinData resource containing the visual parameters (colors, images).
func play_cutin(template_id: String, data: CutinData) -> void:
	if not _cutin_templates.has(template_id):
		push_error("SoleilCutin: Template ID '" + template_id + "' not found.")
		return
		
	if data == null:
		push_warning("SoleilCutin: No CutinData provided. The cutin might look empty.")
		
	var cutin_instance = _cutin_templates[template_id].instantiate()
	add_child(cutin_instance)
	
	# Assuming standard duck-typing: if the scene has a setup_cutin method, call it.
	if cutin_instance.has_method("setup_cutin"):
		cutin_instance.setup_cutin(data)
