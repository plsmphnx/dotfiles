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
    Widget.Box(
        { visible: activeClientMonitor.as(m => m === monitor) },
        Widget.Button({
            class_name: 'status',
            on_primary_click: () => Utils.execAsync('hyprnome -me'),
            on_secondary_click: () =>
                hyprland.messageAsync(
                    '[[BATCH]] dispatch togglefloating ; dispatch pin',
                ),
            child: Widget.Label({ class_name: 'dim', label: Icons.Title.Size }),
        }),
        Widget.Label({
            class_name: 'target',
            label: hyprland.active.client.bind('title'),
            max_width_chars: 64,
            truncate: 'end',
        }),
        Widget.Button({
            class_name: 'status',
            on_primary_click: () =>
                hyprland.messageAsync('dispatch killactive'),
            on_secondary_click: () =>
                hyprland.messageAsync(
                    'dispatch movetoworkspacesilent special:background',
                ),
            child: Widget.Label({ class_name: 'dim', label: Icons.Title.Exit }),
        }),
    );
