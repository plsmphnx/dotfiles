import Bar from './widgets/bar.js';
import Launcher from './widgets/launcher.js';

const hyprland = await Service.import('hyprland');

App.config({
    style: './style.css',
    windows: [...hyprland.monitors.map(m => Bar(m.id)), Launcher],
});
