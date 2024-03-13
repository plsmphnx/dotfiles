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
    dropdown: () =>
        Widget.Box({
            class_name: 'calendar',
            child: Widget.Calendar(),
        }),
}).Button;
