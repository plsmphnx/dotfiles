import type { Notification } from 'service/notifications';

const notifications = await Service.import('notifications');
const popups = notifications.bind('popups');
const all = notifications.bind('notifications');

const hyprland = await Service.import('hyprland');
const activeMonitorId = hyprland.active.monitor.bind('id');

notifications.popupTimeout = 5000;

const notificationIcon = ({ app_entry, app_icon, image }: Notification) => {
    if (image) {
        return Widget.Box({
            class_name: 'icon',
            css: `
                background-image: url("${image}");
                background-size: contain;
                background-repeat: no-repeat;
                background-position: center;
            `,
        });
    }

    if (Utils.lookUpIcon(app_icon)) {
        return Widget.Icon({ class_name: 'icon', icon: app_icon });
    }

    if (app_entry && Utils.lookUpIcon(app_entry)) {
        return Widget.Icon({ class_name: 'icon', icon: app_entry });
    }

    return undefined;
};

export const notificationPopup = (n: Notification) => {
    const icon = notificationIcon(n);

    const title = Widget.Label({
        class_name: 'title',
        label: n.summary,
        truncate: 'end',
        xalign: 0,
        use_markup: true,
    });

    const body = Widget.Label({
        class_name: 'body',
        label: n.body,
        wrap: true,
        xalign: 0,
        use_markup: true,
    });

    const actions = Widget.Box({
        children: n.actions.map(({ id, label }) =>
            Widget.Button({
                on_clicked: () => n.invoke(id),
                hexpand: true,
                child: Widget.Label(label),
            }),
        ),
    });

    const text = Widget.Box({
        class_name: 'text',
        vertical: true,
        children: [title, body],
    });
    const info = Widget.Box({ children: icon ? [icon, text] : [text] });

    if (actions.children.length > 0) {
        info.toggleClassName('active');
    }

    return Widget.EventBox({
        on_primary_click: () => n.close(),
        child: Widget.Box({
            class_name: `notification ${n.urgency}`,
            vertical: true,
            children: actions.children.length > 0 ? [info, actions] : [info],
        }),
    });
};

export const Dropdown = Variable(false);
const list = Utils.merge([popups, all, Dropdown.bind()], (ps, ns, dd) =>
    dd ? ns : ps,
);

export default (monitor: number) => {
    const children = Utils.merge([list, activeMonitorId], (vs, id) =>
        id === monitor ? vs.map(notificationPopup) : [],
    );
    return Widget.Window({
        name: `notifications-${monitor}`,
        monitor,
        anchor: ['top', 'right'],
        child: Widget.Box(
            { css: 'padding: 1px;' },
            Widget.Revealer({
                transition: 'slide_down',
                transition_duration: 1000,
                child: Widget.Box({ vertical: true, children }),
                reveal_child: children.as(c => c.length > 0),
            }),
        ),
    });
};
