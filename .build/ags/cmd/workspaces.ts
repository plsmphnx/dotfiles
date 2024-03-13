const hyprland = await Service.import('hyprland');

async function exec(to: number, target?: string) {
    let cmd = `dispatch ${target === '' ? 'moveto' : ''}workspace ${to}`;
    if (target) {
        cmd = `[[BATCH]] ${cmd} ; dispatch execr ${target}`;
    }
    await hyprland.messageAsync(cmd);
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

async function prev(target?: string) {
    const { active, monitor } = status();
    const to = monitor.reverse().find(w => w.id < active)?.id || active - 1;
    await exec(to, target);
}

async function next(target?: string) {
    const { active, monitor } = status();
    const to = monitor.find(w => w.id > active)?.id || active + 1;
    await exec(to, target);
}

async function empty(target?: string) {
    const { monitor } = status();
    const to = monitor[monitor.length - 1].id + 1;
    await exec(to, target);
}

export default { prev, next, empty };
