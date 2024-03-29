import type { Client } from 'service/hyprland';
import type { Button } from 'widgets/button';
import type { Label } from 'widgets/label';

import Icons from '../lib/icons.js';

const hyprland = await Service.import('hyprland');

const workspaces = hyprland.bind('workspaces');
const clients = hyprland.bind('clients');
const activeWorkspaceId = hyprland.active.workspace.bind('id');

const submap = Variable('');
const sub = submap.bind();
hyprland.connect('submap', (_, s) => (submap.value = s || ''));

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
    const workspace: { [id: PropertyKey]: Client[] } = {};
    const pinned: { [id: PropertyKey]: Client[] } = {};
    for (const cl of cls) {
        if (cl.workspace.id > 0 && cl.pid > 0) {
            const id = cl.pinned
                ? hyprland.getMonitor(cl.monitor)?.name || ''
                : cl.workspace.id;
            const g = cl.pinned ? pinned : workspace;
            g[id] = g[id] || [];
            g[id].push(cl);
        }
    }
    const w: { [id: string]: string } = {};
    const p: { [id: string]: string } = {};
    for (const [k, v] of Object.entries(workspace)) {
        w[k] = v.sort(sort).map(icon).join(' ');
    }
    for (const [k, v] of Object.entries(pinned)) {
        p[k] = v.sort(sort).map(icon).join(' ');
    }
    return { w, p };
});

function button(w: number) {
    return Widget.Button({
        on_clicked: () => hyprland.messageAsync(`dispatch workspace ${w}`),
        child: Widget.Label({ label: labels.as(l => l.w[w] || '') }),
        class_name: activeWorkspaceId.as(a =>
            a === w ? 'target' : 'unfocused target',
        ),
    });
}

export default (monitor: string) => {
    let prev: { [w: number]: Button<any, any> } = {};

    const status = Widget.Box({
        class_name: 'dim status',
        children: [
            Widget.Revealer({
                transition: 'slide_right',
                transition_duration: 500,
                child: Widget.Label({
                    label: labels.as(l => l.p[monitor] || ''),
                }),
                reveal_child: labels.as(l => !!l.p[monitor]),
            }),
            Widget.Label({
                class_name: sub.as(s => (s ? '' : 'hidden')),
                label: sub.as(s => s || Icons.Space),
            }),
        ],
    });

    return Widget.Box({
        class_name: 'workspaces',
        children: workspaces.as(ws => {
            const next: { [w: number]: Button<any, any> } = {};
            const buttons = ws
                .filter(w => w.id > 0 && w.monitor === monitor)
                .sort((a, b) => a.id - b.id)
                .map(w => (next[w.id] = prev[w.id] || button(w.id)));
            prev = next;
            return [...buttons, status];
        }),
    });
};
