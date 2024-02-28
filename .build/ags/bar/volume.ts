import Icons from '../icons.js';

const audio = await Service.import('audio');

export default () =>
    Widget.Button({
        on_clicked: () => Utils.execAsync('pavucontrol'),
        child: Widget.Label().hook(audio.speaker, self => {
            self.label =
                audio.speaker.is_muted || audio.speaker.volume === 0
                    ? Icons.Volume.Speaker.Off
                    : Icons.select(
                          Icons.Volume.Speaker.On,
                          audio.speaker.volume,
                      );
        }),
    });
