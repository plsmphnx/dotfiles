import type { Binding } from 'service';
import type { WindowProps } from 'widgets/window';

export interface Props {
    name: string;
    monitor?: WindowProps['monitor'];
    reveal: Binding<any, any, boolean>;
    close: () => any;
}

export default ({ name, reveal, monitor, close }: Props) => {
    const closer = Widget.Window({
        name: `${name}-closer`,
        monitor,
        anchor: ['top', 'right', 'bottom', 'left'],
        keymode: 'none',
        child: Widget.EventBox({
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
};
