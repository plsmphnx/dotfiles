import type { Client } from 'service/hyprland';
import type { Button } from 'widgets/button';
import Icons from '../lib/icons.js';

const hyprland = await Service.import('hyprland');

const workspaces = hyprland.bind('workspaces');
const clients = hyprland.bind('clients');
const activeWorkspaceId = hyprland.active.workspace.bind('id');

let icons: [string, string][];
const iconFile = `${Utils.HOME}/.local/share/ux/icons.txt`;
async function load(file: any) {
    icons = (await Utils.readFileAsync(file))
        .split('\n')
        .map(l => l.trim())
        .filter(l => l)
        .map(l => l.split(/\s+/))
        .map(([cls, hex]) => [cls, String.fromCodePoint(parseInt(hex, 16))]);
}
await load(iconFile);
Utils.monitorFile(iconFile, load);

function icon(client: Client) {
    for (const [cls, icon] of icons) {
        if (client.class.toLowerCase().includes(cls)) {
            return icon;
        }
    }
    return Icons.Workspaces.Fallback;
}

function sort(a: Client, b: Client) {
    return a.at[0] - b.at[0] || a.at[1] - b.at[1];
}

const labels = clients.as(cls => {
    const c: { [id: number]: Client[] } = {};
    for (const cl of cls) {
        if (cl.workspace.id > 0 && cl.pid > 0) {
            c[cl.workspace.id] = c[cl.workspace.id] || [];
            c[cl.workspace.id].push(cl);
        }
    }
    const l: { [id: string]: string } = {};
    for (const [k, v] of Object.entries(c)) {
        l[k] = v.sort(sort).map(icon).join(' ');
    }
    return l;
});

function button(w: number) {
    return Widget.Button({
        on_clicked: () => hyprland.messageAsync(`dispatch workspace ${w}`),
        child: Widget.Label({ label: labels.as(l => l[w] || '') }),
        class_name: activeWorkspaceId.as(a =>
            a === w ? 'target focused' : 'target',
        ),
    });
}

export default (monitor: number) => {
    let prev: { [w: number]: Button<any, any> } = {};
    return Widget.Box({
        class_name: 'workspaces',
        children: workspaces.as(ws => {
            const next: { [w: number]: Button<any, any> } = {};
            const buttons = ws
                .filter(w => w.id > 0 && w.monitorID === monitor)
                .sort((a, b) => a.id - b.id)
                .map(w => (next[w.id] = prev[w.id] || button(w.id)));
            prev = next;
            return buttons;
        }),
    });
};
