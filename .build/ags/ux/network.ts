import Icons from '../lib/icons.js';

const network = await Service.import('network');

export default () =>
    Widget.Button({
        on_primary_click: () => Utils.execAsync('iwgtk'),
        on_secondary_click: () => Utils.execAsync('nm-connection-editor'),
        child: Widget.Label().hook(network, self => {
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
