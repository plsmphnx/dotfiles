import { bind, execAsync, Variable } from 'astal';
import { Widget } from 'astal/gtk3';

import Icons from '../lib/icons.js';
import { bluetooth } from '../lib/services.js';

const powered = bind(bluetooth, 'is_powered');
const connected = bind(bluetooth, 'is_connected');

export default () =>
    new Widget.Button({
        on_clicked: () => execAsync('blueberry'),
        child: new Widget.Label({
            label: bind(
                Variable.derive([powered, connected], (p, c) =>
                    p
                        ? c
                            ? Icons.Bluetooth.Connected
                            : Icons.Bluetooth.On
                        : Icons.Bluetooth.Off,
                ),
            ),
        }),
    });
