1i\
serial --unit=0 --speed=115200\
terminal_input console serial\
terminal_output console serial

s/^set timeout=.*/set timeout=0/

/^[[:space:]]*linux/ s|---| autoinstall console=tty0 console=ttyS0,115200n8 ---|
