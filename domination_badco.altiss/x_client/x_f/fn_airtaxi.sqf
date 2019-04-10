// by Xeno
#define THIS_FILE "fn_airtaxi.sqf"
#include "..\..\x_setup.sqf"

if (isNil "d_heli_taxi_available") then {d_heli_taxi_available = true};

if ((count (allPlayers - entities "HeadlessClient_F")) >= 10) exitWith {hint "AI support not available with more than 10 players."};

if (!d_heli_taxi_available) exitWith {[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_139")};

/*
if (d_FLAG_BASE distance2D player < 500) exitWith {[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_140")};
*/

private _exitj = false;
if (d_with_ranked || {d_database_found}) then {
	if (score player < (d_ranked_a # 15)) exitWith {
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_1424", score player, d_ranked_a # 15];
		_exitj = true;
	};
	[player, (d_ranked_a # 15) * -1] remoteExecCall ["addScore", 2];
};

if (_exitj) exitWith {};

d_x_do_call_taxi = false;

d_x_airtaximarker = "d_air_taxi_" + str player;
[d_x_airtaximarker, d_FLAG_BASE, "ICON", "ColorBlue", [0.8,0.8], localize "STR_DOM_MISSIONSTRING_1882", 0, "mil_dot"] call d_fnc_CreateMarkerLocal;

createDialog "D_AirTaxiDialog";
waitUntil {!isNil "d_airdtaxi_dialog_open" && {d_x_do_call_taxi || {!d_airdtaxi_dialog_open || {!alive player || {player getVariable ["xr_pluncon", false] || {player getVariable ["ace_isunconscious", false]}}}}}};

if (!d_x_do_call_taxi) exitWith {
	player sideChat (localize "STR_DOM_MISSIONSTRING_1881");
};

private _destination = markerPos d_x_airtaximarker;

if (!isNil "d_AISPAWN" && {_destination distance2D d_FLAG_BASE < 100}) then {_destination = getPos d_AISPAWN};

_destination set [2, 0];

player sideChat (localize "STR_DOM_MISSIONSTRING_141");

[netId player, getPos player, _destination] remoteExec ["d_fnc_airtaxiserver", 2];

deleteMarkerLocal d_x_airtaximarker;