require daslib/media
require common
require colors
require ui

let
    WAIT_TIME = 0.2

var
    match_found: bool
    was_match: bool
    time_to_fill: float
    need_to_shift: bool
    wait_to_shift: bool = true

def check_if_can_select_cell(i: int; j: int)
    return (i >= 0 && i < GRID_SIZE && j >= 0 && j < GRID_SIZE)

def find_match(cell: Cell; dir: int2)
    var matchingTiles: array<Cell>
    var coord = cell.idx + dir
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
        update_score(length(matchingTiles) + 1)

def clear_all_matches(var cell: Cell)
    was_match = false
    if cell.color == Colors BLACK
        return
    clear_matching_tiles(cell, [[int2 int2(-1, 0); int2(1, 0)]])
    clear_matching_tiles(cell, [[int2 int2(0, -1); int2(0, 1)]])
    if match_found
        cell.color = Colors BLACK
        was_match = true
        match_found = false

def find_removed_tiles(dt: float)
    time_to_fill = max(time_to_fill - dt, -0.1)
    if time_to_fill < 0.0
        wait_to_shift = !need_to_shift
        need_to_shift = false
    else
        return
    for i in range(GRID_SIZE)
        for j_r in range(GRID_SIZE)
            let j = GRID_SIZE - j_r - 1
            if grid.cells[i][j].color == Colors BLACK
                if !wait_to_shift
                    shift_tiles_down(i, j)
                need_to_shift = true
            if need_to_shift
                wait_to_shift = true
                time_to_fill = WAIT_TIME
                return

    for i in range(GRID_SIZE)
        for j_r in range(GRID_SIZE)
            let j = GRID_SIZE - j_r - 1
            clear_all_matches(grid.cells[i][j])

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
