// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_artillery.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

if (!alive player || {isNull objectParent player && {(getPos player) select 2 > 10} || {player getVariable ["xr_pluncon", false] || {player getVariable ["ace_isunconscious", false]}}}) exitWith {
	d_commandingMenuIniting = false;
};

disableSerialization;

if !(d_ari_available) exitWith {
	[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_145");
	d_commandingMenuIniting = false;
};

if (d_with_ranked && {score player < (d_ranked_a select 2)}) exitWith {
	[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_147", score player, d_ranked_a select 2];
	d_commandingMenuIniting = false;
};

if (d_ari_blocked) exitWith {
	[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_148");
	d_commandingMenuIniting = false;
};

d_ari_blocked = true; publicVariable "d_ari_blocked";
player setVariable ["d_blocks_arty", true, true];

createDialog "d_ArtilleryDialog2";
d_commandingMenuIniting = false;

0 spawn {
	waitUntil {!isNil "d_arti_did_fire" || {!d_arti_dialog_open || {!alive player || {player getVariable ["xr_pluncon", false] || {player getVariable ["ace_isunconscious", false]}}}}};

	if (!alive player || {player getVariable ["xr_pluncon", false] || {player getVariable ["ace_isunconscious", false]}}) exitWith {
		if (d_arti_dialog_open) then {closeDialog 0};
		d_ari_blocked = false; publicVariable "d_ari_blocked";
		player setVariable ["d_blocks_arty", nil, true];
	};

	if (isNil "d_arti_did_fire") then {
		[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_152");
	} else {
		d_arti_did_fire = nil;
	};

	d_ari_blocked = false; publicVariable "d_ari_blocked";
	player setVariable ["d_blocks_arty", nil, true];
};