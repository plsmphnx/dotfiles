import Toggle from '../lib/toggle.js';

function time() {
    return new Date().toLocaleString(undefined, {
        hour: '2-digit',
        minute: '2-digit',
    });
}

const date = Variable('', { poll: [1000, time] });

export default Toggle({
    name: 'clock',
    status: () =>
        Widget.Label({
            class_name: 'target',
            label: date.bind(),
        }),
    dropdown: reveal => {
        const child = Widget.Calendar();
        Utils.merge([reveal.bind()], r => {
            if (r) {
                const now = new Date();
                child.select_day(now.getDate());
                child.select_month(now.getMonth(), now.getFullYear());
            }
        });
        return Widget.Box({ class_name: 'calendar', child });
    },
}).Button;
