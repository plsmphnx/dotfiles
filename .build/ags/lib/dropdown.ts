import type { Binding } from 'service';
import type { RevealerProps } from 'widgets/revealer';

const hyprland = await Service.import('hyprland');
const activeMonitor = Utils.merge(
    [hyprland.active.monitor.bind('name'), hyprland.bind('monitors')],
    (name, monitors) => monitors.findIndex(m => name === m.name),
);

export interface Props {
    name: string;
    reveal: Binding<any, any, boolean>;
    child: RevealerProps['child'];
}

export default ({ name, reveal, child }: Props) =>
    Widget.Window({
        name,
        monitor: activeMonitor,
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
