require daslib/media
require common
require colors

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

def find_removed_tiles()
    for i_r in range(GRID_SIZE)
        for j_r in range(GRID_SIZE)
            let i = GRID_SIZE - i_r - 1
            let j = GRID_SIZE - j_r - 1
            if grid.cells[i][j].color == Colors BLACK
                shift_tiles_down(i, j)
                break

def shift_tiles_down(i: int; j_start: int)
    grid.isShifting = true
    var c: array<Cell>
    var removed = 0
    for j_r in range(0, j_start + 1)
        let j = j_start - j_r
        if grid.cells[i][j].color == Colors BLACK
            removed += 1
        c |> push(grid.cells[i][j])
    for k in range(removed)
        for j in range(length(c)-1)
            grid.cells[c[j].idx.x][c[j].idx.y].color = grid.cells[c[j+1].idx.x][c[j+1].idx.y].color
            grid.cells[c[j+1].idx.x][c[j+1].idx.y].color = fill_missing_tiles(i, 0)
    grid.isShifting = false

def fill_missing_tiles(i: int; j: int)
    debug(int2(i,j))
    var possibleColors := colors
    var idx_to_be_removed: int
    if i > 0
        idx_to_be_removed = find_index(possibleColors, grid.cells[i - 1][j].color)
        if idx_to_be_removed != -1
            possibleColors |> erase(idx_to_be_removed)
    if i < GRID_SIZE - 1
        idx_to_be_removed = find_index(possibleColors, grid.cells[i + 1][j].color)
        if idx_to_be_removed != -1
            possibleColors |> erase(idx_to_be_removed)
    if j < GRID_SIZE - 1
        idx_to_be_removed = find_index(possibleColors, grid.cells[i][j + 1].color)
        if idx_to_be_removed != -1
            possibleColors |> erase(idx_to_be_removed)
    return get_random_color(possibleColors)
