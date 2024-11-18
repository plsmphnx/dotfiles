import { bind } from 'astal';
import { Astal, Widget } from 'astal/gtk3';

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
import { hyprland } from '../lib/services.js';

const monitors = bind(hyprland, 'monitors');

const status = () =>
    new Widget.Box(
        { className: 'status' },
        new Widget.Label({ className: 'hidden', label: Icons.Space }),
        Notifications(),
        Tray(),
        Mpris(),
        ...Audio(),
        Bluetooth(),
        Network(),
    );

const left = (monitor: string) =>
    new Widget.Box({ hpack: 'start' }, Workspaces(monitor));

const center = (monitor: string) =>
    new Widget.Box({ hpack: 'center' }, Title(monitor));

const right = (monitor: string) =>
    new Widget.Box({ hpack: 'end' }, status(), Clock(), Power());

const bar = (monitor: string) =>
    new Widget.Window({
        name: `bar-${monitor}`,
        monitor: monitors.as(ms => ms.findIndex(m => monitor === m.name)),
        anchor:
            Astal.WindowAnchor.TOP |
            Astal.WindowAnchor.RIGHT |
            Astal.WindowAnchor.LEFT,
        exclusivity: Astal.Exclusivity.EXCLUSIVE,
        child: new Widget.CenterBox({
            className: 'bar',
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
