// by Bucointesta
//#define __DEBUG__
#define _this_FILE "fn_prison_in.sqf"
#include "..\..\x_setup.sqf"

if ((!isnil "prison_running") && {prison_running}) exitWith {};
prison_running = true;

private _cell = _this select 0;
private _time = _this select 1;

call d_fnc_save_layoutgear;
player setVariable ["d_isinprison", true];
player allowDamage false;
xr_phd_invulnerable = true;
player action ["eject", vehicle player];
sleep 0.1;
removeAllWeapons player;
removeallItems player;
removeAllAssignedItems player;
removeVest player;
removeBackpack player;
removeHeadgear player;
removeGoggles player;
player setUnitLoadout d_prisonerLoadout;
player setPosATL _cell;
xr_phd_invulnerable = false;
player allowDamage true;
hint format ["You are sent to prison for excessive teamkilling. You need to wait here for %1 minutes before being released.", round (_time/60)];
_release = time + _time;
while {time < _release} do {
	if (alive player && {player distance2D _cell > 100}) then {
		player setPosATL _cell;
	};
	sleep 5;
};
/*
if !(alive player) exitWith {}; //wait for respawn
if (time < _release) exitWith {  //jailbreak
			_cell call d_fnc_prison_in;
}; 
*/
prison_running = false;
player setVariable ["d_isinprison", false];
player remoteExecCall ["d_fnc_prison_out", 2];
player setPos (getMarkerPos "base_spawn_1");
hint "You are released. Please respect fire discipline from now on.";
call d_fnc_retrieve_layoutgear;