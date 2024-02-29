import Icons from '../icons.js';
import { Dropdown } from '../notifications/index.js';

const notifications = await Service.import('notifications');
const drop = Dropdown.bind();
const show = Utils.merge(
    [notifications.bind('notifications').as(ns => ns.length > 0), drop],
    (s, d) => s || d,
);

export default () =>
    Widget.Button({
        on_clicked: () => (Dropdown.value = !Dropdown.value),
        child: Widget.Label({
            label: drop.as(d =>
                d ? Icons.Notifications.Open : Icons.Notifications.Closed,
            ),
        }),
        visible: show,
    });
