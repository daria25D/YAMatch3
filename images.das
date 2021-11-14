require daslib/media
require common

let
    images_paths = [[string "./images/1.png"; "./images/2.png"; "./images/3.png"; "./images/4.png"; "./images/5.png"; "./images/6.png"]]

var
    color_image_acc: table<Colors; Image>


def init_images()
    var i = 0
    for c in each_enum(Colors YELLOW)
        if c == Colors BLACK
            break
        color_image_acc[c] <- create_image(images_paths[i])
        color_image_acc[c] |> set_image_smooth(true)
        i += 1