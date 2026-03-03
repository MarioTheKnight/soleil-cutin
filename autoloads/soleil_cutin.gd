## Global manager for invoking dynamic cut-in animations over the gameplay.
extends CanvasLayer

var _cutin_templates = {
	"horizontal_slash": preload("res://addons/soleil_cutin/scenes/horizontal_slash_cutin.tscn"),
	"vertical_poster": preload("res://addons/soleil_cutin/scenes/vertical_poster_cutin.tscn")
}

func _ready() -> void:
	# Ensure cut-ins render above almost everything else (HUD is usually 1-10)
	layer = 100

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
