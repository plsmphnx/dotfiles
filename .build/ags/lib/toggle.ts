import Dropdown, { Props as DropdownProps } from './dropdown.js';
import Reset from './reset.js';
import Status, { Props as StatusProps } from './status.js';

export interface Props
    extends Omit<StatusProps, 'name' | 'child'>,
        Omit<DropdownProps, 'reveal' | 'child'> {
    status: () => StatusProps['child'];
    dropdown: DropdownProps['child'];
}

export default ({ name, reveal, status, dropdown, ...rest }: Props) => {
    const Reveal = Reset(reveal);
    return {
        Reveal,
        Button: () =>
            Status({
                ...rest,
                on_clicked: () => (Reveal.value = !Reveal.value),
                child: status(),
                reveal,
            }),
        Window: Dropdown({ name, reveal: Reveal.bind(), child: dropdown }),
    };
};
