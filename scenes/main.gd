extends Control

const CELL_SIZE := 15
const GRID_MARGIN_SIZE := 7
const TOP_HEIGHT := 37

export var width := 20
export var height := 20

onready var _mines_manager := $MinesContainer

func _set_board_size(width, height):
    """
    Adjusts the screen size and sets the mines.
    """
    var new_size = Vector2(
        width * CELL_SIZE + 1 + GRID_MARGIN_SIZE * 2,
        height * CELL_SIZE + 1 + GRID_MARGIN_SIZE + TOP_HEIGHT
    )
    OS.window_size = new_size * 2
    get_viewport().set_size_override(false, new_size)
    
    _mines_manager.create_board(width, height)
    
    
func _ready() -> void:
    _set_board_size(width, height)
