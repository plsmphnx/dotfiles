import { bind } from 'astal';
import { Widget } from 'astal/gtk3';

import { tray } from '../lib/services';

export default () =>
    new Widget.Box({
        children: bind(tray, 'items').as(items =>
            items.map(item =>
                new Widget.Button({
                    child: new Widget.Icon({ icon: bind(item, 'icon_name') }),
                    on_primary_click: (_, event) => item.activate(event),
                    on_secondary_click: (_, event) => item.openMenu(event),
                    tooltip_markup: bind(item, 'tooltip_markup'),
                }),
            ),
        ),
    });
