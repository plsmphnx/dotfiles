import type { Binding } from 'service';
import Dropdown, { Props as DropdownProps } from './dropdown.js';
import Status, { Props as StatusProps } from './status.js';

export interface Props extends StatusProps, Omit<DropdownProps, 'show'> {
    open?: Binding<any, any, string> | string;
}

function merge(
    drop: Binding<any, any, boolean>,
    icon: Binding<any, any, string> | string,
    open?: Binding<any, any, string> | string,
) {
    if (!open) {
        return icon;
    }
    if (typeof icon !== 'string') {
        if (typeof open !== 'string') {
            return Utils.merge([drop, icon, open], (d, i, o) => (d ? o : i));
        }
        return Utils.merge([drop, icon], (d, i) => (d ? open : i));
    }
    if (typeof open !== 'string') {
        return Utils.merge([drop, open], (d, o) => (d ? o : icon));
    }
    return drop.as(d => (d ? open : icon));
}

export default ({ show, icon, open, ...rest }: Props) => {
    const drop = Variable(false);
    const bind = drop.bind();
    if (show) {
        Utils.merge([show], s => {
            if (!s) {
                drop.value = false;
            }
        });
    }
    return {
        Window: Dropdown({ ...rest, show: bind }),
        Status: () =>
            Status({
                ...rest,
                on_clicked: () => (drop.value = !drop.value),
                icon: merge(bind, icon, open),
                show: show && Utils.merge([show, bind], (s, d) => s || d),
            }),
    };
};
