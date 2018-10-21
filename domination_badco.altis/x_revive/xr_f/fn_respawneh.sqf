// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_respawneh.sqf"
#include "..\..\x_macros.sqf"

private _tmpeh = player addEventhandler ["handleDamage", {0}];

enableRadio false;
0 fadeSound 0;
//player setPos (markerPos "xr_resp_marker");
player setVehiclePosition [markerPos "xr_resp_marker", [], 0, "NONE"]; // CAN_COLLIDE ?
[player, true] remoteExecCall ["setCaptive"];
if (player getVariable "xr_isdead") exitWith {};
__TRACE("playActionNow Die/setuncon")
player playActionNow "Die"; // takes loooong
player setVariable ["xr_pluncon", true, true]; // just to be sure

_this spawn {
	scriptName "xr respawn eh spawn";
	sleep 1.6;
	private _old = param [1];
	__TRACE_1("","_old")
	private _norm_resp = false;
	if (xr_death_pos isEqualTo []) then {
		_norm_resp = true;
		_old call xr_fnc_CheckRespawn;
	};
	deleteVehicle _old;
	__TRACE_1("","_norm_resp")
	private _d_pos = xr_death_pos;
	__TRACE_1("","_d_pos")
	if !(_d_pos isEqualTo []) then {
		__TRACE("pos to old pos and dir")
		player setDir (_d_pos select 1);
		player setPos (_d_pos select 0);
		if (!_norm_resp) then {
			0 spawn xr_fnc_uncon;
			if (xr_with_marker) then {
				[player, getPosWorld player] remoteExecCall ["xr_fnc_addmarker", 2];
			};
		} else {
			__TRACE("spawning go uncon")
			[_d_pos select 0] spawn {
				params ["_d_pos0"];
				if (surfaceIsWater (getPosWorld player)) then {
					__TRACE("watferfix check start")
					private _shandle = 0 spawn xr_fnc_waterfix;
					waitUntil {scriptDone _shandle};
					__TRACE("watferfix done")
					__TRACE("playActionNow Die again because of waterfix")
					player playActionNow "Die";
				};
				waitUntil {speed player < 0.5};
				if (_d_pos0 select 2 < 1) then {
					private _pos = getPosATL player;
					private _slope = [_pos, 1] call d_fnc_GetSlope;
					__TRACE_2("","_pos","_slope")
					if (_slope >= 0.78) then {
						__TRACE("in slope, new position")
						[_pos, _slope, player] call xr_fnc_DoSlope;
					};
				};
				0 spawn xr_fnc_uncon;
			};
		};
	};
};

player setVariable ["xr_pisinaction", false];
player setVariable ["xr_is_dragging", false];
player setVariable ["xr_dragged", false, true];

0 spawn {
	private _etime = time + 5;
	waitUntil {bis_fnc_feedback_allowPP || {time > _etime}};
	bis_fnc_feedback_allowPP = false;
};
player setDamage 0;
bis_fnc_feedback_burningTimer = 0;
player setFatigue 0;

if (d_enablefatigue == 0) then {
	player enableFatigue false;
};

if (d_enablesway == 0) then {
	player setCustomAimCoef 0.1;
};

if (xr_selfheals > 0) then {
	player setVariable ["xr_numheals", xr_selfheals];
	player setVariable ["xr_selfh_ac_id", player addAction ["<t color='#FF0000'>Self Heal</t>", {_this call xr_fnc_selfheal}, [], -1, false, false, "", "alive _target &&  {!(_target getVariable 'xr_pluncon') && {!(_target getVariable 'xr_pisinaction') && {damage _target >= xr_selfheals_minmaxdam select 0 && {damage _target <= xr_selfheals_minmaxdam select 1 && {_target getVariable 'xr_numheals' > 0}}}}}"]];
};

player removeEventHandler ["handleDamage", _tmpeh];
