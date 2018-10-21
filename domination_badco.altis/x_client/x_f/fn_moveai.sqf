// by Xeno
#define THIS_FILE "fn_moveai.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

if ({alive _x} count units (group player) > 0) then {
	if (isNil "_this" || {_this isEqualTo []}) then {
		private _pos_p = getPosATL player;
		_pos_p set [2,0];
		{
			_x setPos _pos_p;
			false
		} count ((formationMembers player) select {!isPlayer _x && {alive _x && {isNull objectParent _x && {_x distance2D _pos_p > 500}}}});
	} else {
		waitUntil {(vehicle player isKindOf "ParachuteBase") || {!alive player || {player getVariable ["xr_pluncon", false] || {player getVariable ["ace_isunconscious", false]}}}};
		if (!alive player || {player getVariable ["xr_pluncon", false] || {player getVariable ["ace_isunconscious", false]}}) exitWith {};
		params ["_pos_p", "_veloc", "_dir"];
		{
			private _obj_para = createVehicle [d_non_steer_para, [0,0,100], [], 0, "FLY"];
			_obj_para setDir _dir;
			_obj_para setVelocity _veloc;
			private _plpss = getPosWorld player;
			_obj_para setPos [(_plpss select 0) + random 10, (_plpss select 1) + random 10, ((getPosATL player) select 2) + random 10];
			_x moveInDriver _obj_para;
			[_x] spawn {
				scriptName "spawnx_moveai_paraAI";
				params ["_unit"];
				sleep 0.8321;
				waitUntil {sleep 0.111;(isNull objectParent _unit || {!alive _unit})};
				if (alive _unit) then {if ((getPosATL _unit) select 2 > 1) then {[_unit, 0] call d_fnc_SetHeight}};
			};
			false
		} count ((formationMembers player) select {!isPlayer _x && {alive _x && {isNull objectParent _x && {_x distance2D _pos_p > 500}}}});
	};
};