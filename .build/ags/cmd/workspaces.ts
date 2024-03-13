const hyprland = await Service.import('hyprland');

function exec(move: boolean, to: number) {
    hyprland.messageAsync(`dispatch ${move ? 'moveto' : ''}workspace ${to}`);
}

function status() {
    const monitor = hyprland.active.monitor.name;
    return {
        active: hyprland.active.workspace.id,
        monitor: hyprland.workspaces.filter(
            w => w.id > 0 && w.monitor === monitor,
        ),
    };
}

function prev(move: boolean = false) {
    const { active, monitor } = status();
    exec(move, monitor.reverse().find(w => w.id < active)?.id || active - 1);
}

function next(move: boolean = false) {
    const { active, monitor } = status();
    exec(move, monitor.find(w => w.id > active)?.id || active + 1);
}

function empty(move: boolean = false) {
    const { monitor } = status();
    exec(move, monitor[monitor.length - 1].id + 1);
}

export default { prev, next, empty };
