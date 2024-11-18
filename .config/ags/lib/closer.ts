import { type Binding } from 'astal';
import { Astal, Widget } from 'astal/gtk3';

import Persist from './persist.js';

export interface Props {
    name: string;
    monitor?: Widget.WindowProps['monitor'];
    reveal: Binding<boolean>;
    close: () => any;
}

export default ({ name, reveal, monitor, close }: Props) => {
    return Persist(() => {
        const closer = new Widget.Window({
            name: `${name}-closer`,
            monitor,
            anchor:
                Astal.WindowAnchor.TOP |
                Astal.WindowAnchor.RIGHT |
                Astal.WindowAnchor.LEFT |
                Astal.WindowAnchor.BOTTOM,
            keymode: Astal.Keymode.NONE,
            child: new Widget.EventBox({
                hexpand: true,
                vexpand: true,
                visible_window: false,
                on_primary_click: () => (close(), false),
                on_middle_click: () => (close(), false),
                on_secondary_click: () => (close(), false),
            }),
            visible: reveal,
        });
        closer.set_keep_above(true);
        return closer;
    });
};
