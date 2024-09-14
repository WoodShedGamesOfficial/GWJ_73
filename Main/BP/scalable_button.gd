class_name ScalableButton extends Button

@export_category("Editable")
@export var text_string:String = ""
@export var text_size:int = 16
@export var unmodulated_icon_texture:Texture
@export var focus_color_background:Color = Color(106.0/255,156.0/255,137.0/255)
@export var focus_color_text_icon:Color = Color(233.0/255,239.0/255,236.0/255)
@export var unfocus_color_background:Color = Color(22.0/255,66.0/255,60.0/255)
@export var unfocus_color_text_icon:Color = Color(106.0/255,156.0/255,137.0/255)
@export var outline_color:Color = Color(233.0/255,239.0/255,236.0/255)
@export var outline_width:int = 4

@export_category("DON'T EDIT")
@export var animation_player:AnimationPlayer
@export var text_label:Label
@export var texture_rect:TextureRect
@export var background:ColorRect
@export var outline:TextureProgressBar
@export var margin_container:MarginContainer
#-------------------------------------------------------------------------------
func _ready() -> void:
	text_label.text = text_string
	text_label.add_theme_font_size_override(&"font_size", text_size)
	texture_rect.texture = unmodulated_icon_texture
	
	text_label.modulate = unfocus_color_text_icon
	texture_rect.modulate = unfocus_color_text_icon
	background.color = unfocus_color_background
	outline.modulate = outline_color
	outline.value = 0
	
	margin_container.add_theme_constant_override(&"margin_left", outline_width)
	margin_container.add_theme_constant_override(&"margin_right", outline_width)
	margin_container.add_theme_constant_override(&"margin_top", outline_width)
	margin_container.add_theme_constant_override(&"margin_bottom", outline_width)
#-------------------------------------------------------------------------------
func _on_mouse_entered() -> void:
	animation_player.play(&"focus")
	
	text_label.add_theme_constant_override(&"outline_size", 3)
	var focus_tween:Tween = create_tween(); focus_tween.set_parallel(true)
	focus_tween.tween_property(texture_rect, "modulate", focus_color_text_icon, 0.15)
	focus_tween.tween_property(text_label, "modulate", focus_color_text_icon, 0.15)
	focus_tween.tween_property(background, "color", focus_color_background, 0.05)
#-------------------------------------------------------------------------------
func _on_mouse_exited() -> void:
	animation_player.play(&"unfocus")
	
	text_label.add_theme_constant_override(&"outline_size", 0)
	var unfocus_tween:Tween = create_tween(); unfocus_tween.set_parallel(true)
	unfocus_tween.tween_property(texture_rect, "modulate", unfocus_color_text_icon, 0.15)
	unfocus_tween.tween_property(text_label, "modulate", unfocus_color_text_icon, 0.15)
	unfocus_tween.tween_property(background, "color", unfocus_color_background, 0.25)
#-------------------------------------------------------------------------------
