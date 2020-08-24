extends Node


var _tile_scene := preload("res://scenes/tile.tscn")

onready var _grid: GridContainer = $GridContainer/Grid


func _create_board(width: int, height: int) -> void:
    print("Creating board: %dX%d" % [width, height])
    
    # Clear board
    for child in _grid.get_children():
        child.queue_free()
    
    # Place new tiles    
    _grid.columns = width
    var total_tiles := width * height
    for i in range(0, total_tiles):
        var tile = _tile_scene.instance()
        _grid.add_child(tile)
    
    # Decide which ones are mines
    var num_of_mines := total_tiles * 0.4


func _ready() -> void:
    reset()


func reset() -> void:
    _create_board(20, 20)
