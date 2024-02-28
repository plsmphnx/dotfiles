import type { Notification } from 'service/notifications';

const notifications = await Service.import('notifications');
const popups = notifications.bind('popups');

const NotificationIcon = ({ app_entry, app_icon, image }: Notification) => {
    if (image) {
        return Widget.Box({
            css: `
                background-image: url("${image}");
                background-size: contain;
                background-repeat: no-repeat;
                background-position: center;
            `,
        });
    }

    let icon = 'dialog-information-symbolic';
    if (Utils.lookUpIcon(app_icon)) icon = app_icon;

    if (app_entry && Utils.lookUpIcon(app_entry)) icon = app_entry;

    return Widget.Icon(icon);
};

export const NotificationBox = (n: Notification) => {
    const icon = NotificationIcon(n);

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

    return Widget.EventBox({
        on_primary_click: () => n.dismiss(),
        child: Widget.Box(
            {
                class_name: `notification ${n.urgency}`,
                vertical: true,
            },
            Widget.Box(
                { class_name: 'info' },
                icon,
                Widget.Box({ vertical: true }, title, body),
            ),
            actions,
        ),
    });
};

export default () =>
    Widget.Window({
        name: 'notifications',
        anchor: ['top', 'right'],
        child: Widget.Box({
            vertical: true,
            css: 'padding: 1px;',
            children: popups.as(popups => popups.map(NotificationBox)),
        }),
    });
