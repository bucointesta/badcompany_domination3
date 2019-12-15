// by Bucointesta
//#define __DEBUG__
#define _this_FILE "fn_prison_check.sqf"
#include "..\..\x_setup.sqf"

/* to be launched when player join server, when player respawn, when player tk someone */
if (!(isPlayer _this)) exitWith {diag_log "THIS IS NOT A PLAYER"};

private _p = d_player_store getVariable (getPlayerUID _this);

if (isNil "_p") exitWith {};

if (alive _this) then {
	if (_p select 13 > 0) then { /*should already be in prison*/
		if (_this distance2D ((d_prison select (_p select 13)) select 0) > 100) then {  /*jailbreak*/
			diag_log format ["Jailbreak ! Player %1 too far away from prison: %2 meters, sending him there", _p select 6, _this distance2D ((d_prison select (_p select 13)) select 0)];
			((d_prison select (_p select 13))select 0) remoteExec ["d_fnc_prison_in", _this];
		}; 
	} else {
		if ((_p select 7) >= d_maxnum_tks_forkick) then { /*need to send him in prison*/	
			for "_i" from 1 to ((count d_prison) - 1) do {
				private _cell = d_prison select _i;
				if (_cell select 1) exitWith { //jail slot available
					(d_prison select _i) set [1, true];
					_p set [13, _i];
				};
			};
			remoteExecCall ["d_fnc_save_layoutgear", _this];
			diag_log format ["Sending %2 in prison !! Cell number %1", (d_prison select (_p select 13)) select 0, _this];
			((d_prison select (_p select 13))select 0) remoteExec ["d_fnc_prison_in", _this];
		};
	};
};