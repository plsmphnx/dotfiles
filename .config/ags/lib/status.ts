import type { Binding } from 'service';
import type { ButtonProps } from 'widgets/button';

export interface Props extends ButtonProps {
    reveal?: Binding<any, any, boolean>;
}

export default ({ reveal, ...rest }: Props) => {
    const button = Widget.Button(rest);
    return reveal
        ? Widget.Revealer({
              transition: 'slide_left',
              transition_duration: 500,
              child: button,
              reveal_child: reveal,
          })
        : button;
};
