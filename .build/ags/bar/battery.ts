import Icons from '../common/icons.js';

const battery = await Service.import('battery');

export default () =>
    Widget.Label().hook(battery, self => {
        self.visible = battery.available && !battery.charged;

        self.label = (
            battery.charging ? Icons.Battery.Charging : Icons.Battery.Draining
        )(battery.percent / 100);

        const time = new Date(battery.time_remaining * 1000)
            .toISOString()
            .substring(14, 19);
        self.tooltip_text = `${battery.percent}% (${time})`;
    });
