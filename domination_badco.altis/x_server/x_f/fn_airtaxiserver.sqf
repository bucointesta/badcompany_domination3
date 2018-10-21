// by Xeno
#define THIS_FILE "fn_airtaxiserver.sqf"
#include "..\..\x_setup.sqf"
#define __del \
{_vec deleteVehicleCrew _x;false} count _crew;\
deleteVehicle _vec;

if (!isServer) exitWith {};

d_heli_taxi_available = false;
publicVariable "d_heli_taxi_available";

sleep 5;

params ["_playerstr", "_playerpos"];

private _player = missionNamespace getVariable _playerstr;
if (isNil "_player" || {isNull _player}) exitWith {
	d_heli_taxi_available = true;
	publicVariable "d_heli_taxi_available";
	-1 remoteExecCall ["d_fnc_ataxiNet", [0, -2] select isDedicated];
};

7 remoteExecCall ["d_fnc_ataxiNet", _player];

private _sidep = side (group _player);

private _dstart_pos = call d_fnc_GetRanPointOuterAir;

private _grp = [_sidep] call d_fnc_creategroup;
private _spos = [_dstart_pos select 0, _dstart_pos select 1, 300];
private _veca = [_spos, _spos getDir _playerpos, d_taxi_aircraft, _grp, false] call d_fnc_spawnVehicle;
_grp deleteGroupWhenEmpty true;
_veca params ["_vec", "_crew"];
private _unit = driver _vec;
addToRemainsCollector [_vec];
_unit setSkill 1;

_vec lockDriver true;

{_x setCaptive true;false} count _crew;

private _pospl =+ _playerpos;
_pospl set [2,0];
private _helperh = d_HeliHEmpty createVehicleLocal [0,0,0];
_helperh setPos _pospl;
_vec flyInHeight 80;
_unit doMove _playerpos;
_vec flyInHeight 80;
_grp setBehaviour "CARELESS";
["d_airtaxi_marker", _vec, "ICON", (switch (_sidep) do {case opfor: {"ColorEAST"};case blufor: {"ColorWEST"};case independent: {"ColorGUER"};default {"ColorCIV"};}), [1,1], "Air Taxi", 0, (switch (_sidep) do {case blufor: {"b_air"};case opfor: {"o_air"};default {"n_air"};})] call d_fnc_CreateMarkerGlobal;

sleep 10;

_player = missionNamespace getVariable _playerstr;
if (isNil "_player" || {isNull _player}) exitWith {
	deleteMarker "d_airtaxi_marker";
	d_heli_taxi_available = true;
	publicVariable "d_heli_taxi_available";
	-1 remoteExecCall ["d_fnc_ataxiNet", [0, -2] select isDedicated];
	sleep 120;
	__del;
};

if (!alive _player) exitWith {
	d_heli_taxi_available = true;
	publicVariable "d_heli_taxi_available";
	deleteMarker "d_airtaxi_marker";
	1 remoteExecCall ["d_fnc_ataxiNet", _player];
	sleep 120;
	__del;
};

0 remoteExecCall ["d_fnc_ataxiNet", _player];

private _toldp = false;
private _endtime = time + 720;
private _doend = false;
while {alive _unit && {alive _vec && {canMove _vec}}} do {
	"d_airtaxi_marker" setMarkerPos (getPosWorld _vec);
	_player = missionNamespace getVariable _playerstr;
	if (time > _endtime || {isNil "_player" || {isNull _player}}) exitWith {
		_doend = true;
	};
	if (!_toldp && {_vec distance2D _helperh < 1000 && {alive _player}}) then {
		6 remoteExecCall ["d_fnc_ataxiNet", _player];
		_toldp = true;
	};
	if (unitReady _unit) exitWith {
		sleep 0.1;
		_vec land "LAND";
	};
	sleep 2.012;
};

