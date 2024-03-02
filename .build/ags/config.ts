import Bar from './widgets/bar.js';

const hyprland = await Service.import('hyprland');

export default {
    style: './style.css',
    windows: hyprland.monitors.map(m => Bar(m.id)),
};
