# When using wayland, enable various wayland features
if [[ "$WAYLAND_DISPLAY" ]]; then
    # GTK3
    export GDK_BACKEND=wayland
    export CLUTTER_BACKEND=wayland

    # QT5
    export QT_QPA_PLATFORM=wayland-egl
    export QT_QPA_PLATFORMTHEME=qt5ct # gnome | gtk2 | gtk3

    # Mozilla
    export MOZ_ENABLE_WAYLAND=1
    export MOZ_WEBRENDER=1

    # EFL
    export ECORE_EVAS_ENGINE=wayland_egl
    export ELM_ENGINE=wayland_egl

    # SDL
    export SDL_VIDEODRIVER=wayland

    # Java
    export _JAVA_AWT_WM_NONREPARENTING=1

    # Alias to enforce X11 mode via Xwayland
    alias ,x11="GDK_BACKEND=x11 CLUTTER_BACKEND=gdk QT_QPA_PLATFORM=xcb MOZ_ENABLE_WAYLAND=0 SDL_VIDEODRIVER=x11"
fi

