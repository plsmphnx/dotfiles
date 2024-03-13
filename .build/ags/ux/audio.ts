import type { Binding } from 'service';
import type { Stream } from 'service/audio';

import Icons from '../lib/icons.js';
import Status from '../lib/status.js';

const audio = await Service.import('audio');

const status = (
    icons: { Off: string; On: (volume: number) => string },
    stream: Stream,
    clients?: Binding<any, any, Stream[]>,
) =>
    Status({
        on_clicked: () => Utils.execAsync('pavucontrol'),
        child: Widget.Label().hook(stream, self => {
            self.label =
                stream.stream?.is_muted || stream.volume === 0
                    ? icons.Off
                    : icons.On(stream.volume);
        }),
        reveal: clients?.as(c => c.length > 0),
    });

export default () => [
    status(Icons.Speaker, audio.speaker),
    status(Icons.Microphone, audio.microphone, audio.bind('recorders')),
];
