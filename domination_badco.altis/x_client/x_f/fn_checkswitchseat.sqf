#define THIS_FILE "fn_checkswitchseat.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

_vec = _this select 2;
_vehRole = assignedVehicleRole player;
_position = _vehRole select 0;

if (isnil "_position") exitWith {};

_turret = [0];
if (_position != "Driver") then {

	_turret = _vehRole select 1;

};

if ((d_pilots_only == 0) && {(_position == "Driver") || {((_turret select 0) == 0) && {_position == "Turret"} && {(count _turret) == 1}}}) then {

	if (!([str player,_vec,_vec getvariable ["d_vec",0]] call d_fnc_isPilotCheck)) then {
	
		_vec spawn {				
				
				uisleep 0.3;
				moveout player;
				uisleep 0.01;
				waitUntil {(vehicle player) == player};
				player moveInCargo _this;
				sleep 0.1;
				if (local _this) then {
					_this engineOn false;
				} else {
					[_this, false] remoteExecCall ["engineOn",_this,false];
				};				
				
			};		
		 
	};

};

