extends Control

const CELL_SIZE := 15
const GRID_MARGIN_SIZE := 7
const TOP_HEIGHT := 37

export var width := 20
export var height := 20

onready var _mines_manager := $MinesContainer
onready var _retry_symbol: Control = $TopButtons/ResetButton/RetrySymbol
onready var _lost_symbol: Control = $TopButtons/ResetButton/LostSymbol
onready var _won_symbol: Control = $TopButtons/ResetButton/WonSymbol


func _ready() -> void:
    set_board_size(width, height)


func set_board_size(width: int, height: int) -> void:
    """
    Adjusts the screen size and sets the mines.
    """
    var new_size := Vector2(
        width * CELL_SIZE + 1 + GRID_MARGIN_SIZE * 2,
        height * CELL_SIZE + 1 + GRID_MARGIN_SIZE + TOP_HEIGHT
    )
    get_viewport().set_size_override(false, new_size)
    OS.window_size = new_size * 2
    rect_size = new_size
#    ProjectSettings.set_setting("display/window/size/width", new_size.x)
#    ProjectSettings.set_setting("display/window/size/height", new_size.y)
#    print(ProjectSettings.get_setting("display/window/size/width"))
    
    _mines_manager.create_board(width, height)
    # Wait two frames to recenter the stage.
    yield(get_tree(), "idle_frame")
    yield(get_tree(), "idle_frame")
    yield(get_tree(), "idle_frame")
    rect_position = Vector2(0, 0)


func on_lost() -> void:
    _retry_symbol.visible = false
    _lost_symbol.visible = true
    _won_symbol.visible = false


func on_won() -> void:
    _retry_symbol.visible = false
    _lost_symbol.visible = false
    _won_symbol.visible = true


func on_reset() -> void:
    _retry_symbol.visible = true
    _lost_symbol.visible = false
    _won_symbol.visible = false
    
