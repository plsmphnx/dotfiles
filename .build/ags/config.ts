import Bar from './widgets/bar.js';
import Launcher from './widgets/launcher.js';

App.config({
    style: './style.css',
    windows: [...Bar(), Launcher],
});
