import Dropdown, { Props as DropdownProps } from './dropdown.js';
import Status, { Props as StatusProps } from './status.js';

export interface Props
    extends Omit<StatusProps, 'name' | 'child'>,
        Omit<DropdownProps, 'reveal' | 'child'> {
    status: () => StatusProps['child'];
    dropdown: DropdownProps['child'];
}

export default ({ name, reveal, status, dropdown, ...rest }: Props) => {
    const Reveal = Variable(false);
    const show = Reveal.bind();
    if (reveal) {
        Utils.merge([reveal], s => {
            if (!s) {
                Reveal.value = false;
            }
        });
    }
    return {
        Reveal,
        Button: () =>
            Status({
                ...rest,
                on_clicked: () => (Reveal.value = !Reveal.value),
                child: status(),
                reveal: reveal && Utils.merge([reveal, show], (s, d) => s || d),
            }),
        Window: Dropdown({ name, reveal: show, child: dropdown }),
    };
};
