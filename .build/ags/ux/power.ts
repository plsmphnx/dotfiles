import Icons from '../lib/icons.js';
import Toggle from '../lib/toggle.js';

const battery = await Service.import('battery');
const available = battery.bind('available');
const charged = battery.bind('charged');
const charging = battery.bind('charging');
const percent = battery.bind('percent');
const time = battery.bind('time_remaining');

const label = Utils.merge(
    [charging, percent, available, charged],
    (c, p, a, f) =>
        a && !f
            ? (c ? Icons.Power.Charging : Icons.Power.Draining)(p / 100)
            : Icons.Power.Icon,
);
const tooltip_text = Utils.merge(
    [percent, time],
    (p, t) => `${p}% (${new Date(t * 1000).toISOString().substring(14, 19)})`,
);

const COMMANDS = {
    Shutdown: 'systemctl poweroff',
    Restart: 'systemctl reboot',
    Logout: 'hyprctl dispatch exit',
    Sleep: 'systemctl suspend-then-hibernate',
    Lock: 'loginctl lock-session',
};

const toggle = Toggle({
    name: 'power',
    status: () => Widget.Label({ label, tooltip_text }),
    class_name: 'status',
    dropdown: () =>
        Widget.Box({
            class_name: 'menu',
            vertical: true,
            children: Object.entries(COMMANDS).map(([name, cmd]) =>
                Widget.Button({
                    css: 'font-size: 150%',
                    on_clicked: () => {
                        toggle.Reveal.value = false;
                        Utils.execAsync(cmd);
                    },
                    child: Widget.Label((Icons.Power.Commands as any)[name]),
                }),
            ),
        }),
});

export default toggle.Button;
