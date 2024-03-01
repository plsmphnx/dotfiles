import type { Binding } from 'service';
import type { ButtonProps } from 'widgets/button';

export default ({
    icon,
    show,
    ...rest
}: {
    icon: Binding<any, any, string> | string;
    show?: Binding<any, any, boolean>;
} & ButtonProps) => {
    const button = Widget.Button({
        ...rest,
        child: Widget.Label({ label: icon }),
    });
    if (show) {
        return Widget.Revealer({
            transition: 'slide_left',
            transition_duration: 500,
            child: button,
            reveal_child: show,
        });
    }
    return button;
};
