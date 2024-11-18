import { bind, Variable } from 'astal';

import Closer from './closer.js';
import Dropdown, { Props as DropdownProps } from './dropdown.js';
import Reset from './reset.js';
import { hyprland } from './services.js';
import Status, { Props as StatusProps } from './status.js';

export const focusedMonitor = bind(Variable.derive(
    [bind(hyprland.focused_monitor, 'name'), bind(hyprland, 'monitors')],
    (name, monitors) => monitors.findIndex(m => name === m.name),
))

export interface Props
    extends Omit<StatusProps, 'name' | 'child'>,
        Omit<DropdownProps, 'reveal' | 'child'> {
    status: (reveal: Variable<boolean>) => StatusProps['child'];
    dropdown: (reveal: Variable<boolean>) => ReturnType<DropdownProps['child']>;
}

export default ({ name, reveal, status, dropdown, ...rest }: Props) => {
    const Reveal = Reset(reveal);
    const window = { name, monitor: focusedMonitor, reveal: bind(Reveal) };
    return {
        Reveal,
        Button: () =>
            Status({
                ...rest,
                on_clicked: () => Reveal.set(!Reveal.get()),
                child: status(Reveal),
                reveal,
            }),
        Window: Dropdown({ ...window, child: () => dropdown(Reveal) }),
        Closer: Closer({ ...window, close: () => Reveal.set(false) }),
        Monitor: focusedMonitor,
    };
};
