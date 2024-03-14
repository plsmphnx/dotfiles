const hyprland = await Service.import('hyprland');

async function exec(to: number, target?: string) {
    let cmd = `dispatch ${target === '' ? 'moveto' : ''}workspace ${to}`;
    if (target) {
        cmd = `[[BATCH]] ${cmd} ; dispatch execr ${target}`;
    }
    await hyprland.messageAsync(cmd);
}

function status() {
    const active = hyprland.active.workspace.id;
    const monitor = hyprland.active.monitor.name;
    const workspaces = hyprland.workspaces
        .filter(w => w.id > 0)
        .sort((a, b) => a.id - b.id);
    return {
        active: workspaces.find(w => w.id === active)!,
        monitor: workspaces.filter(w => w.monitor === monitor),
        workspaces,
    };
}

async function prev(target?: string) {
    const { active, monitor, workspaces } = status();
    if (active.id !== monitor[0].id) {
        const to = monitor.reverse().find(w => w.id < active.id)!.id;
        await exec(to, target);
    } else if (active.windows !== 0) {
        const to = workspaces[0].id - 1;
        await exec(to, target);
    }
}

async function next(target?: string) {
    const { active, monitor, workspaces } = status();
    if (active.id !== monitor[monitor.length - 1].id) {
        const to = monitor.find(w => w.id > active.id)!.id;
        await exec(to, target);
    } else if (active.windows !== 0) {
        const to = workspaces[workspaces.length - 1].id + 1;
        await exec(to, target);
    }
}

async function empty(target?: string) {
    const { active, workspaces } = status();
    const last = workspaces[workspaces.length - 1];
    if (active.id !== last.id || last.windows !== 0) {
        await exec(last.id + 1, target);
    }
}

export default { prev, next, empty };
