class_name Tile
extends TextureButton

signal flagged
signal unflagged
signal clicked
signal special_clicked

export(Array, Texture) var number_textures := []

# -1 means this is a mine.
var nearby_mines := 0
var is_flagged: bool setget _set_flagged, _get_flagged

var _question_mark: Texture = preload("res://sprites/overlays/question_mark.tres")
var _mine: Texture = preload("res://sprites/overlays/mine.tres")
var _button_normal: Texture = preload("res://sprites/button_states/button_normal.tres")
var _button_pressed: Texture = preload("res://sprites/button_states/button_pressed.tres")
var _button_highlighted: Texture = preload("res://sprites/button_states/button_highlighted.tres")

var _left_click

onready var _overlay: TextureRect = $Overlay


func _set_flagged(is_flagged: bool) -> void:
    # This tile has already been clicked.
    if disabled and _overlay.texture != _question_mark:
        return
        
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


func _get_flagged() -> bool:
    return disabled and _overlay.texture == _question_mark


func _gui_input(event: InputEvent) -> void:
    var mouse_event = event as InputEventMouseButton
    if mouse_event:
        if mouse_event.button_index == BUTTON_RIGHT \
           and mouse_event.pressed:
            _set_flagged(not _overlay.visible)
        # Double click to reveal nearby cells.
        elif mouse_event.button_index == BUTTON_LEFT \
           and mouse_event.doubleclick \
           and not _get_flagged():
            emit_signal("special_clicked")


func _pressed() -> void:
    reveal()


func reveal() -> void:
    # Avoid revealing twice.
    if disabled: return
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
