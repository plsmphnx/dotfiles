import Astal from 'gi://Astal';
import Gtk from 'gi://Gtk'
import type { Binding } from 'astal';
import { Widget } from 'astal/gtk3';

import Persist from './persist.js';

export interface Props {
    name: string;
    monitor?: Widget.WindowProps['monitor'];
    reveal: Binding<boolean>;
    child: () => Widget.RevealerProps['child'];
}

export default ({ name, reveal, monitor, child }: Props) => {
    return Persist(() =>
        new Widget.Window({
            name: `${name}-dropdown`,
            monitor,
            anchor: Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT,
            layer: Astal.Layer.OVERLAY,
            child: new Widget.Box(
                { css: 'padding: 1px' },
                new Widget.Revealer({
                    transition_type: Gtk.RevealerTransitionType.SLIDE_DOWN,
                    transition_duration: 1000,
                    child: child(),
                    reveal_child: reveal,
                }),
            ),
        }),
    );
};
