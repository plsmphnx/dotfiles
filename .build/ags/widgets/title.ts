import Icons from '../lib/icons.js';

const hyprland = await Service.import('hyprland');

const activeClientMonitor = hyprland.active.client
    .bind('address')
    .as(a => hyprland.getMonitor(hyprland.getClient(a)?.monitor ?? -1)?.name);

export default (monitor: string) =>
    Widget.Box(
        { visible: activeClientMonitor.as(m => m === monitor) },
        Widget.Button({
            class_name: 'status',
            on_primary_click: () =>
                hyprland.messageAsync('dispatch movetoworkspace empty'),
            on_secondary_click: () =>
                hyprland.messageAsync('dispatch togglefloating'),
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
