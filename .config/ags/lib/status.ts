import { type Binding } from 'astal';
import { Widget } from 'astal/gtk3';

export interface Props extends Widget.ButtonProps {
    reveal?: Binding<boolean>;
}

export default ({ reveal, ...rest }: Props) => {
    const button = new Widget.Button(rest);
    return reveal
        ? new Widget.Revealer({
              transition_type: SLIDE_LEFT,
              transition_duration: 500,
              child: button,
              reveal_child: reveal,
          })
        : button;
};
