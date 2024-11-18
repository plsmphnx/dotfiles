import { execAsync } from 'astal';
import { Widget } from 'astal/gtk3';

import Icons from '../lib/icons.js';
import { network } from '../lib/services.js';

export default () =>
    new Widget.Button({
        on_primary_click: () => execAsync('iwgtk'),
        on_secondary_click: () => execAsync('nm-connection-editor'),
        child: new Widget.Label().hook(network, self => {
            switch (network.primary) {
                case 'wifi':
                    if (network.wifi.enabled) {
                        self.label = Icons.Network.Wifi.On(
                            network.wifi.strength / 100,
                        );
                    } else {
                        self.label = Icons.Network.Wifi.Off;
                    }
                    break;
                case 'wired':
                    self.label = Icons.Network.Wired;
                    break;
                default:
                    self.label = Icons.Network.Off;
                    break;
            }
        }),
    });
