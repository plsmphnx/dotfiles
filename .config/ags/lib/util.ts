import type Gtk from 'gi://Gtk?version=3.0';
import type { Scrollable } from 'widgets/scrollable';

export function scrollIntoView(this: Scrollable<any, any>, widget: Gtk.Widget) {
    const m = this.get_style_context().get_margin(this.get_state_flags());
    const y = widget.translate_coordinates(this, 0, 0)[2] - m.top;
    const w = widget.get_allocated_height();
    const s = this.get_allocated_height() - (m.top + m.bottom);
    if (y + w > s) {
        this.vadjustment.value += y + w - s;
    } else if (y < 0) {
        this.vadjustment.value += y;
    }
}
