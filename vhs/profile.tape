# GitHub profile animation — n3dypop
# Run from this directory: vhs profile.tape
Output ../assets/profile.gif

Require bash
Set Shell "bash"
Set Width 1280
Set Height 640
Set FontSize 18
Set FontFamily "Moralerspace Neon HW"
Set Theme "TokyoNight"
Set Padding 24
Set WindowBar Colorful
Set Margin 12
Set MarginFill "#1a1b26"
Set BorderRadius 10
Set TypingSpeed 110ms
Set Framerate 30

Hide
Type "source ./fetch.sh"
Enter
Type "export PS1='n3dypop ~ ❯ '"
Enter
Type "clear"
Enter
Sleep 500ms
Show

Sleep 650ms
Type "fetch"
Sleep 350ms
Enter
Sleep 10s
