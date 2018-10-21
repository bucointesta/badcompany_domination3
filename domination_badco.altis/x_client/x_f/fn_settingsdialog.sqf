// by Xeno
#define THIS_FILE "fn_settingsdialog.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

createDialog "d_SettingsDialog";

0 spawn {
	scriptName "spawn_settingsdialog_dialogclose";
	waitUntil {!d_settings_dialog_open || {!alive player || {player getVariable ["xr_pluncon", false] || {player getVariable ["ace_isunconscious", false]}}}};
	if (d_settings_dialog_open) then {closeDialog 0};
};