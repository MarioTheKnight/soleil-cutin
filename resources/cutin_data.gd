class_name CutinData extends Resource

## The main image or portrait shown in the cutin.
@export var character_portrait: Texture2D

## The background strip or poster color.
@export var background_color: Color = Color(0.1, 0.1, 0.1, 1.0)

## The color for effects, text, or accents.
@export var fx_color: Color = Color.WHITE

## The text string displayed, usually the character's or attack's name.
@export var title_text: String = "Special Attack"
