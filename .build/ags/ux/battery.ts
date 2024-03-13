import Icons from '../lib/icons.js';
import Status from '../lib/status.js';

const battery = await Service.import('battery');
const available = battery.bind('available');
const charged = battery.bind('charged');
const charging = battery.bind('charging');
const percent = battery.bind('percent');
const time = battery.bind('time_remaining');

const label = Utils.merge([charging, percent], (c, p) =>
    (c ? Icons.Battery.Charging : Icons.Battery.Draining)(p / 100),
);
const tooltip_text = Utils.merge(
    [percent, time],
    (p, t) => `${p}% (${new Date(t * 1000).toISOString().substring(14, 19)})`,
);
const reveal = Utils.merge([available, charged], (a, c) => a && !c);

export default () =>
    Status({ child: Widget.Label({ label, tooltip_text }), reveal });
