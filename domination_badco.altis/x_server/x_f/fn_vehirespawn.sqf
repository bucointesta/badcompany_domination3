// by Xeno
#define THIS_FILE "fn_vehirespawn.sqf"
#include "..\..\x_setup.sqf"

if (!isServer) exitWith{};

params ["_vec", "_delay"];

private _startpos = getPosATL _vec;
private _startdir = getDir _vec;
private _type = typeOf _vec;

_vec setVariable ["d_vec_islocked", (_vec call d_fnc_isVecLocked)];

_vec addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_fuelCheck;}}];

while {true} do {
	sleep (_delay + random 15);
	
	if ({alive _x} count (crew _vec) == 0 && {damage _vec > 0 || {_vec distance2D _startpos > 5 || {!alive _vec}}}) then {
		private _isitlocked = _vec getVariable "d_vec_islocked";
		private _fuelleft = _vec getVariable ["d_fuel", 1];
		deleteVehicle _vec;
		sleep 0.5;
		_vec = createVehicle [_type, _startpos, [], 0, "NONE"];
		_vec setDir _startdir;
		_vec setPos _startpos;
		_vec setVariable ["d_vec_islocked", _isitlocked];
		if (_isitlocked) then {_vec lock true};
		_vec setFuel _fuelleft;
		_vec addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_fuelCheck}}];
	};
};
