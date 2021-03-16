## A config for [Hammerspoon](https://github.com/Hammerspoon/hammerspoon)

## Requirements

- [Karabiner-elements](https://karabiner-elements.pqrs.org/) is required to bind Capslock key (or any other of your choice) to the Hyper key 
  (combination of Shift, Option, Control and Command).
  - Install Karabiner-elements manually or via brew:
    ```
      brew install --cask karabiner-elements
    ```
  - Open it and go to the tab Complex modifications.
  - Click Add rule in the bottom left corner.
  - Enable the option Change caps_lock to command+control+option+shift.
- Go to System Preferences -> Security & Privacy -> Privacy and add both Hammerspoon and Karabiner-Elements in the Accessibility tab

## How to use it

1. Install [Hammerspoon](http://www.hammerspoon.org/)
    ```   
    brew install --cask hammerspoon
    ```
2. Clone this repository into your ~/.hammerspoon directory:
   
       git clone git@github.com:levinine/hammerspoon-config.git ~/.hammerspoon

3. Review [init.lua](./init.lua) and change or disable any features as needed.

4. Run Hammerspoon. All the necessary Spoons will be downloaded, installed and configured automatically

5. Voila. 
   Hammerspoon docs can be found [here](https://www.hammerspoon.org/docs/index.html) 
   Hammerspoon website can be found [here](https://www.hammerspoon.org/)

## Features
* [Hyper bindings](./hyper-bindings.lua)
  * Binds multiple hotkeys to run various apps
* [Web mode binder](./web-mode-binder.lua)
  * Binder mode to:
    * open pages in browser
    * copy URL of current window
    * extract Jira ticket number from current window
* [Teams toggle mute](./teams-toggle-mute.lua)
  * Binds a hotkey which triggers toggle mute on Teams and focuses the application
* [Keyboard layout switcher](./keyboard-layout-switcher.lua)
  * Toggle different keyboard layouts
  * Colorize the menu bar based on the chosen layout
* [Window Management](./window-management.lua)
   * Set window to full-screen mode
   * Maximize a window (not the full-screen mode)
   * Set window to 50% width left or right 
   * Move window to another display
   * Show a split window popup for splitting two apps on the screen
   * Move mouse to the closest edge of the current window.
* [Translation popup](./translation-popup.lua)
  * Binds a hotkey which triggers a popup with Google Translate of the selected text
* [Vpn connection](./vpn.lua)
  * Binds a hotkey which triggers connection to VPN using Tunnelblick
* [Text manipulation](./text-manipulation.lua)
  * To uppercase
  * To lowercase
* [Jwt token paster](./jwt-token.lua)
  * Pastes a long JWT token
* [Hold to quit](./hold-to-quit.lua)
  * Requires the user to hold CMD + Q in order to quit the app and shows a proper message
* [Mouse finder](./mouse-finder.lua)
  * Binds a hotkey used to locate your mouse on the screen
* [Keypress show](./keypress-show.lua)
  * Provide an easy way of showing keystrokes on the screen. It's inspired by other tools like Keycastr.
* [Audio watcher/toggler](./audio-watcher.lua)
   * Toggle output audio device
   * Show a menu bar item with a prefix of the device. Click on the menu bar toggles the device
* [Wifi watcher](./wifi-watcher.lua)
   * Toggle connected Wi-Fi network
   * Show a menu bar item showing: LAN+WifiNetworkPrefix or just WifiNetworkPrefix if LAN is not connected . Click on the menu bar toggles the 
     Wi-Fi network
* [Rounded corners](./rounded-corners.lua)
   * Renders nice mac friendly rounded corners on the screen

## Inspiration, copycat sources, ideas, etc sources:
- https://github.com/babarrett/hammerspoon/
- https://github.com/miromannino/miro-windows-manager
- https://github.com/zzamboni/hammerspoon-config
- https://github.com/cmsj/hammerspoon-config
- https://github.com/kev-zheng/hammerspoon
- https://github.com/evantravers/hammerspoon-config
- https://gist.github.com/ysimonson/fea48ee8a68ed2cbac12473e87134f58
- https://www.reddit.com/r/hammerspoon/
