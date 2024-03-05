import type { Binding } from 'service';

export default (reset?: Binding<any, any, boolean>) => {
    const toggle = Variable(false);
    reset && Utils.merge([reset], s => s || (toggle.value = false));
    return toggle;
};
