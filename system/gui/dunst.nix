{
    enable = true;
        settings = {
        global = {
            show_indicators = true;  # Shows action indicators
            mouse_left_click = "close_current";  # Left click to close notification
            mouse_middle_click = "do_action";  # Middle click for actions
            mouse_right_click = "close_all";  # Right click to close all notifications
            close = "ctrl+space";  # Keyboard shortcut to close notification
            close_all = "ctrl+shift+space";  # Keyboard shortcut to close all notifications
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
