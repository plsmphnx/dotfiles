function select(...icons: string[]) {
    return (value: number) => {
        const index = Math.floor(value * icons.length);
        return icons[Math.max(0, Math.min(index, icons.length - 1))];
    };
}

export default {
    Workspaces: {
        Fallback: '\u{0f2d0}',
    },

    Battery: {
        Draining: select(
            '\u{f008e}',
            '\u{f007a}',
            '\u{f007b}',
            '\u{f007c}',
            '\u{f007d}',
            '\u{f007e}',
            '\u{f007f}',
            '\u{f0080}',
            '\u{f0081}',
            '\u{f0082}',
            '\u{f0079}',
        ),
        Charging: select(
            '\u{f089f}',
            '\u{f089c}',
            '\u{f0086}',
            '\u{f0087}',
            '\u{f0088}',
            '\u{f089d}',
            '\u{f0089}',
            '\u{f089e}',
            '\u{f008a}',
            '\u{f008b}',
            '\u{f0085}',
        ),
    },

    Audio: {
        Speaker: {
            Off: '\u{f0581}',
            On: select('\u{f057f}', '\u{f0580}', '\u{f057e}'),
        },
        Microphone: {
            Off: '\u{f036d}',
            On: select('\u{f036c}'),
        },
    },

    Network: {
        Off: '\u{f0164}',
        Wired: '\u{f0200}',
        Wifi: {
            Off: '\u{f092d}',
            On: select(
                '\u{f092f}',
                '\u{f091f}',
                '\u{f0922}',
                '\u{f0925}',
                '\u{f0928}',
            ),
        },
    },

    Title: {
        Exit: '\xd7',
        Size: '\x2b',
    },

    Notifications: {
        Icon: '\u{f035c}',
        Open: '\u{f039f}',
    },

    Mpris: {
        Icon: '\u{f075a}',
        Play: '\u{f040a}',
        Pause: '\u{f03e4}',
        Prev: '\u{f04ae}',
        Next: '\u{f04ad}',
        Paused: '\u{f075b}',
    },

    Power: {
        Icon: '\u{f0425}',
        Shutdown: '\u{f0425}',
        Restart: '\u{f0709}',
        Logout: '\u{f05fd}',
        Sleep: '\u{f0904}',
        Lock: '\u{f033e}',
    },

    Launcher: {
        More: '\u{f035c}',
        Less: '\u{f039f}',
    },
};
