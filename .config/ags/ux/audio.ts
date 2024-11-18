import { bind, type Binding, execAsync } from 'astal';
import { Widget } from 'astal/gtk3';

import Icons from '../lib/icons.js';
import { wp, Wp } from '../lib/services.js'
import Status from '../lib/status.js';

const status = (
    icons: { Off: string; On: (volume: number) => string },
    stream: Wp.Endpoint,
    clients?: Binding<Wp.Endpoint[]>,
) =>
    Status({
        on_clicked: () => execAsync('pavucontrol'),
        child: new Widget.Label().hook(stream, self => {
            self.label =
                stream.stream?.is_muted || stream.volume === 0
                    ? icons.Off
                    : icons.On(stream.volume);
        }),
        reveal: clients?.as(c => c.length > 0),
    });

export default () => [
    status(Icons.Speaker, wp.audio.default_speaker),
    status(
        Icons.Microphone,
        wp.audio.default_microphone,
        bind(wp.audio, 'recorders'),
    ),
];
