#define THIS_FILE "fn_carry.sqf"
#include "..\..\x_macros.sqf"

if (isDedicated) exitWith {};

private _dragee	= _this select 3;
private _name_dragee = [_dragee] call d_fnc_gethpname;
if (isNil "_name_dragee" || {_name_dragee == ""}) then {_name_dragee = _dragee call d_fnc_getplayername};
private _unit = player;
xr_carry = true;
xr_drag = false;

if (xr_carryAction != -3333) then {
	_unit removeAction xr_carryAction;
	xr_carryAction = -3333;
};
if (isNull _dragee) exitWith {};
detach _dragee;
sleep 1.5;
player setVariable ["xr_pisinaction", true];
_dragee setVariable ["xr_dragged", true, true];

[_dragee, "ainjpfalmstpsnonwrfldnon_carried_up"] remoteExecCall ["switchMove"];
[_unit, "acinpknlmstpsraswrfldnon_acinpercmrunsraswrfldnon"] remoteExecCall ["switchMove"];
sleep 10;
_dragee attachTo [_unit,  [-0,-0.1,-1.2], "RightShoulder"];
//[_dragee, 180] remoteExecCall ["setDir"];

if (isNil "xr_loadAction") then {
	xr_loadAction = - 3333;
};

if (xr_loadAction != -3333) then {
	player removeAction xr_loadAction;
	xr_loadAction = - 3333;
};

private _found_anim = false;

_anims = ["acinpercmstpsraswrfldnon", "acinpercmrunsraswrfldf"];

while {xr_carry} do {
	if (!_found_anim && {animationState player in _anims}) then {
		_found_anim = true;
	};
	if (alive _dragee && {!(_dragee getVariable ["xr_pluncon", false])}) exitWith {
		detach _dragee;
    player removeAction xr_dropAction;
		xr_dropAction = -3333;
		xr_carry = false;
		sleep 0.5;
		[_unit, ""] remoteExecCall ["switchMove"];
		[_dragee, 102] remoteExecCall ["xr_fnc_handlenet"];
	};

	//check that dragged unit still exists
	if (isNull _dragee || {!alive _unit} || {(vehicle _unit) != _unit} || {_found_anim && {!((animationState _unit) in _anims)}}) exitWith {
		player removeAction xr_dropAction;
		xr_dropAction = -3333;
		if (!isNull _dragee) then {
			detach _dragee;
			sleep 0.5;
			if ((alive _dragee && {_dragee getVariable ["xr_pluncon", false]}) || {!alive _dragee}) then {
				[_dragee, 101] remoteExecCall ["xr_fnc_handlenet"];
			} else {
				[_dragee, 102] remoteExecCall ["xr_fnc_handlenet"];
			};
		};
		[_unit, ""] remoteExecCall ["switchMove"];
		xr_carry = false;
	};
	sleep 0.1;
};

player setVariable ["xr_pisinaction", false];
_dragee setVariable ["xr_dragged", false, true];
