import Icons from '../common/icons.js';
import Status from '../common/status.js';

const battery = await Service.import('battery');
const available = battery.bind('available');
const charged = battery.bind('charged');
const charging = battery.bind('charging');
const percent = battery.bind('percent');
const time = battery.bind('time_remaining');

export default () =>
    Status({
        show: Utils.merge([available, charged], (a, c) => a && !c),
        icon: Utils.merge([charging, percent], (c, p) =>
            (c ? Icons.Battery.Charging : Icons.Battery.Draining)(p / 100),
        ),
        tooltip: Utils.merge(
            [percent, time],
            (p, t) =>
                `${p}% (${new Date(t * 1000).toISOString().substring(14, 19)})`,
        ),
    });
