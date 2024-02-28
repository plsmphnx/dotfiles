import Icons from '../icons.js';

const hyprland = await Service.import('hyprland');

const activeClientMonitor = Utils.merge(
    [hyprland.active.client.bind('address'), hyprland.bind('clients')],
    (a, cs) => cs.find(c => c.address === a)?.monitor ?? -1,
);

export default (monitor: number) =>
    Widget.Box(
        { visible: activeClientMonitor.as(id => id === monitor) },
        Widget.Button({
            class_name: 'status',
            on_primary_click: () =>
                hyprland.messageAsync('dispatch movetoworkspace empty'),
            on_secondary_click: () =>
                hyprland.messageAsync('dispatch togglefloating'),
            child: Widget.Label({ class_name: 'dim', label: Icons.Title.Size }),
        }),
        Widget.Label({
            class_name: 'icars',
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
