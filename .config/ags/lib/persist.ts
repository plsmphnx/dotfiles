import { bind, Variable } from 'astal';

export default <T extends Widget>(create: () => T) => {
    const widget = Variable<T>(undefined as any);
    const build = () => widget.set(create().on('destroy', build));
    build();
    return bind(widget);
};
