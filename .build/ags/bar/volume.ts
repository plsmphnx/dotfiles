const audio = await Service.import('audio');

export default () =>
    Widget.Button({
        class_name: 'volume',
        on_clicked: () => Utils.execAsync('pavucontrol'),
        child: Widget.Icon().hook(audio.speaker, self => {
            const category: { [threshold: number]: string } = {
                101: 'overamplified',
                67: 'high',
                34: 'medium',
                1: 'low',
                0: 'muted',
            };

            const icon = audio.speaker.is_muted
                ? 0
                : [101, 67, 34, 1, 0].find(
                      threshold => threshold <= audio.speaker.volume * 100,
                  )!;

            self.icon = `audio-volume-${category[icon]}-symbolic`;
        }),
    });
