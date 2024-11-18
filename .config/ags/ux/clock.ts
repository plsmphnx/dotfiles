import { bind, Variable } from 'astal';
import { Widget } from 'astal/gtk3';

import Toggle from '../lib/toggle.js';
import { Calendar } from '../lib/widgets.js';

function time() {
    return new Date().toLocaleString(undefined, {
        hour: '2-digit',
        minute: '2-digit',
    });
}

const date = Variable('');
setInterval(() => date.set(time()), 1000);

export default Toggle({
    name: 'clock',
    className: 'target',
    status: () => new Widget.Label({ label: bind(date) }),
    dropdown: reveal => {
        const child = new Calendar();
        bind(reveal).subscribe(r => {
            if (r) {
                const now = new Date();
                child.select_day(now.getDate());
                child.select_month(now.getMonth(), now.getFullYear());
            }
        });
        return new Widget.Box({ className: 'calendar', child });
    },
}).Button;
