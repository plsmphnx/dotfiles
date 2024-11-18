import GObject from 'gi://GObject';

import { astalify, Gtk } from 'astal/gtk3';

export class Calendar extends astalify(Gtk.Calendar) {
    static {
        GObject.registerClass(this);
    }
}
