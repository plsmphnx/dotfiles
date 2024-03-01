import type { Binding } from 'service';
import Dropdown from './dropdown.js';
import Status from './status.js';

export default ({
    name,
    show,
    child,
    icon,
    open,
}: {
    name: string;
    show?: Binding<any, any, boolean>;
    child: any;
    icon: string;
    open?: string;
}) => {
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
        Window: Dropdown({ name, show: bind, child }),
        Status: () =>
            Status({
                on_clicked: () => (drop.value = !drop.value),
                icon: open ? bind.as(d => (d ? open : icon)) : icon,
                show: show && Utils.merge([show, bind], (s, d) => s || d),
            }),
    };
};
