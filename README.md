# dotfiles
My 'Awesome' dotfiles

## details
+ **OS**: Manjaro 18.0 or Fedora 29 (Laptop / Desktop)
+ **WM**: Awesome
+ **Terminal**: Termite
+ **File Manager**: Ranger
+ **Launcher**: Rofi
+ **Editors**: Atom and Nano
+ **Browsers**: Firefox and [Qutebrowser](https://www.qutebrowser.org/)
+ **Media Players**: VLC for videos, Spotify for music

## Current Version
![Screenshot](./screenshots/cairngorm.png?raw=true "<screenshot>")

### File structure
+ My `rc.lua` is split into multiple files for readability e.g. `bindings.lua` for key and mouse bindings.
+ My helper file equivalent is called `Utils.lua`
+ Colour-specific utilities such as the gradient generator can be found in `ColorUtils`.
+ All other widget configurations can be found in `components`

### Bindings

I use `super` as my main modifier.

#### Keyboard
+ `ctrl + alt + t` - Spawn terminal
+ `super + d` - Launch rofi window switcher
+ `super + r` - Launch rofi run menu
+ `super + f` - Toggle fullscreen
+ `super + m` - Toggle maximize
+ `super + n` - Minimize
+ `super + shift + n` - Restore minimized
+ `super + u` - Jump to urgent client

#### Mouse

+ `Middle mouse` - Destroy all notifications
+ `Scroll Wheel` - Switch tags (by scroll direction)
