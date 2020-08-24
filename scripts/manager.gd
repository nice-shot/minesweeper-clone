extends Node

const MINE_PERCENTAGE := 0.25

var _tile_scene := preload("res://scenes/tile.tscn")
var _mine_matrix: Array
var _mines_placed := false

onready var _grid: GridContainer = $GridContainer/Grid


func _calculate_nearby_mines(row, column) -> int:
    var nearby_mines = 0
    for i in range(row - 1, row + 2):
        if i < 0 or i >= len(_mine_matrix): continue
        for j in range(column - 1, column + 2):
            if j < 0 or j >= len(_mine_matrix[0]): continue
            var tile: Tile = _mine_matrix[i][j]
            if tile.nearby_mines == -1:
                nearby_mines += 1
    return nearby_mines


func _place_mines(starting_row, starting_column) -> void:
    _mines_placed = true
    var total_tiles := _grid.get_child_count()
    var remaining_mines := total_tiles * MINE_PERCENTAGE
    
    # Randomly place mines.
    for row_index in len(_mine_matrix):
        var row = _mine_matrix[row_index]
        for column_index in len(row):
            var tile: Tile = row[column_index]
            # Make sure the clicked tile and it's surroundings are not mines.
            if row_index >= starting_row - 1 and row_index <= starting_row + 1 \
               and column_index >= starting_column - 1 \
               and column_index <= starting_column + 1:
                continue
            var tile_index = row_index + column_index
            var is_mine = randf() < remaining_mines / (total_tiles - tile_index)
            if is_mine:
                tile.nearby_mines = -1
                remaining_mines -= 1
    
    # Set numbers based on mines
    for row_index in len(_mine_matrix):
        var row = _mine_matrix[row_index]
        for column_index in len(row):
            var tile: Tile = row[column_index]
            if tile.nearby_mines != -1:
                tile.nearby_mines = _calculate_nearby_mines(row_index, column_index)
                

func _on_tile_clicked(row, column) -> void:
    print("Clicked on tile: %dx%d" % [row, column])
    if not _mines_placed:
        _place_mines(row, column)


func _create_board(width: int, height: int) -> void:
    print("Creating board: %dX%d" % [width, height])
    
    _mines_placed = false
    
    # Create a dataset to place the tiles in
    _mine_matrix = []
    for _i in range(height):
        _mine_matrix.append([])
    
    # Clear board
    for child in _grid.get_children():
        child.queue_free()
    
    # Place new tiles and set mines in them
    _grid.columns = width
    var total_tiles := width * height
    
    for i in range(0, total_tiles):
        var tile: Tile = _tile_scene.instance()
        var current_row = int(i / width)
        var current_column = i % width
        tile.connect("clicked", self, "_on_tile_clicked", [current_row, current_column])
        _mine_matrix[current_row].append(tile)
        
        _grid.add_child(tile)


func _ready() -> void:
    reset()


func reset() -> void:
    _create_board(20, 20)


func expose() -> void:
    for tile in _grid.get_children():
        tile._pressed()
