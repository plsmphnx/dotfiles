import Icons from '../lib/icons.js';

const bluetooth = await Service.import('bluetooth');
const enabled = bluetooth.bind('enabled');
const connected = bluetooth.bind('connected_devices');

export default () =>
    Widget.Button({
        on_clicked: () => Utils.execAsync('blueberry'),
        child: Widget.Label({
            label: Utils.merge([enabled, connected], (e, c) =>
                e
                    ? c.length > 0
                        ? Icons.Bluetooth.Connected
                        : Icons.Bluetooth.On
                    : Icons.Bluetooth.Off,
            ),
        }),
    });
