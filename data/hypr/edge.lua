hl.window_rule {
    match = {
        class = "^()$",
        title = "^()$",
        initial_class = "^()$",
        initial_title = "^()$",
    },
    no_initial_focus = true,
    float = true,
    move = {"cursor_x-(window_w/2)", "cursor_y-window_h-2"},
}
