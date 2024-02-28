const hyprland = await Service.import('hyprland');

export default () =>
    Widget.Label({ class_name: 'dim status' }).hook(
        hyprland,
        (self, submap) => (self.label = submap || ''),
        'submap',
    );
