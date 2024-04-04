import Audio from './audio.js';
import Bluetooth from './bluetooth.js';
import Clock from './clock.js';
import Mpris from './mpris.js';
import Network from './network.js';
import Notifications from './notifications.js';
import Power from './power.js';
import Title from './title.js';
import Tray from './tray.js';
import Workspaces from './workspaces.js';

import Icons from '../lib/icons.js';

const hyprland = await Service.import('hyprland');
const monitors = hyprland.bind('monitors');

const status = () =>
    Widget.Box(
        { class_name: 'status' },
        Widget.Label({ class_name: 'hidden', label: Icons.Space }),
        Tray(),
        Mpris(),
        ...Audio(),
        Bluetooth(),
        Network(),
        Notifications(),
    );

const left = (monitor: string) =>
    Widget.Box({ hpack: 'start' }, Workspaces(monitor));

const center = (monitor: string) =>
    Widget.Box({ hpack: 'center' }, Title(monitor));

const right = (monitor: string) =>
    Widget.Box({ hpack: 'end' }, status(), Clock(), Power());

const bar = (monitor: string) =>
    Widget.Window({
        name: `bar-${monitor}`,
        monitor: monitors.as(ms => ms.findIndex(m => monitor === m.name)),
        anchor: ['top', 'left', 'right'],
        exclusivity: 'exclusive',
        child: Widget.CenterBox({
            class_name: 'bar',
            start_widget: left(monitor),
            center_widget: center(monitor),
            end_widget: right(monitor),
        }),
    });

hyprland.connect('monitor-added', (_, name) => App.addWindow(bar(name)));
hyprland.connect('monitor-removed', (_, name) =>
    App.removeWindow(`bar-${name}`),
);

export default () => hyprland.monitors.map(m => bar(m.name));
