const hyprland = await Service.import('hyprland');

export default () =>
    Widget.Label({
        class_name: 'title',
        label: hyprland.active.client.bind('title'),
        max_width_chars: 64,
        truncate: 'end',
    });
