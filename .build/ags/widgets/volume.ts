import Icons from '../lib/icons.js';

const audio = await Service.import('audio');

export default () =>
    Widget.Button({
        on_clicked: () => Utils.execAsync('pavucontrol'),
        child: Widget.Label().hook(audio.speaker, self => {
            self.label =
                audio.speaker.is_muted || audio.speaker.volume === 0
                    ? Icons.Audio.Speaker.Off
                    : Icons.Audio.Speaker.On(audio.speaker.volume);
        }),
    });
