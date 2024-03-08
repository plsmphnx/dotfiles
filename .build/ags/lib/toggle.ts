import Closer from './closer.js';
import Dropdown, { Props as DropdownProps } from './dropdown.js';
import Reset from './reset.js';
import Status, { Props as StatusProps } from './status.js';

const hyprland = await Service.import('hyprland');
export const activeMonitor = Utils.merge(
    [hyprland.active.monitor.bind('name'), hyprland.bind('monitors')],
    (name, monitors) => monitors.findIndex(m => name === m.name),
);

export interface Props
    extends Omit<StatusProps, 'name' | 'child'>,
        Omit<DropdownProps, 'reveal' | 'child'> {
    status: () => StatusProps['child'];
    dropdown: DropdownProps['child'];
}

export default ({ name, reveal, status, dropdown, ...rest }: Props) => {
    const Reveal = Reset(reveal);
    const window = { name, monitor: activeMonitor, reveal: Reveal.bind() };
    return {
        Reveal,
        Button: () =>
            Status({
                ...rest,
                on_clicked: () => (Reveal.value = !Reveal.value),
                child: status(),
                reveal,
            }),
        Window: Dropdown({ ...window, child: dropdown }),
        Closer: Closer({ ...window, close: () => (Reveal.value = false) }),
        Monitor: activeMonitor,
    };
};
