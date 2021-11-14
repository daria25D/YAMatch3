require daslib/media
require common

def init_colors()
    for c in each_enum(Colors YELLOW)
        if c == Colors BLACK
            break
        push(colors, c)

def get_random_color(col: array<Colors>)
    let random_idx = random_int(seed) % length(col)
    return col[random_idx]
