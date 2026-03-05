class_name CutinData extends Resource

## The main image or portrait shown in the cutin.
@export var character_portrait: Texture2D

## Optional Frame-based animation for the portrait (overrides static portrait if set).
@export var animated_portrait: SpriteFrames

## Optional Video for the cut-in (overrides static and animated portrait if set).
@export var video_portrait: VideoStream

## The background strip or poster color.
@export var background_color: Color = Color(0.1, 0.1, 0.1, 1.0)

## The color for effects, text, or accents.
@export var fx_color: Color = Color.WHITE

## The text string displayed, usually the character's or attack's name.
@export var title_text: String = "Special Attack"
