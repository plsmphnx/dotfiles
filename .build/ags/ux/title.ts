import Icons from '../lib/icons.js';

const hyprland = await Service.import('hyprland');

const activeClientMonitor = Utils.merge(
    [hyprland.active.client.bind('address'), hyprland.bind('clients')],
    (address, clients) =>
        hyprland.getMonitor(
            clients.find(c => c.address === address)?.monitor ?? -1,
        )?.name,
);

export default (monitor: string) =>
    Widget.Button({
        class_name: 'target',
        on_primary_click: () => Utils.execAsync('hyprnome -me'),
        on_secondary_click: () => hyprland.messageAsync('dispatch killactive'),
        visible: activeClientMonitor.as(m => m === monitor),
        child: Widget.Label({
            label: hyprland.active.client.bind('title'),
            max_width_chars: 64,
            truncate: 'end',
        }),
    });
