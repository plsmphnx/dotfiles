function time() {
    return new Date().toLocaleString(undefined, {
        hour: '2-digit',
        minute: '2-digit',
    });
}

const date = Variable('', { poll: [1000, time] });

export default () =>
    Widget.Label({
        class_name: 'clock',
        label: date.bind(),
    });
