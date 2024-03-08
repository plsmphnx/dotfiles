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
                self.value = p.length > 0 ? p.position / p.length : 0;
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
        Widget.Box({ class_name: 'actions' }, prev, play, next),
    );
}

const paused = Variable(false);
Utils.merge([players], ps =>
    Utils.merge(
        ps.map(p => p.bind('play_back_status')),
        (...status) => (paused.value = status.every(s => s !== 'Playing')),
    ),
);

export default Toggle({
    name: 'mpris',
    status: () =>
        Widget.Label({
            label: paused
                .bind()
                .as(p => (p ? Icons.Mpris.Paused : Icons.Mpris.Icon)),
        }),
    dropdown: Widget.Box({
        vertical: true,
        children: players.as(p => p.map(player)),
    }),
    reveal: players.as(p => p.length > 0),
    on_secondary_click: () => {
        const playing = mpris.players.filter(
            p => p.play_back_status === 'Playing',
        );
        for (const p of playing) {
            p.playPause();
        }
        if (playing.length === 0 && mpris.players.length === 1) {
            mpris.players[0].play();
        }
    },
}).Button;
