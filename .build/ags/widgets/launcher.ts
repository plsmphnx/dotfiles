import type { Application } from 'service/applications';
import type { BoxProps } from 'widgets/box';

const applications = await Service.import('applications');
const list = applications.bind('list');

const WINDOW_NAME = 'launcher';

const item = (app: Application) => {
    const show = Variable(false);
    const list = app.app.list_actions();

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
    if (list.length > 0) {
        info.push(
            Widget.Label({
                class_name: 'dim',
                label: ' +',
                xalign: 0,
                vpack: 'center',
            }),
        );
    }

    const children: BoxProps['children'] = [
        Widget.Button({
            on_primary_click: () => {
                App.closeWindow(WINDOW_NAME);
                app.launch();
            },
            on_secondary_click: () => (show.value = !show.value),
            child: Widget.Box({ children: info }),
        }),
    ];

    if (list.length > 0) {
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

const entry = Widget.Entry({
    hexpand: true,
    on_accept: self => {
        const app = applications.query(self.text || '')[0];
        if (app) {
            App.closeWindow(WINDOW_NAME);
            app.launch();
        }
    },
});

const launcher = Widget.Box({
    class_name: 'launcher',
    vertical: true,
    children: [
        entry,
        Widget.Scrollable({
            hscroll: 'never',
            child: Widget.Box({
                vertical: true,
                children: list.as(apps => apps.map(item)),
            }),
        }),
    ],
    setup: self =>
        self.hook(App, (_, windowName, visible) => {
            if (windowName === WINDOW_NAME && visible) {
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
