import type { Binding } from 'astal';
import { Variable } from 'astal';

export default (reset?: Binding<boolean>) => {
    const toggle = Variable(false);
    reset && Utils.merge([reset], s => s || (toggle.value = false));
    return toggle;
};
