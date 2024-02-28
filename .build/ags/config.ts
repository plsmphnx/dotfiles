import Bar from './bar/index.js';
import Notifications from './notifications/index.js';

const hyprland = await Service.import('hyprland');

export default {
    style: './style.css',
    windows: [
        ...hyprland.monitors.map(m => Bar(m.id)),
        ...hyprland.monitors.map(m => Notifications(m.id)),
    ],
};
