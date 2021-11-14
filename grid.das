require daslib/media

let
    GRID_SIZE = 10
    CELL_SIZE = 40
    TILE_SIZE = 32
    GRID_COLOR = 0xFFFFFF

enum Colors
    YELLOW = 0xD3D305
    RED    = 0xD40808
    GREEN  = 0x059440
    BLUE   = 0x10109C
    PURPLE = 0x6E076E

struct Cell
    coord: int2
    color: uint
    idx:  int2
    selected: bool


struct Grid
    cells: array<array<Cell>>

var
    start_pos: int2
    colors: array<Colors>
    grid: Grid
    seed = int4(123, 124, 3978, 123)

def init_start_pos()
    start_pos.x = get_screen_width() / 2 - GRID_SIZE / 2 * CELL_SIZE
    start_pos.y = get_screen_height() / 2 - GRID_SIZE / 2 * CELL_SIZE

def init_colors()
    for c in each_enum(Colors YELLOW)
        push(colors, c)

def get_random_color()
    let random_idx = random_int(seed) % 5
    return uint(colors[random_idx])

def init_grid()
    grid.cells |> resize(GRID_SIZE)
    for c in grid.cells
        c |> resize(GRID_SIZE)

def create_cells()
    for i in range(GRID_SIZE)
        for j in range(GRID_SIZE)
            grid.cells[i][j].coord = start_pos + int2(i * CELL_SIZE, j * CELL_SIZE)
            grid.cells[i][j].color = get_random_color()
            grid.cells[i][j].idx = int2(i, j)
            grid.cells[i][j].selected = false

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
            fill_rect(
                grid.cells[i][j].coord.x + (CELL_SIZE-TILE_SIZE)/2,
                grid.cells[i][j].coord.y + (CELL_SIZE-TILE_SIZE)/2,
                TILE_SIZE, TILE_SIZE,
                grid.cells[i][j].color
            )
