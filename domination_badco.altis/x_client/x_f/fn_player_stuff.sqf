// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_player_stuff.sqf"
#include "..\..\x_setup.sqf"

//the params of this function is the player's array from InitPlayerServer

//it must be executed only on client side
if (isDedicated) exitWith {};

//define global variable d_player_autokick_time as defined in player's array
__TRACE_1("","_this")
d_player_autokick_time = param [0];

/*if revive system is active and players lives = -1 
	then call xr_fnc_park_player on background (but skip the blackout part)
*/
if (d_WithRevive == 0 && {(param [8]) == -1 && {xr_max_lives != -1}}) exitWith {
	0 spawn {
		scriptName "spawn_playerstuffparking";
		waitUntil {!d_still_in_intro};
		__TRACE("player_stuff, calling park_player")
		[false] spawn xr_fnc_park_player;
	};
};

private _lo = param [11];
__TRACE_1("","_lo")
if !(_lo select 0 isEqualTo []) then {
	_lo spawn {
		waitUntil {!isNil "d_player_side"};
		if (_this select 1 == d_player_side) then {
			player setUnitLoadout [_this select 0, false];
			call d_fnc_save_respawngear;
			call d_fnc_save_layoutgear;
			
		};
	};
};

/*player remoteExecCall ["d_fnc_prison_check", 2];*/