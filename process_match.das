require daslib/media
require common

var
    match_found: bool

def check_if_can_select_cell(i: int; j: int)
    return (i >= 0 && i < GRID_SIZE && j >= 0 && j < GRID_SIZE)

def find_match(cell: Cell; dir: int2)
    var matchingTiles: array<Cell>
    var coord = cell.idx + dir
    debug(coord)
    while check_if_can_select_cell(coord.x, coord.y)
        if cell.color == grid.cells[coord.x][coord.y].color
            matchingTiles |> push(grid.cells[coord.x][coord.y])
        else
            break
        coord += dir
    return <- matchingTiles

def clear_matching_tiles(cell: Cell; dirs: int2[2])
    var matchingTiles: array<Cell>
    for dir in dirs
        var mt <- find_match(cell, dir)
        for t in mt
            matchingTiles |> push(t)
    if length(matchingTiles) >= 2
        for m in matchingTiles
            grid.cells[m.idx.x][m.idx.y].color = Colors BLACK
        match_found = true

def clear_all_matches(var cell: Cell)
    if cell.color == Colors BLACK
        return
    clear_matching_tiles(cell, [[int2 int2(-1, 0); int2(1, 0)]])
    clear_matching_tiles(cell, [[int2 int2(0, -1); int2(0, 1)]])
    if match_found
        cell.color = Colors BLACK
        match_found = false

