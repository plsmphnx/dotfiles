import Battery from './battery.js';
import Clock from './clock.js';
import Network from './network.js';
import Notifications from './notifications.js';
import Submap from './submap.js';
import SysTray from './systray.js';
import Title from './title.js';
import Volume from './volume.js';
import Workspaces from './workspaces.js';

const Status = () =>
    Widget.Box(
        { class_name: 'status' },
        SysTray(),
        Volume(),
        Network(),
        Battery(),
        Notifications(),
    );

const Left = (monitor: number) =>
    Widget.Box({ hpack: 'start' }, Workspaces(monitor), Submap());

const Center = (monitor: number) =>
    Widget.Box({ hpack: 'center' }, Title(monitor));

const Right = (monitor: number) =>
    Widget.Box({ hpack: 'end' }, Status(), Clock());

export default (monitor: number) =>
    Widget.Window({
        name: `bar-${monitor}`,
        monitor,
        anchor: ['top', 'left', 'right'],
        margins: [0, 0, 2, 0],
        exclusivity: 'exclusive',
        child: Widget.CenterBox({
            start_widget: Left(monitor),
            center_widget: Center(monitor),
            end_widget: Right(monitor),
        }),
    });
