import Apps from 'gi://AstalApps';
import Battery from 'gi://AstalBattery';
import Bluetooth from 'gi://AstalBluetooth';
import Hyprland from 'gi://AstalHyprland';
import Mpris from 'gi://AstalMpris';
import Network from 'gi://AstalNetwork';
import Notifd from 'gi://AstalNotifd';
import Tray from 'gi://AstalTray';
import Wp from 'gi://AstalWp';

export const battery = Battery.get_default();
export const bluetooth = Bluetooth.get_default();
export const hyprland = Hyprland.get_default();
export const mpris = Mpris.get_default();
export const network = Network.get_default();
export const notifd = Notifd.get_default();
export const tray = Tray.get_default();
export const wp = Wp.get_default()!;

export { Apps, Battery, Bluetooth, Hyprland, Mpris, Network, Notifd, Tray, Wp };
