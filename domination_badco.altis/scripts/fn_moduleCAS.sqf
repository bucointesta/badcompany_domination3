//#define __DEBUG__
#define THIS_FILE "fn_moduleCAS.sqf"
#include "..\x_setup.sqf"

params ["_lpos", "_caller", "_wtype"];

__TRACE_1("","_this")

if (!isServer || {!d_cas_available}) exitWith {};
d_cas_available = false;
publicVariable "d_cas_available";

private _callero = missionNamespace getVariable _caller;

private _side = side (group _callero);
private _planeClass = d_cas_plane;
__TRACE_1("","_planeClass")

private _planeCfg = configfile >> "cfgvehicles" >> _planeClass;
if !(isclass _planeCfg) exitwith {
	d_cas_available = true;
	publicVariable "d_cas_available";
	false
};

private _weaponTypes = switch _wtype do {
	case 0: {["machinegun"]};
	case 1: {["vehicleweapon"]};
	case 2: {["vehicleweapon"]};
	default {[]};
};

private _weapons = [];
{
	__TRACE_1("","_x call bis_fnc_itemType")
	if (toLower ((_x call bis_fnc_itemType) select 1) in _weaponTypes) then {
		private _modes = getArray (configFile>>"cfgweapons">>_x>>"modes");
		__TRACE_1("","_modes")
		if !(_modes isEqualTo []) then {
			private _mode = _modes select 0;
			if (_mode == "this") then {_mode = _x;};
			_weapons pushBack [_x, _mode];
		};
	};
	false
} count getArray (_planeCfg >> "weapons");
__TRACE_1("","_weapons")

if (_weapons isEqualTo []) exitwith {
	d_cas_available = true;
	publicVariable "d_cas_available";
	false
};

remoteExecCall ["d_fnc_updatesupportrsc", [0, -2] select isDedicated];

private _topicside = d_kb_topic_side;
private _logic = d_kb_logic2;
private _logic1 = d_kb_logic1;
private _channel = d_kbtel_chan;

private _callero = missionNamespace getVariable _caller;
if (isNil "_callero" || {isNull _callero}) then {_callero = _logic};
_logic1 kbTell [_callero, _topicside, "CASOnTheWay", _channel];
sleep 1;
_logic1 kbTell [_logic, _topicside, "CASUnavailable", _channel];

private _callerpos = getPos _callero;

private _logico = d_HeliHEmpty createVehicleLocal [0,0,0];
_logico setPos _lpos;
__TRACE_1("","_logico")

private _posATL = getPosAtl _logico;
private _pos = +_posATL;
_pos set [2, (_pos select 2) + getTerrainheightasl _pos];
private _dir = _callerpos getDir _logico;

private _dis = 3000;
private _alt = 1000;
private _pitch = atan (_alt / _dis);
private _speed = 400 / 3.6;
private _duration = ([0,0] distance [_dis, _alt]) / _speed;

//--- Create plane
private _planePos = [_pos, _dis, _dir + 180] call bis_fnc_relpos;
_planePos set [2, (_pos select 2) + _alt];
([_planePos, _dir, _planeClass, (getNumber (_planeCfg>>"side")) call bis_fnc_sideType] call d_fnc_spawnVehicle) params ["_plane", "_crew", "_group"];
_plane setPosasl _planePos;
_plane move ([_pos,_dis,_dir] call bis_fnc_relpos);
_plane disableAi "move";
_plane disableAi "target";
_plane disableAi "autotarget";
_plane setCombatMode "blue";

private _vectorDir = [_planePos,_pos] call bis_fnc_vectorFromXtoY;
private _velocity = [_vectorDir,_speed] call bis_fnc_vectorMultiply;
_plane setVectordir _vectorDir;
[_plane,-90 + atan (_dis / _alt),0] call bis_fnc_setpitchbank;
private _vectorUp = vectorUp _plane;

//--- Remove all other weapons
private _currentWeapons = weapons _plane;
{
	if !(toLower ((_x call bis_fnc_itemType) select 1) in (_weaponTypes + ["countermeasureslauncher"])) then {
		_plane removeWeapon _x;
	};
	false
} count _currentWeapons;

