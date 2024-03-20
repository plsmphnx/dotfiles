import type Gtk from 'gi://Gtk?version=3.0';
import type Gdk from 'gi://Gdk?version=3.0';

import Cairo from 'gi://cairo?version=1.0';

const W = 2;
const R = 4;
const G = 2;

const S = W / 2;

const RIGHT = 0;
const DOWN = Math.PI / 2;
const LEFT = Math.PI;
const UP = (3 * Math.PI) / 2;

function draw(self: Gtk.Widget, cr: any) {
    const sc = self.get_style_context();
    const sf = self.get_state_flags();

    const m = sc.get_margin(sf);
    const p = sc.get_padding(sf);
    const c: Gdk.RGBA = sc.get_property('outline-color', sf);

    const w = self.get_allocated_width();
    const h = self.get_allocated_height();

    const bo = {
        top: m.top,
        left: m.left,
        right: w - m.right,
        bottom: h - m.bottom,
    };
    const bm = {
        top: bo.top + S,
        left: bo.left + S,
        right: bo.right - S,
        bottom: bo.bottom - S,
    };
    const bi = {
        top: bo.top + W,
        left: bo.left + W,
        right: bo.right - W,
        bottom: bo.bottom - W,
    };

    const l = Math.max((G * p.left) / (bi.right - bi.left), 0.125);
    const r = Math.min(1 - (G * p.right) / (bi.right - bi.left), 0.875);

    const g = new (Cairo as any).LinearGradient(bi.left, 0, bi.right, 0);
    g.addColorStopRGBA(0, c.red, c.green, c.blue, c.alpha);
    g.addColorStopRGBA(l, 0, 0, 0, 0);
    g.addColorStopRGBA(r, 0, 0, 0, 0);
    g.addColorStopRGBA(1, c.red, c.green, c.blue, c.alpha);

    cr.setSource(g);
    cr.setLineWidth(W);

    cr.moveTo(bm.left, bi.top + R);
    cr.arc(bi.left + R, bi.top + R, R + S, LEFT, UP);
    cr.lineTo(bi.right - R, bm.top);
    cr.arc(bi.right - R, bi.top + R, R + S, UP, RIGHT);
    cr.lineTo(bm.right, bi.bottom - R);
    cr.arc(bi.right - R, bi.bottom - R, R + S, RIGHT, DOWN);
    cr.lineTo(bi.left + R, bm.bottom);
    cr.arc(bi.left + R, bi.bottom - R, R + S, DOWN, LEFT);
    cr.closePath();
    cr.stroke();

    return false;
}

export default new Proxy(Widget, {
    get:
        (w, p: keyof typeof Widget) =>
        (...args: any[]) => {
            const widget = (w[p] as any)(...args).on('draw', draw);
            widget.toggleClassName('target');
            return widget;
        },
});
