require daslib/media
require common

let
    SCORE = "SCORE"
    MOVE_CNT = "MOVES"
    OFFSET_Y = 20
    RESET = "RESET FIELD"
    LEVEL = "LEVEL"
    SUCCESS = "LEVEL PASSED! PRESS SPACE TO START NEXT LEVEL"
    LOSE = "FAILED... PRESS SPACE TO TRY AGAIN"
    VICTORY = "YOU WON! PRESS SPACE TO START OVER"

var
    x_pos_middle: int
    y_pos_middle: int
    y_reset_middle: int
    should_draw_rect: bool
    reset_btn_size: float2

def reset_scoring()
    score = 0
    moves_cnt = 0

def init_ui()
    reset_scoring()
    x_pos_middle = get_screen_width() / 2
    y_pos_middle = start_pos.y / 2
    y_reset_middle = get_screen_height() - start_pos.y / 2
    should_draw_rect = false
    reset_btn_size = get_text_size("{RESET}")

def update_score(inc: int)
    score += inc

def update_moves_cnt()
    moves_cnt += 1

def check_if_hover_on_reset_btn(pos: float2)
    should_draw_rect = false
    let size = reset_btn_size
    if (pos.x >= float(x_pos_middle) - size.x / 2. - 5.) && (pos.x <= float(x_pos_middle) + size.x / 2. + 5.)
        if (pos.y >= float(y_reset_middle) - size.y / 2. - 5.) && (pos.y <= float(y_reset_middle) + size.y / 2. + 5.)
            should_draw_rect = true
    return should_draw_rect

def set_score_screen(success: bool)
    if success
        show_success_screen = true
    else
        show_losing_screen = true

def reset_score_screen()
    show_success_screen = false
    show_losing_screen = false

def draw_score()
    let s = "{SCORE}: {score}/{LEVELS[level].x}"
    let size = get_text_size(s)
    text_out(x_pos_middle - int(size.x) / 2, y_pos_middle - int(size.y) / 2 - OFFSET_Y, s, 0xFFFFFF)

def draw_moves_cnt()
    let s = "{MOVE_CNT}: {moves_cnt}/{LEVELS[level].y}"
    let size = get_text_size(s)
    text_out(x_pos_middle - int(size.x) / 2, y_pos_middle - int(size.y) / 2 + OFFSET_Y, s, 0xFFFFFF)

def draw_level()
    let s = "{LEVEL}: {level+1}"
    let size = get_text_size(s)
    text_out(10, 10, s, 0xFFFFFF)

def draw_reset_btn()
    let size = int2(reset_btn_size)
    text_out(x_pos_middle - int(size.x) / 2, y_reset_middle - int(size.y) / 2, RESET, 0xFFFFFF)
    if should_draw_rect
        rect(float(x_pos_middle) - reset_btn_size.x / 2. - 20., float(y_reset_middle) - reset_btn_size.y / 2. - 20.,
             reset_btn_size.x + 40., reset_btn_size.y + 40., 0xFFFFFF)

def draw_text()
    draw_score()
    draw_moves_cnt()
    draw_reset_btn()
    draw_level()

def draw_success_screen()
    let s = level == length(LEVELS) - 1 ? "{VICTORY}" : "{SUCCESS}"
    let size = get_text_size(s)
    text_out(x_pos_middle - int(size.x) / 2, get_screen_height()/2 - int(size.y) / 2, s, 0xFFFFFF)

def draw_losing_screen()
    let s = "{LOSE}"
    let size = get_text_size(s)
    text_out(x_pos_middle - int(size.x) / 2, get_screen_height()/2 - int(size.y) / 2, s, 0xFFFFFF)
