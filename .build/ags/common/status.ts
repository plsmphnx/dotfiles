import type { Binding } from 'service';
import type { ButtonProps } from 'widgets/button';

export type Handlers = Pick<
    ButtonProps,
    | 'on_clicked'
    | 'on_hover'
    | 'on_hover_lost'
    | 'on_scroll_up'
    | 'on_scroll_down'
    | 'on_primary_click'
    | 'on_middle_click'
    | 'on_secondary_click'
    | 'on_primary_click_release'
    | 'on_middle_click_release'
    | 'on_secondary_click_release'
>;

export interface Props extends Handlers {
    icon: Binding<any, any, string> | string;
    show?: Binding<any, any, boolean>;
    tooltip?: Binding<any, any, string> | string;
}

export default ({ icon, show, tooltip, ...rest }: Props) => {
    const button = Widget.Button({
        ...rest,
        child: Widget.Label({
            label: icon,
            ...(tooltip ? { tooltip_text: tooltip } : {}),
        }),
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