_plane setVariable ["d_who_fired", _caller];
_plane addEventhandler ["fired", {
	params ["_vec"];
	private _whof = _vec getVariable "d_who_fired";
	if (!isNil "_whof") then {
		private _aop = missionNamespace getVariable _whof;
		if (!isNil "_aop" && {!isNull _aop}) then {
			_this select 6 setShotParents [_vec, _aop];
		};
	};
}];

private _enemy_units = [];

//--- Approach
private _fire = [] spawn {waitUntil {false}};
private _fireNull = true;
private _time = time;
private _offset = [0, 20] select ({_x == "missilelauncher"} count _weaponTypes > 0);
waitUntil {
	private _fireProgress = _plane getVariable ["fireProgress", 0];

	//--- Update plane position when module was moved / rotated
	if ((getPosatl _logico distance _posATL > 0 || {_callerpos getDir _logico != _dir}) && {_fireProgress == 0}) then {
		_posATL = getPosatl _logico;
		_pos = +_posATL;
		_pos set [2,(_pos select 2) + getTerrainheightasl _pos];
		_dir = _callerpos getDir _logico;

		_planePos = [_pos,_dis, _dir + 180] call bis_fnc_relpos;
		_planePos set [2, (_pos select 2) + _alt];
		_vectorDir = [_planePos, _pos] call bis_fnc_vectorFromXtoY;
		_velocity = [_vectorDir, _speed] call bis_fnc_vectorMultiply;
		_plane setVectordir _vectorDir;
		//[_plane,-90 + atan (_dis / _alt),0] call bis_fnc_setpitchbank;
		_vectorUp = vectorUp _plane;

		_plane move ([_pos,_dis, _dir] call bis_fnc_relpos);
	};

	//--- Set the plane approach vector
	_plane setVelocityTransformation [
		_planePos, [_pos select 0, _pos select 1, (_pos select 2) + _offset + _fireProgress * 12],
		_velocity, _velocity,
		_vectorDir, _vectorDir,
		_vectorUp, _vectorUp,
		(time - _time) / _duration
	];
	_plane setVelocity velocity _plane;

	//--- Fire!
	if (_fireNull && {(getPosAsl _plane) distance _pos < 1000}) then {
		_fireNull = false;
		terminate _fire;
		_fire = [_plane,_weapons] spawn {
			params ["_plane", "_weapons"];
			private _planeDriver = driver _plane;
			private _duration = 3;
			private _time = time + _duration;
			waitUntil {
				{
					//_plane selectweapon (_x select 0);
					_planeDriver forceWeaponfire _x;
					false
				} count _weapons;
				_plane setVariable ["fireProgress", (1 - ((_time - time) / _duration)) max 0 min 1];
				sleep 0.1;
				(time > _time || {isNull _plane || {!canMove _plane}})
			};
			sleep 1;
		};
	};

	sleep 0.01;
	(scriptDone _fire || {isNull _logico || {isNull _plane || {!canMove _plane}}})
};
_plane setVelocity velocity _plane;
_plane flyinHeight _alt;
if (!scriptDone _fire) then {
	terminate _fire;
};

if !(isNull _logico) then {
	sleep 1;
	deleteVehicle _logico;
	waitUntil {_plane distance _pos > _dis || {isNull _plane || {!canMove _plane}}};
};

//--- Delete plane
if (canMove _plane) then {
	deleteVehicle _plane;
	{deleteVehicle _x;false} count _crew;
	deleteGroup _group;
} else {
	[_plane, _crew, _group] spawn {
		params ["_plane", "_crew", "_group"];
		sleep 30;
		deleteVehicle _plane;
		{deleteVehicle _x;false} count _crew;
		deleteGroup _group;
	};
};

[_side, _logic1, _logic, _topicside, _channel] spawn {
	scriptName "spawn_cas_available";
	params ["_side", "_logic1", "_logic", "_topicside", "_channel"];
	sleep d_cas_available_time;
	d_cas_available = true; publicVariable "d_cas_available";
	remoteExecCall ["d_fnc_updatesupportrsc", [0, -2] select isDedicated];
	_logic1 kbTell [_logic, _topicside, "CASAvailable", _channel];
};
