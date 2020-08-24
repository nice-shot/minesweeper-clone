extends TextureButton

signal flagged
signal unflagged
signal clicked

export(Array, Texture) var number_textures := []

# -1 means this is a mine.
var nearby_mines := 0

var _question_mark: Texture = preload("res://sprites/overlays/question_mark.tres")
var _mine: Texture = preload("res://sprites/overlays/mine.tres")
var _button_normal: Texture = preload("res://sprites/button_states/button_normal.tres")
var _button_pressed: Texture = preload("res://sprites/button_states/button_pressed.tres")
var _button_highlighted: Texture = preload("res://sprites/button_states/button_highlighted.tres")

onready var _overlay: TextureRect = $Overlay


func _set_flagged(is_flagged: bool):
    if is_flagged:
        _overlay.texture = _question_mark
        _overlay.visible = true
        texture_disabled = _button_normal
        disabled = true
        emit_signal("flagged")
    else:
        _overlay.visible = false
        texture_disabled = _button_pressed
        disabled = false
        emit_signal("unflagged")


func _gui_input(event: InputEvent) -> void:
    var mouse_event = event as InputEventMouseButton
    if mouse_event \
       and mouse_event.button_index == BUTTON_RIGHT \
       and mouse_event.pressed:
        _set_flagged(not _overlay.visible)


func _pressed() -> void:
    match nearby_mines:
        -1:
            _overlay.texture = _mine
        0:
            _overlay.texture = null
        _:
            _overlay.texture = number_textures[nearby_mines - 1]
    _overlay.visible = true
    disabled = true
    emit_signal("clicked")
