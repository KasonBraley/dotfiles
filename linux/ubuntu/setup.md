Add keyboard layout
    // seems to work only for the gnome Ubuntu; for awesome see after this section
    - clone dotfiles
    - add variant to file
    sudo vim /usr/share/X11/xkb/rules/evdev.xml
            <variant>
                <configItem>
                    <name>real-prog-dvorak</name>
                    <description>English (Real Programmers Dvorak)</description>
                    <vendor>MichaelPaulson</vendor>
                </configItem>
            </variant>

    - add to /usr/share/X11/xkb/symbols/us
        sudo nvim /usr/share/X11/xkb/symbols/us
        copy the keyboard layout from dotfiles into this file, above the other programmer dvorak layout
    - change in ubuntu settings or setxkbmap

For AwesomeWM:
    - uses iBus https://vas.neocities.org/custom_keyboard_layout_xkb_ibus.html
    - still need the variant in /usr/share/X11/xkb/rules/evdev.xml
    - still need the layout in /usr/share/X11/xkb/symbols/us
    - sudo nivm /usr/share/ibus/component/simple.xml
    - add this above programmer dvorak
        <engine>
            <name>xkb:us:real-prog-dvorak:eng</name>
            <language>en</language>
            <license>GPL</license>
            <author>Michael Paulson</author>
            <layout>us</layout>
            <layout_variant>real-prog-dvorak</layout_variant>
            <longname>English (real programmer Dvorak)</longname>
            <description>English (real programmer Dvorak)</description>
            <icon>ibus-keyboard</icon>
            <rank>1</rank>
        </engine>
    - logout
    - right click ibus thing in top right menu bar of awesome
    - set the layout

## Kitty

https://sw.kovidgoyal.net/kitty/binary/

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/