if (!alive _unit || {!alive _vec || {!canMove _vec || {_doend}}}) exitWith {
	deleteMarker "d_airtaxi_marker";
	d_heli_taxi_available = true;
	publicVariable "d_heli_taxi_available";
	_player = missionNamespace getVariable _playerstr;
	if (!isNil "_player" && {!isNull _player}) then {
		2 remoteExecCall ["d_fnc_ataxiNet", _player];
	} else {
		-1 remoteExecCall ["d_fnc_ataxiNet", [0, -2] select isDedicated];
	};
	sleep 120;
	__del;
};

_endtime = time + 120;
"d_airtaxi_marker" setMarkerPos (getPosWorld _vec);
while {alive _unit && {alive _vec && {alive _player && {!(_player in crew _vec) && {canMove _vec}}}}} do {
	if (time > _endtime) exitWith {};
	sleep 1.012;
};
_doend = false;
if (alive _unit && {alive _vec && {canMove _vec}}) then {
	_player = missionNamespace getVariable _playerstr;
	if (!isNil "_player" && {!isNull _player}) then {
		3 remoteExecCall ["d_fnc_ataxiNet", _player];
	};
	
	sleep 30 + random 5;
	_player = missionNamespace getVariable _playerstr;
	if (!isNil "_player" && {!isNull _player}) then {
		5 remoteExecCall ["d_fnc_ataxiNet", _player];
	};
	_vec flyInHeight 80;
	_unit doMove (getPosATL d_AISPAWN);
	_vec flyInHeight 80;
	_grp setBehaviour "CARELESS";
	sleep 5;
	_doend = false;
	while {alive _unit && {alive _vec && {canMove _vec}}} do {
		"d_airtaxi_marker" setMarkerPos (getPosWorld _vec);
		if (unitReady _unit) exitWith {
			sleep 0.1;
			_vec land "LAND";
		};
		if (!alive _unit || {!alive _vec || {!canMove _vec}}) exitWith {
			_doend = true;
			_player = missionNamespace getVariable _playerstr;
			if (!isNil "_player" && {!isNull _player}) then {
				2 remoteExecCall ["d_fnc_ataxiNet", _player];
			};
			deleteMarker "d_airtaxi_marker";
			d_heli_taxi_available = true;
			publicVariable "d_heli_taxi_available";
			sleep 120;
			__del;
		};
		sleep 2.012
	};
	if (_doend) exitWith {};
	
	_endtime = time + 820;
	while {alive _unit && {alive _vec && {alive _player && {(_player in crew _vec) && {canMove _vec}}}}} do {
		sleep 3.221;
		if (time > _endtime) exitWith {};
	};
	sleep 20 + random 5;
	
	if (alive _unit && {alive _vec && {canMove _vec}}) then {
		_player = missionNamespace getVariable _playerstr;
		if (!isNil "_player" && {!isNull _player}) then {
			4 remoteExecCall ["d_fnc_ataxiNet", _player];
		};
		_vec flyInHeight 80;
		_unit doMove _dstart_pos;
		_vec flyInHeight 80;
		_grp setBehaviour "CARELESS";
		_endtime = time + 720;
		while {alive _unit && {alive _vec && {canMove _vec}}} do {
			"d_airtaxi_marker" setMarkerPos (getPosWorld _vec);
			if (_vec distance2D _dstart_pos < 300) exitWith {};
			if (time > _endtime) exitWith {};
			sleep 2.012
		};
		deleteMarker "d_airtaxi_marker";
		d_heli_taxi_available = true;
		publicVariable "d_heli_taxi_available";
		sleep 120;
		__del;
	} else {
		_player = missionNamespace getVariable _playerstr;
		if (!isNil "_player" && {!isNull _player}) then {
			1 remoteExecCall ["d_fnc_ataxiNet", _player];
		};
		deleteMarker "d_airtaxi_marker";
		d_heli_taxi_available = true;
		publicVariable "d_heli_taxi_available";
		sleep 120;
		__del;
	};
} else {
	_player = missionNamespace getVariable _playerstr;
	if (!isNil "_player" && {!isNull _player}) then {
		1 remoteExecCall ["d_fnc_ataxiNet", _player];
	};
	deleteMarker "d_airtaxi_marker";
	d_heli_taxi_available = true;
	publicVariable "d_heli_taxi_available";
	sleep 120;
	__del;
};

deleteVehicle _helperh;