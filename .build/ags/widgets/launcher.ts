import type { Application } from 'service/applications';
import type { BoxProps } from 'widgets/box';
import type { Button } from 'widgets/button';

import Closer from '../lib/closer.js';
import Icons from '../lib/icons.js';
import { scrollIntoView } from '../lib/util.js';

const { query } = await Service.import('applications');

const WINDOW_NAME = 'launcher';

const item = (app: Application) => {
    const list = app.app.list_actions();
    const show = list.length > 0 ? Variable(false) : undefined;

    const info = [
        Widget.Icon({
            class_name: 'icon',
            icon: app.icon_name || '',
        }),
        Widget.Label({
            label: app.name,
            xalign: 0,
            vpack: 'center',
            truncate: 'end',
        }),
    ];
    if (show) {
        info.push(
            Widget.Label({
                class_name: 'actions',
                label: show
                    .bind()
                    .as(s => (s ? Icons.Launcher.Less : Icons.Launcher.More)),
                xalign: 0,
                vpack: 'center',
            }),
        );
    }

    const launch = () => {
        App.closeWindow(WINDOW_NAME);
        app.launch();
    };
    const hover = (self: Button<any, any>) =>
        !entry.is_focus && self.grab_focus();
    const primary = Widget.Button({
        on_primary_click: launch,
        on_hover: hover,
        child: Widget.Box({ children: info }),
    });
    primary.keybind('Return', launch);
    primary.on('focus-in-event', focus);
    const children: BoxProps['children'] = [primary];

    if (show) {
        const open = () => (primary.grab_focus(), (show.value = true));
        const close = () => (primary.grab_focus(), (show.value = false));
        const toggle = () => (primary.grab_focus(), (show.value = !show.value));

        primary.keybind('Right', open);
        primary.keybind('Left', close);
        primary.on_secondary_click = toggle;

        const actions = list.map(a => {
            const action = () => {
                App.closeWindow(WINDOW_NAME);
                app.app.launch_action(a, null);
            };
            const secondary = Widget.Button({
                on_primary_click: action,
                on_secondary_click: close,
                on_hover: hover,
                child: Widget.Label({
                    label: app.app.get_action_name(a) || a,
                    xalign: 0,
                    vpack: 'center',
                    truncate: 'end',
                }),
            });
            secondary.keybind('Return', action);
            secondary.keybind('Left', close);
            secondary.on('focus-in-event', focus);
            return secondary;
        });

        children.push(
            Widget.Revealer({
                transition: 'slide_down',
                reveal_child: show.bind(),
                child: Widget.Box({ vertical: true, children: actions }),
            }),
        );
    }

    return Widget.Box({
        vertical: true,
        children,
    }).bind('visible', entry, 'text', txt => app.match(txt || ''));
};

function sort(a: Application, b: Application) {
    return b.frequency - a.frequency || a.name.localeCompare(b.name);
}

const entry = Widget.Entry({
    hexpand: true,
    on_accept: self => {
        const app = query(self.text || '')[0];
        if (app) {
            App.closeWindow(WINDOW_NAME);
            app.launch();
        }
    },
});

const apps = Variable<Application[]>([]);

const scroll = Widget.Scrollable({
    hscroll: 'never',
    vscroll: 'external',
    child: Widget.Box({
        vertical: true,
        children: apps.bind().as(a => a.sort(sort).map(item)),
    }),
});
const focus = scrollIntoView.bind(scroll);

const visible = Variable(false);

const launcher = Widget.Box({
    class_name: 'launcher',
    vertical: true,
    children: [entry, scroll],
}).hook(App, (_, name, v) => {
    if (name !== WINDOW_NAME) return;

    visible.value = v;
    if (v) {
        scroll.set_vadjustment(null);
        apps.value = query('');
        entry.text = '';
        entry.grab_focus();
    }
});

Closer({
    name: `${WINDOW_NAME}-closer`,
    reveal: visible.bind(),
    close: () => App.closeWindow(WINDOW_NAME),
});

export default Widget.Window({
    name: WINDOW_NAME,
    visible: false,
    keymode: 'exclusive',
    layer: 'overlay',
    child: launcher,
}).keybind('Escape', () => App.closeWindow(WINDOW_NAME));
