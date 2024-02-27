import Icons from '../icons.js';

const battery = await Service.import('battery');

export default () =>
    Widget.Label({ class_name: 'battery' }).hook(battery, self => {
        self.visible = battery.available && !battery.charged;

        self.label = Icons.select(
            battery.charging ? Icons.Battery.Charging : Icons.Battery.Draining,
            battery.percent / 100,
        );

        const time = new Date(battery.time_remaining * 1000)
            .toISOString()
            .substring(14, 19);
        self.tooltip_text = `${battery.percent}% ${
            battery.charging ? Icons.Battery.Tooltip : ''
        }(${time})`;
    });
