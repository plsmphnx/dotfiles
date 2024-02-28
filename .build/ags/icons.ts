export default {
    select(icons: string[], value: number) {
        const index = Math.floor(value * icons.length);
        return icons[Math.max(0, Math.min(index, icons.length - 1))];
    },

    Client: {
        Fallback: '\u{0f2d0}',
    },

    Battery: {
        Draining: [
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
        ],
        Charging: [
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
        ],
        Tooltip: '\u{f140b}',
    },

    Volume: {
        Speaker: {
            Off: '\u{f0581}',
            On: ['\u{f057f}', '\u{f0580}', '\u{f057e}'],
        },
        Microphone: {
            Off: '\u{f036d}',
            On: ['\u{f036c}'],
        },
    },

    Network: {
        Ethernet: '\u{f0200}',
        Wifi: {
            Off: '\u{f092d}',
            On: [
                '\u{f092f}',
                '\u{f091f}',
                '\u{f0922}',
                '\u{f0925}',
                '\u{f0928}',
            ],
        },
    },
};
