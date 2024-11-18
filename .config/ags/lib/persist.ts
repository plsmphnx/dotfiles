import { bind, Variable } from 'astal';
import { Gtk } from 'astal/gtk3'

export default <T extends Gtk.Widget>(create: () => T) => {
    const widget = Variable<T>(undefined as any);
    const build = () => {
        const created = create();
        created.connect('destroy', build)
        widget.set(created)
    };
    build();
    return bind(widget);
};
