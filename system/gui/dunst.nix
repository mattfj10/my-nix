{
    enable = true;
        settings = {
        global = {
            show_indicators = true;  # Shows the "X" close button
            mouse_left_click = "do_action";  # Click to close
            mouse_right_click = "context";  # Right click for context menu
            # Icon settings
            enable_recursive_icon_lookup = true;
            icon_theme = "Adwaita";
            icon_position = "left";
            min_icon_size = 32;
            max_icon_size = 128;
            
            # Other common settings you might want
            font = "Roboto 11";
            frame_width = 2;
            frame_color = "#aaaaaa";
            
            # Positioning
            origin = "top-right";
            offset = "10x50";
            width = 300;
            height = 300;
        };
    };
}
