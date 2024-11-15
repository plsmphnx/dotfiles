import Astal from 'gi://Astal';
import Gtk from 'gi://Gtk';

declare global {
    const TOP: number;
    const RIGHT: number;
    const LEFT: number;
    const BOTTOM: number;

    const CROSSFADE: number;
    const SLIDE_RIGHT: number;
    const SLIDE_LEFT: number;
    const SLIDE_UP: number;
    const SLIDE_DOWN: number;
}

Object.assign(globalThis, {
    TOP: Astal.WindowAnchor.TOP,
    RIGHT: Astal.WindowAnchor.RIGHT,
    LEFT: Astal.WindowAnchor.LEFT,
    BOTTOM: Astal.WindowAnchor.BOTTOM,

    CROSSFADE: Gtk.RevealerTransitionType.CROSSFADE,
    SLIDE_RIGHT: Gtk.RevealerTransitionType.SLIDE_RIGHT,
    SLIDE_LEFT: Gtk.RevealerTransitionType.SLIDE_LEFT,
    SLIDE_UP: Gtk.RevealerTransitionType.SLIDE_UP,
    SLIDE_DOWN: Gtk.RevealerTransitionType.SLIDE_DOWN,
});
