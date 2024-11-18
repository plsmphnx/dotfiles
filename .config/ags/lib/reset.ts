import { type Binding, Variable } from 'astal';

export default (reset?: Binding<boolean>) => {
    const toggle = Variable(false);
    reset?.subscribe(v => v || toggle.set(false))
    return toggle;
};
