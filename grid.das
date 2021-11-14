require daslib/media
require common
require colors
require process_match
require score


def init_start_pos()
    start_pos.x = get_screen_width() / 2 - GRID_SIZE / 2 * CELL_SIZE
    start_pos.y = get_screen_height() / 2 - GRID_SIZE / 2 * CELL_SIZE

def init_grid()
    grid.isShifting = false
    grid.cells |> resize(GRID_SIZE)
    for c in grid.cells
        c |> resize(GRID_SIZE)

def create_cells()
    prev_selected = int2(-1,-1)
    var previousLeft: Colors[GRID_SIZE]
    var previousBottom: Colors
    for i in range(GRID_SIZE)
        for j_r in range(GRID_SIZE)
            let j = GRID_SIZE - j_r - 1
            grid.cells[i][j].coord = start_pos + int2(i * CELL_SIZE, j * CELL_SIZE)
            var possibleColors := colors
            var idx_to_be_removed = find_index(possibleColors, previousLeft[j])
            if idx_to_be_removed != -1
                possibleColors |> erase(idx_to_be_removed)
            idx_to_be_removed = find_index(possibleColors, previousBottom)
            if idx_to_be_removed != -1
                possibleColors |> erase(idx_to_be_removed)
            grid.cells[i][j].color = get_random_color(possibleColors)
            previousLeft[j] = grid.cells[i][j].color
            previousBottom = grid.cells[i][j].color
            grid.cells[i][j].idx = int2(i, j)
            grid.cells[i][j].selected = false

def get_selected_tile_coords(pos: float2)
    let i = (int(pos.x) - start_pos.x) / CELL_SIZE
    let j = (int(pos.y) - start_pos.y) / CELL_SIZE
    return int2(i, j)

def select_and_swap_tiles(pos: float2)
    let selected = get_selected_tile_coords(pos)
    if !check_if_can_select_cell(selected.x, selected.y)
        return
    if grid.cells[selected.x][selected.y].selected
        grid.cells[selected.x][selected.y].selected = false
        prev_selected = int2(-1,-1)
    else
        if prev_selected.x == -1 // was not selected yet
            grid.cells[selected.x][selected.y].selected = true
            prev_selected = grid.cells[selected.x][selected.y].idx
        else
            if check_is_neighbour(grid.cells[selected.x][selected.y].idx, grid.cells[prev_selected.x][prev_selected.y].idx)
                swap_tiles(grid.cells[selected.x][selected.y], grid.cells[prev_selected.x][prev_selected.y])

                clear_all_matches(grid.cells[prev_selected.x][prev_selected.y])
                var was_match_cur = was_match
                grid.cells[prev_selected.x][prev_selected.y].selected = false
                clear_all_matches(grid.cells[selected.x][selected.y])
                was_match_cur = was_match_cur || was_match
                if !was_match_cur
                    swap_tiles(grid.cells[selected.x][selected.y], grid.cells[prev_selected.x][prev_selected.y])
                else
                    update_moves_cnt()
                prev_selected = int2(-1,-1)
            else
                grid.cells[selected.x][selected.y].selected = true
                grid.cells[prev_selected.x][prev_selected.y].selected = false
                prev_selected = grid.cells[selected.x][selected.y].idx

def swap_tiles(var c1: Cell; var c2: Cell)
    if c1.color == c2.color
        return
    var swap_color = c1.color
    c1.color = c2.color
    c2.color = swap_color

def check_is_neighbour(c1_idx: int2; c2_idx: int2)
    var is_neighbour = false
    if c1_idx.x == c2_idx.x && (c1_idx.y == c2_idx.y + 1 || c1_idx.y == c2_idx.y - 1)
        is_neighbour = true
    elif c1_idx.y == c2_idx.y && (c1_idx.x == c2_idx.x + 1 || c1_idx.x == c2_idx.x - 1)
        is_neighbour = true
    return is_neighbour

def draw_grid()
    for i in range(GRID_SIZE+1)
        line(
            start_pos.x,
            start_pos.y + i * CELL_SIZE,
            start_pos.x + GRID_SIZE * CELL_SIZE,
            start_pos.y + i * CELL_SIZE,
            GRID_COLOR
        )
    for i in range(GRID_SIZE+1)
        line(
            start_pos.x + i * CELL_SIZE,
            start_pos.y,
            start_pos.x + i * CELL_SIZE,
            start_pos.y + GRID_SIZE * CELL_SIZE,
            GRID_COLOR
        )

def draw_cells()
    for i in range(GRID_SIZE)
        for j in range(GRID_SIZE)
            let color = grid.cells[i][j].selected ? uint(grid.cells[i][j].color) + 0x242424 : uint(grid.cells[i][j].color)
            fill_rect(
                grid.cells[i][j].coord.x + (CELL_SIZE-TILE_SIZE)/2,
                grid.cells[i][j].coord.y + (CELL_SIZE-TILE_SIZE)/2,
                TILE_SIZE, TILE_SIZE,
                color
            )
