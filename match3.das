require daslib/media
require colors
require images
require grid
require process_match
require ui
options debugger            // uncomment for debug in VS Code
require daslib/debug        // uncomment for debug in VS Code


// 'initialize' runs once when game starts and every hot-reload
[export]
def initialize
    set_window_title("YetAnotherMatch3")
    init_start_pos()
    init_colors()
    init_images()
    init_grid()
    create_cells()
    reset_scoring()
    return

// this function is called to update game data,
// dt - time elapsed since the previous update (in seconds)
[export]
def act(dt: float)
    if get_key(VK_ESCAPE)
        schedule_quit_game()
    let pos = get_mouse_position()
    let over_reset = check_if_hover_on_reset_btn(pos)
    if get_mouse_button_down(MB_LEFT)
        if over_reset
            create_cells()
            reset_scoring()
        else
            select_and_swap_tiles(pos)

    find_removed_tiles(dt)
    return

// this function will be called every frame after 'act',
// you can draw anything in this function
[export]
def draw
    fill_rect(0, 0, get_screen_width(), get_screen_height(), 0x4056A7)
    draw_grid()
    draw_cells()
    draw_text()
    return
