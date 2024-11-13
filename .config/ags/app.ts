import { App } from "astal/gtk3"
import style from "./style.scss"
import Bar from './ux/bar.js';
import Launcher from './ux/launcher.js';

App.start({
    css: style,
    main() {
        App.get_monitors().map(Bar)
        App.add_window(Launcher)
    },
})
