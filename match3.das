require daslib/media
require colors
require common
require images
require grid
require process_match
require ui
options debugger            // uncomment for debug in VS Code
require daslib/debug        // uncomment for debug in VS Code

var
    time_to_show_field: float = 1.

// 'initialize' runs once when game starts and every hot-reload
[export]
def initialize
    set_window_title("YetAnotherMatch3")
    set_resolution(720, 720)
    init_start_pos()
    init_colors()
    init_images()
    init_grid()
    create_cells()
    init_ui()
    return

// this function is called to update game data,
// dt - time elapsed since the previous update (in seconds)
[export]
def act(dt: float)
    if get_key(VK_ESCAPE)
        schedule_quit_game()
    if !show_success_screen && !show_losing_screen
        if score >= LEVELS[level].x && moves_cnt <= LEVELS[level].y
            set_score_screen(true)
            time_to_show_field = 1.0
        if moves_cnt >= LEVELS[level].y && score < LEVELS[level].x
            set_score_screen(false)
            time_to_show_field = 1.0

        let pos = get_mouse_position()
        let over_reset = check_if_hover_on_reset_btn(pos)
        if get_mouse_button_down(MB_LEFT)
            if over_reset
                create_cells()
                reset_scoring()
            else
                select_and_swap_tiles(pos)

        find_removed_tiles(dt)
    time_to_show_field -= dt
    if get_key_down(VK_SPACE)
        create_cells()
        reset_scoring()
        if show_success_screen
            level = (level + 1) % length(LEVELS)
        reset_score_screen()
    return

// this function will be called every frame after 'act',
// you can draw anything in this function
[export]
def draw
    fill_rect(0, 0, get_screen_width(), get_screen_height(), 0x4056A7)
    if show_success_screen && time_to_show_field < 0.
        draw_success_screen()
    elif show_losing_screen  && time_to_show_field < 0.
        draw_losing_screen()
    else
        draw_grid()
        draw_cells()
        draw_text()
    return
