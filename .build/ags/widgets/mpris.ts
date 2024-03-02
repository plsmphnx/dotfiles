import type { MprisPlayer } from 'service/mpris';
import Icons from '../lib/icons.js';
import Toggle from '../lib/toggle.js';

const mpris = await Service.import('mpris');
const players = mpris.bind('players');

const FALLBACK_ICON = 'audio-x-generic-symbolic';

function length(s: number) {
    const min = Math.floor(s / 60);
    const sec = Math.floor(s % 60);
    return `${min}:${`0${sec}`.slice(-2)}`;
}

function player(p: MprisPlayer) {
    const img = Widget.Box({
        class_name: 'icon',
        vpack: 'start',
        css: p.bind('cover_path').as(p => `background-image: url('${p}')`),
    });

    const title = Widget.Label({
        class_name: 'title',
        wrap: true,
        hpack: 'start',
        label: p.bind('track_title'),
    });

    const appIcon = Widget.Icon({
        hexpand: true,
        hpack: 'end',
        vpack: 'start',
        tooltip_text: p.identity || '',
        icon: p
            .bind('entry')
            .as(entry => (Utils.lookUpIcon(entry) ? entry : FALLBACK_ICON)),
    });

    const artist = Widget.Label({
        class_name: 'subtitle',
        wrap: true,
        hpack: 'start',
        label: p.bind('track_artists').as(a => a.join(', ')),
    });

    const positionLabel = Widget.Label({
        hpack: 'start',
        setup: self => {
            const update = () => {
                self.label = length(p.position);
                self.visible = p.length > 0;
            };
            self.hook(p, update, 'position');
            self.poll(1000, update);
        },
    });

    const positionSlider = Widget.Slider({
        hexpand: true,
        hpack: 'fill',
        draw_value: false,
        on_change: ({ value }) => (p.position = value * p.length),
        setup: self => {
            const update = () => {
                self.value = p.position / p.length;
                self.visible = p.length > 0;
            };
            self.hook(p, update, 'position');
            self.poll(1000, update);
        },
    });

    const lengthLabel = Widget.Label({
        hpack: 'end',
        visible: p.bind('length').as(l => l > 0),
        label: p.bind('length').as(length),
    });

    const prev = Widget.Button({
        on_clicked: () => p.previous(),
        visible: p.bind('can_go_prev'),
        hexpand: true,
        child: Widget.Label(Icons.Mpris.Prev),
    });

    const play = Widget.Button({
        on_clicked: () => p.playPause(),
        visible: p.bind('can_play'),
        hexpand: true,
        child: Widget.Label().bind('label', p, 'play_back_status', s =>
            s === 'Playing' ? Icons.Mpris.Pause : Icons.Mpris.Play,
        ),
    });

    const next = Widget.Button({
        on_clicked: () => p.next(),
        visible: p.bind('can_go_next'),
        hexpand: true,
        child: Widget.Label(Icons.Mpris.Next),
    });

    return Widget.Box(
        { class_name: 'action', vertical: true },
        Widget.Box([
            img,
            Widget.Box(
                { vertical: true },
                Widget.Box([title, appIcon]),
                artist,
                Widget.Box([positionLabel, positionSlider, lengthLabel]),
            ),
        ]),
        Widget.Box([prev, play, next]),
    );
}

export default Toggle({
    name: 'mpris',
    status: () => Widget.Label(Icons.Mpris.Icon),
    dropdown: Widget.Box({
        vertical: true,
        children: players.as(p => p.map(player)),
    }),
    reveal: players.as(p => p.length > 0),
}).Button;
