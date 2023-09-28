# I38

Accessibility setup script for the i3 window manager.

## i38.sh
Released under the terms of the WTFPL License: http://www.wtfpl.net
This is a Stormux project: https://stormux.org


## Why the name?

An uppercase I looks like a 1, 3 from i3, and 8 because the song [We Are 138](https://www.youtube.com/watch?v=-n2Mkdw4q44) rocks!


## Requirements

- i3-wm: The i3 window manager.
- acpi: [optional] for battery status. It will still work even without this package, but uses it if it is installed.
- dex: [optional] Alternative method for auto starting applications.
- clipster: clipboard manager
- jq: for getting the current workspace
- libcanberra: [optional]To play the desktop login sound.
- libnotify: For sending notifications
- lxsession: For policykit authentication agent.
- notification-daemon: To handle notifications
- ocrdesktop: For getting contents of the current window with OCR.
- pamixer: for the mute-unmute script
- playerctl: music controls
- python-i3ipc: for sounds etc.
- remind: [optional]For reminder notifications, Requires notify-daemon and notify-send for automatic reminders.
- sgtk-menu: for applications menu
- sox: for sounds.
- transfersh: [optional] for file sharing GUI
- udiskie: [optional] for automatically mounting removable storage
- xclip: Clipboard support
- xbacklight: [optional] for screen brightness adjustment
- xorg-setxkbmap: [optional] for multiple keyboard layouts
- yad: For screen reader accessible dialogs

I38 will try to detect your browser, file manager, and web browser and present you with a list of options to bind to their launch keys. It will also create bindings for pidgin and mumble if they are installed. To use the bindings, press your ratpoison mode key which is set when you run the i38.sh script. next, press the binding for the application you want, w for web browser, e for text editor, f for file manager, m for mumble, etc. To learn all the bindings, find and read the mode ratpoison section of ~/.config/i3/config.


## Usage:

- With no arguments, create the i3 configuration.
- -h: This help screen.
- -u: Copy over the latest version of scripts.
- -x: Generate ~/.xinitrc and ~/.xprofile.
- -X: Generate ~/.xprofile only.


## Ratpoison Mode

I38 is an adaptation of the old Strychnine project which was based on the Ratpoison window manager. Ratpoison is a screen like window manager, and the important concept from that, which applies to I38, is adding keyboard shortcuts without conflicting application shortcuts. This is done with an "escape key".

When creating I38, I really wanted to port that functionality over, because it is very powerful and allows for lots and lots of shortcuts while minimizing collisions between shortcuts. So, for example, if you have chosen brave as your web browser, and selected alt+escape as your ratpoison mode key, you can quickly launch brave by pressing alt+escape followed by the letter w.


## I38 Help

To get help for I38, you can press the top level keybinding alt+shift+F1. It is also available by pressing the ratpoison mode key followed by question mark. A limitation of yad, which is used to display the help text means that the cursor starts at the bottom of the text. Please press control+home to jump to the top. You can navigate with the arrow keys, and use control+f to find text within the document.

The help text is a modified version of the configuration file itself that is intended to be easier to read. I have tried to add in comments that should also serve to make things more clear.
