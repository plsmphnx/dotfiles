import type { Binding } from 'service';
import type { RevealerProps } from 'widgets/revealer';
import type { WindowProps } from 'widgets/window';

export interface Props {
    name: string;
    monitor?: WindowProps['monitor'];
    reveal: Binding<any, any, boolean>;
    child: RevealerProps['child'];
}

export default ({ name, reveal, monitor, child }: Props) =>
    Widget.Window({
        name: `${name}-dropdown`,
        monitor,
        anchor: ['top', 'right'],
        layer: 'overlay',
        child: Widget.Box(
            { css: 'padding: 1px' },
            Widget.Revealer({
                transition: 'slide_down',
                transition_duration: 1000,
                child,
                reveal_child: reveal,
            }),
        ),
    });
