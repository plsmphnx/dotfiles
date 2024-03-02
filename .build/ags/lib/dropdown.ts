import type { Binding } from 'service';
import type { RevealerProps } from 'widgets/revealer';

const hyprland = await Service.import('hyprland');
const activeMonitorId = hyprland.active.monitor.bind('id');

export interface Props {
    name: string;
    reveal: Binding<any, any, boolean>;
    child: RevealerProps['child'];
}

export default ({ name, reveal, child }: Props) =>
    Widget.Window({
        name,
        monitor: activeMonitorId,
        anchor: ['top', 'right'],
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
