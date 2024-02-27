import Battery from './bar/battery.js';
import Clock from './bar/clock.js';
import SysTray from './bar/systray.js';
import Title from './bar/title.js';
import Volume from './bar/volume.js';
import Workspaces from './bar/workspaces.js';

const hyprland = await Service.import('hyprland');
const notifications = await Service.import('notifications');

// we don't need dunst or any other notification daemon
// because the Notifications module is a notification daemon itself
function Notification() {
    const popups = notifications.bind('popups');
    return Widget.Box({
        class_name: 'notification',
        visible: popups.as(p => p.length > 0),
        children: [
            Widget.Icon({
                icon: 'preferences-system-notifications-symbolic',
            }),
            Widget.Label({
                label: popups.as(p => p[0]?.summary || ''),
            }),
        ],
    });
}

const Left = (monitor: number) =>
    Widget.Box({
        hpack: 'start',
        children: [Workspaces(monitor)],
    });

const Center = (monitor: number) =>
    Widget.Box({
        hpack: 'center',
        children: [Title(), Notification()],
    });

const Right = (monitor: number) =>
    Widget.Box({
        hpack: 'end',
        children: [SysTray(), Volume(), Battery(), Clock()],
    });

const Bar = (monitor: number) =>
    Widget.Window({
        name: `bar-${monitor}`,
        class_name: 'bar',
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

export default {
    style: `${Utils.HOME}/.local/share/ux/style.css`,
    windows: hyprland.monitors.map(m => Bar(m.id)),
};
