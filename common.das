require daslib/media

let
    GRID_SIZE = 10
    CELL_SIZE = 50
    TILE_SIZE = 48
    GRID_COLOR = 0xFFFFFF
    LEVELS = [[int2 int2(50, 17); int2(60, 18); int2(70, 19); int2(80, 20), int2(90, 21)]]

enum Colors
    YELLOW = 0xD3D305
    RED    = 0xD40808
    GREEN  = 0x059440
    BLUE   = 0x10109C
    PURPLE = 0x6E076E
    BLACK  = 0x000000

struct Cell
    coord: int2
    color: Colors
    idx:  int2
    selected: bool


struct Grid
    cells: array<array<Cell>>
    isShifting: bool

var
    start_pos: int2
    colors: array<Colors>
    grid: Grid
    seed = int4(123, 124, 3978, 123)
    prev_selected: int2
    score: int
    moves_cnt: int
    level: int = 0
    show_success_screen: bool = false
    show_losing_screen: bool = false
