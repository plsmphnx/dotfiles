import type { Notification } from 'service/notifications';
import type { Label } from 'widgets/label';
import Dropdown from '../common/dropdown.js';
import Icons from '../common/icons.js';
import Toggle from '../common/toggle.js';

const notifications = await Service.import('notifications');
const popups = notifications.bind('popups');
const all = notifications.bind('notifications');

notifications.popupTimeout = 5000;

function notificationIcon({ app_entry, app_icon, image }: Notification) {
    if (image) {
        return Widget.Box({
            class_name: 'icon',
            vpack: 'start',
            css: `background-image: url("${image}")`,
        });
    }

    if (Utils.lookUpIcon(app_icon)) {
        return Widget.Icon({
            class_name: 'icon',
            vpack: 'start',
            icon: app_icon,
        });
    }

    if (app_entry && Utils.lookUpIcon(app_entry)) {
        return Widget.Icon({
            class_name: 'icon',
            vpack: 'start',
            icon: app_entry,
        });
    }

    return undefined;
}

function markup(label: Label<any>, value: string) {
    if (/<a|&\w+;/.test(value)) {
        label.set_markup(value);
    } else {
        label.label = value;
    }
}

function notificationPopup(n: Notification) {
    const icon = notificationIcon(n);

    const title = Widget.Label({
        class_name: 'title',
        truncate: 'end',
        xalign: 0,
        use_markup: true,
    });
    markup(title, n.summary);

    const body = Widget.Label({
        wrap: true,
        xalign: 0,
        use_markup: true,
    });
    markup(body, n.body);

    const defaultAction = n.actions.find(({ id }) => id === 'default');
    const customActions = n.actions.filter(({ id }) => id !== 'default');

    const actions = Widget.Box({
        children: customActions.map(({ id, label }) =>
            Widget.Button({
                on_clicked: () => n.invoke(id),
                hexpand: true,
                child: Widget.Label(label),
            }),
        ),
    });

    const text = Widget.Box({ vertical: true, children: [title, body] });
    const info = Widget.Box({ children: icon ? [icon, text] : [text] });

    return Widget.EventBox({
        on_primary_click: () => defaultAction && n.invoke(defaultAction.id),
        on_secondary_click: () => n.close(),
        child: Widget.Box({
            class_name: `action ${n.urgency}`,
            vertical: true,
            children: customActions.length > 0 ? [info, actions] : [info],
        }),
    });
}

export default {
    Popups: Dropdown({
        name: 'notification-popups',
        show: popups.as(p => p.length > 0),
        child: Widget.Box({
            vertical: true,
            children: popups.as(p => p.map(notificationPopup)),
        }),
    }),

    All: Toggle({
        name: 'notifications',
        show: all.as(p => p.length > 0),
        child: Widget.Box({
            vertical: true,
            children: all.as(p => p.map(notificationPopup)),
        }),
        icon: Icons.Notifications.Icon,
        open: Icons.Notifications.Open,
    }),
};
