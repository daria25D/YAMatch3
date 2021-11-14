require daslib/media
require common

let
    SCORE = "SCORE"
    MOVE_CNT = "MOVES"
    OFFSET_Y = 20

var
    x_pos_middle: int
    y_pos_middle: int

def reset_scoring()
    score = 0
    moves_cnt = 0
    x_pos_middle = get_screen_width() / 2
    y_pos_middle = start_pos.y / 2

def update_score(inc: int)
    score += inc

def update_moves_cnt()
    moves_cnt += 1

def draw_score()
    let s = "{SCORE}: {score}"
    let size = get_text_size(s)
    text_out(x_pos_middle - int(size.x) / 2, y_pos_middle - int(size.y) / 2 - OFFSET_Y, s, 0xFFFFFF)

def draw_moves_cnt()
    let s = "{MOVE_CNT}: {moves_cnt}"
    let size = get_text_size(s)
    text_out(x_pos_middle - int(size.x) / 2, y_pos_middle - int(size.y) / 2 + OFFSET_Y, s, 0xFFFFFF)

def draw_scoring()
    draw_score()
    draw_moves_cnt()
