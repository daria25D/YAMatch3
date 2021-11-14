require daslib/media
require colors
require grid
options debugger            // uncomment for debug in VS Code
require daslib/debug        // uncomment for debug in VS Code


// 'initialize' runs once when game starts and every hot-reload
[export]
def initialize
    set_window_title("YetAnotherMatch3")
    init_start_pos()
    init_colors()
    init_grid()
    create_cells()
    return

// this function is called to update game data,
// dt - time elapsed since the previous update (in seconds)
[export]
def act(dt: float)
    if get_key(VK_ESCAPE)
        schedule_quit_game()
    if get_mouse_button_down(MB_LEFT)
        let pos = get_mouse_position()
        select_and_swap_tiles(pos)
    return

// this function will be called every frame after 'act',
// you can draw anything in this function
[export]
def draw
    draw_grid()
    draw_cells()
    return
