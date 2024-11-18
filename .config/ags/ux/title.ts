import { bind, execAsync, Variable } from 'astal';
import { Widget } from 'astal/gtk3';

import { hyprland } from '../lib/services';

const focusedClientMonitor = bind(
    Variable.derive(
        [bind(hyprland.focused_client, 'address'), bind(hyprland, 'clients')],
        (address, clients) =>
            clients.find(c => c.address === address)?.monitor?.name,
    ),
);

export default (monitor: string) =>
    new Widget.Button({
        className: 'target',
        on_primary_click: () => execAsync('hyprnome -me'),
        on_secondary_click: () => hyprland.message_async('dispatch killactive'),
        visible: focusedClientMonitor.as(m => m === monitor),
        child: new Widget.Label({
            label: bind(hyprland.focused_client, 'title'),
            truncate: true,
        }),
    });
