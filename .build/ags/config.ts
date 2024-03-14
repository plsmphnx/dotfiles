import Bar from './ux/bar.js';
import Launcher from './ux/launcher.js';

App.config({
    style: './style.css',
    windows: [...Bar(), Launcher],
});
