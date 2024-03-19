import type { Widget } from 'widgets/widget';

export default <T extends Widget<any>>(create: () => T) => {
    const widget = Variable<T>(undefined as any);
    const build = () => (widget.value = create().on('destroy', build));
    build();
    return widget.bind();
};
