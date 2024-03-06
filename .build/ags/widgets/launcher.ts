import type { Application } from 'service/applications';
import type { BoxProps } from 'widgets/box';
import Icons from '../lib/icons.js';

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

    const primary = Widget.Button({
        on_primary_click: () => {
            App.closeWindow(WINDOW_NAME);
            app.launch();
        },
        child: Widget.Box({ children: info }),
    });
    const children: BoxProps['children'] = [primary];

    if (show) {
        primary.on_secondary_click = () => (show.value = !show.value);
        const actions = list.map(a =>
            Widget.Button({
                on_primary_click: () => {
                    App.closeWindow(WINDOW_NAME);
                    app.app.launch_action(a, null);
                },
                on_secondary_click: () => (show.value = !show.value),
                child: Widget.Label({
                    label: app.app.get_action_name(a) || a,
                    xalign: 0,
                    vpack: 'center',
                    truncate: 'end',
                }),
            }),
        );
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
    child: Widget.Box({
        vertical: true,
        children: apps.bind().as(a => a.sort(sort).map(item)),
    }),
});

const launcher = Widget.Box({
    class_name: 'launcher',
    vertical: true,
    children: [entry, scroll],
    setup: self =>
        self.hook(App, (_, name, visible) => {
            if (name === WINDOW_NAME && visible) {
                scroll.set_vadjustment(null);
                apps.value = query('');
                entry.text = '';
                entry.grab_focus();
            }
        }),
});

export default Widget.Window({
    name: WINDOW_NAME,
    setup: self => self.keybind('Escape', () => App.closeWindow(WINDOW_NAME)),
    visible: false,
    keymode: 'exclusive',
    child: launcher,
});
