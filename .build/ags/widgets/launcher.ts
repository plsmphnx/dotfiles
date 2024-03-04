import type { Application } from 'service/applications';

const applications = await Service.import('applications');
const list = applications.bind('list');

const WINDOW_NAME = 'launcher';

const item = (app: Application) =>
    Widget.Button({
        on_clicked: () => {
            App.closeWindow(WINDOW_NAME);
            app.launch();
        },
        child: Widget.Box({
            children: [
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
            ],
        }),
    }).bind('visible', entry, 'text', txt => app.match(txt || ''));

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
