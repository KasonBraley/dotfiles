# Only start if not already running 
if xrandr | grep -q 'DP-1' ; then
    MAIN_DISPLAY=$(xrandr | grep '^DP-1.* connected' | awk '{print $1;}')
    LAPTOP_DISPLAY=$(xrandr | grep '^eDP-1.* connected' | awk '{print $1;}')
    xrandr --auto --output $MAIN_DISPLAY --mode 2560x1440 --rate 144 --left-of $LAPTOP_DISPLAY --output $LAPTOP_DISPLAY --mode 1920x1080
fi
