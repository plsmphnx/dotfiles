import Icons from '../lib/icons.js';
import Toggle from '../lib/toggle.js';

const COMMANDS = {
    Shutdown: 'systemctl poweroff',
    Restart: 'systemctl reboot',
    Logout: 'hyprctl dispatch exit',
    Sleep: 'systemctl suspend-then-hibernate',
    Lock: 'loginctl lock-session',
};

const toggle = Toggle({
    name: 'power',
    status: () => Widget.Label(Icons.Power.Icon),
    class_name: 'status',
    dropdown: Widget.Box({
        class_name: 'menu',
        vertical: true,
        children: Object.entries(COMMANDS).map(([name, cmd]) =>
            Widget.Button({
                on_clicked: () => {
                    toggle.Reveal.value = false;
                    Utils.execAsync(cmd);
                },
                child: Widget.Label({
                    label: `${name} ${(Icons.Power as any)[name]}`,
                    hpack: 'end',
                }),
            }),
        ),
    }),
});

export default toggle.Button;
