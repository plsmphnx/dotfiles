import type { MprisPlayer } from 'service/mpris';
import Icons from '../common/icons.js';
import Toggle from '../common/toggle.js';

const mpris = await Service.import('mpris');
const players = mpris.bind('players');

const FALLBACK_ICON = 'audio-x-generic-symbolic';

function lengthStr(length: number) {
    const min = Math.floor(length / 60);
    const sec = Math.floor(length % 60);
    const sec0 = sec < 10 ? '0' : '';
    return `${min}:${sec0}${sec}`;
}

function Player(player: MprisPlayer) {
    const img = Widget.Box({
        class_name: 'icon',
        vpack: 'start',
        css: player
            .bind('cover_path')
            .transform(p => `background-image: url('${p}')`),
    });

    const title = Widget.Label({
        class_name: 'title',
        wrap: true,
        hpack: 'start',
        label: player.bind('track_title'),
    });

    const artist = Widget.Label({
        class_name: 'subtitle',
        wrap: true,
        hpack: 'start',
        label: player.bind('track_artists').transform(a => a.join(', ')),
    });

    const positionSlider = Widget.Slider({
        draw_value: false,
        on_change: ({ value }) => (player.position = value * player.length),
        setup: self => {
            const update = () => {
                self.visible = player.length > 0;
                self.value = player.position / player.length;
            };
            self.hook(player, update);
            self.hook(player, update, 'position');
            self.poll(1000, update);
        },
    });

    const positionLabel = Widget.Label({
        hpack: 'start',
        setup: self => {
            const update = (_: any, time?: number) => {
                self.label = lengthStr(time || player.position);
                self.visible = player.length > 0;
            };

            self.hook(player, update, 'position');
            self.poll(1000, update);
        },
    });

    const lengthLabel = Widget.Label({
        hpack: 'end',
        visible: player.bind('length').transform(l => l > 0),
        label: player.bind('length').transform(lengthStr),
    });

    const icon = Widget.Icon({
        hexpand: true,
        hpack: 'end',
        vpack: 'start',
        tooltip_text: player.identity || '',
        icon: player.bind('entry').transform(entry => {
            const name = `${entry}-symbolic`;
            return Utils.lookUpIcon(name) ? name : FALLBACK_ICON;
        }),
    });

    const playPause = Widget.Button({
        on_clicked: () => player.playPause(),
        visible: player.bind('can_play'),
        hexpand: true,
        child: Widget.Label({
            label: player.bind('play_back_status').transform(s => {
                switch (s) {
                    case 'Playing':
                        return Icons.Mpris.Pause;
                    case 'Paused':
                    case 'Stopped':
                        return Icons.Mpris.Play;
                }
            }),
        }),
    });

    const prev = Widget.Button({
        on_clicked: () => player.previous(),
        visible: player.bind('can_go_prev'),
        hexpand: true,
        child: Widget.Label(Icons.Mpris.Prev),
    });

    const next = Widget.Button({
        on_clicked: () => player.next(),
        visible: player.bind('can_go_next'),
        hexpand: true,
        child: Widget.Label(Icons.Mpris.Next),
    });

    return Widget.Box(
        { class_name: 'action', vertical: true },
        Widget.Box([
            img,
            Widget.Box(
                { vertical: true },
                Widget.Box([title, icon]),
                artist,
                Widget.CenterBox({
                    start_widget: positionLabel,
                    center_widget: positionSlider,
                    end_widget: lengthLabel,
                }),
            ),
        ]),
        Widget.Box([prev, playPause, next]),
    );
}

export default Toggle({
    name: 'mpris',
    show: players.as(p => p.length > 0),
    child: Widget.Box({
        vertical: true,
        children: players.as(p => p.map(Player)),
    }),
    icon: Icons.Mpris.Icon,
});
