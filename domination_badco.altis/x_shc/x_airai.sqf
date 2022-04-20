// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_airai.sqf"
#include "..\x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

__TRACE("airai")

params ["_type"];

#define __wp_behave "COMBAT"

while {true} do {

	private _numberFnc = {};
	switch (_type) do {
		case "AH": {
			_numberFnc = d_number_attack_choppers;
		};
		case "CAP": {
			_numberFnc = d_number_CAP_planes;
		};
		case "CAS": {
			_numberFnc = d_number_attack_planes;
		};
	};

	#ifndef __DEBUG__
		waitUntil {
			sleep 11.32;
			(!d_mt_radio_down) && {d_mt_spotted} && {(call _numberFnc) > 0}
		};
	#endif
	private _vec = objNull;
	private _vehicles = [];
	private _funits = [];

	while {d_mt_radio_down} do {sleep 6.123};
	private _pos = call d_fnc_GetRanPointOuterAir;
	if !(d_cur_tgt_pos isEqualTo []) then {
		private _counter = 0;
		while {_dist = _pos distance2D d_cur_tgt_pos; ((_dist < 2000) || {_dist > (_pos distance2D (markerpos "d_base_marker"))}) && {_counter < 100}} do {
			_pos = call d_fnc_GetRanPointOuterAir;
			_counter = _counter + 1;
		};
	};
	
	private _grpskill = 0.6 + (random 0.3);
	__TRACE_2("","_pos","_grpskill")

	private _grp = [d_side_enemy] call d_fnc_creategroup;
	__TRACE_1("","_grp")
	private _heli_type = "";
	private _numair = 0;
	switch (_type) do {
		case "AH": {
			_heli_type = selectRandom d_airai_attack_chopper;
			_numair = call d_number_attack_choppers;
		};
		case "CAP": {
			_heli_type = selectRandom d_airai_CAP_plane;
			_numair = call d_number_CAP_planes;
		};
		case "CAS": {
			_heli_type = selectRandom d_airai_attack_plane;
			_numair = call d_number_attack_planes;
		};
	};
	
	__TRACE_2("","_heli_type","_numair")

	waitUntil {sleep 0.323; d_current_target_index >= 0};
	private _cdir = _pos getDir d_island_center;
#ifndef __TT__
	switch (_type) do {
		case "CAP": {if (d_searchintel # 1 == 1) then {[0] remoteExecCall ["d_fnc_DoKBMsg", 2]}};
		case "AH": {if (d_searchintel # 2 == 1) then {[1] remoteExecCall ["d_fnc_DoKBMsg", 2]}};
		case "CAS": {if (d_searchintel # 3 == 1) then {[2] remoteExecCall ["d_fnc_DoKBMsg", 2]}};
	};
#endif
	
	for "_xxx" from 1 to _numair do {
		private _randPos = [(_pos # 0) + (random 500), (_pos # 1) + (random 500), 400];
		private _vec_array = [_randPos, _cdir, _heli_type, _grp] call d_fnc_spawnVehicle;
		__TRACE_1("","_vec_array")
		
		 _vec_array params ["_vec"];
		_vec setPos _randPos;
		_vehicles pushBack _vec;
		__TRACE_1("","_vehicles")
		
		_funits append (_vec_array # 1);
		__TRACE_1("","_funits")

		addToRemainsCollector [_vec];
		
		if (d_LockAir == 0) then {_vec lock true};
		//_vec flyInHeight 100;
		switch (_type) do {
		case "CAP": {_vec flyInHeight 1000;};
		case "AH": {_vec flyInHeight 250;};
		case "CAS": {_vec flyInHeight 500;};
		};		
		_vec setSkill 1;
		{
			_x setSkill 1;
		} foreach crew _vec;

		_vec remoteExec ["d_fnc_airmarkermove", 2];
		__TRACE_1("","_vec")
		sleep 0.1;
	};
	_grp deleteGroupWhenEmpty true;
	
	//(leader _grp) setSkill _grpskill;
	
	sleep 1.011;
	
	//_grp allowFleeing 0;
	
	_grp setCombatMode "GREEN";
	_grp setBehaviour "CARELESS";
	
	waitUntil {sleep 0.323; d_current_target_index >= 0};
	private _cur_tgt_pos =+ d_cur_tgt_pos;
	private _lastTargetIndex = -1;
	_cur_tgt_pos set [2, 250];
	
	sleep 10;
	private _wp = _grp addWayPoint [_cur_tgt_pos, 250];
	_wp setWaypointType "MOVE";
	private _pat_pos =+ _cur_tgt_pos;
	[_grp, 1] setWaypointStatements ["never", ""];
	_wp setWaypointCompletionRadius 250;
	private _old_pos = getPosASL vehicle leader _grp;		
	sleep 10;
	
	if (_type == "AH") then {
		// arma 3's move problems...
		{
			_x doMove _cur_tgt_pos;
			sleep 3;
			/*
			_vehicle = _x;
			isNil {							
				_agent = calculatePath [typeof _vehicle,"CARELESS",getposatl _vehicle, _cur_tgt_pos];
				_agent setVariable ["veh",_vehicle];
				_agent addEventHandler ["PathCalculated", {
					_agent = _this select 0;
					// prevent from EH firing twice? TODO: confirm it works...
					if ((isNull _agent) || {_agent getVariable ["pathCalculated", false]}) exitWith {};
					_agent setVariable ["pathCalculated", true];
					_path = [];
					{
						_path pushBack [_x select 0, _x select 1, 250];
					} foreach (_this select 1);
					(_agent getVariable "veh") setDriveOnPath _path;	
					
					_vehAgent = vehicle _agent;
					if (_vehAgent == _agent) then {							
						deletevehicle _agent;							
					} else {							
						{_vehAgent deleteVehicleCrew _x} foreach crew _vehAgent;							
					};											
					deleteVehicle _vehAgent;
				}];
				
				_agent spawn {										
					sleep 55;			
					if (diag_fps < 25) then {
						sleep 90;
					};
					if (!isNull _this) then {
						_vehAgent = vehicle _this;
						if (_vehAgent == _this) then {							
							deletevehicle _this;							
						} else {							
							{_vehAgent deleteVehicleCrew _x} foreach crew _vehAgent;							
						};											
						deleteVehicle _vehAgent;											
					};																				
				};
				
			};
			*/
		} foreach _vehicles;
		sleep 30;	
		{
			_x doMove _cur_tgt_pos;
			sleep 3;
		} foreach _vehicles;
		sleep 30;
		{
			_x doMove _cur_tgt_pos;
			sleep 3;
		} foreach _vehicles;
		sleep 30;
		
	} else {
		sleep 10;
	};
	
	_radius = 1500;
	
	while {true} do {
		waitUntil {sleep 0.323; d_current_target_index >= 0};
		
		if (_lastTargetIndex != d_current_target_index) then {
			_lastTargetIndex = d_current_target_index;
			_cur_tgt_pos =+ d_cur_tgt_pos;
			_cur_tgt_pos set [2, 250];
			private _radius = switch (_type) do {
				case "AH": {2500};
				case "CAS": {4000};
				case "CAP": {7000};
				default {1500};
			};		
			
			__TRACE_1("","_radius")
			
		};
		
#define __patternpos \
_pat_pos = _cur_tgt_pos getPos [random 1000, random 360]; \
_pat_pos set [2, _cur_tgt_pos select 2]


#ifdef __DEBUG__
	_xdist = (_vehicles # 0) distance2D _cur_tgt_pos;
	__TRACE_1("","_xdist")
#endif
		_curvec = objNull;
		private _mmvevs = _vehicles select {alive _x && {canMove _x}};
		if !(_mmvevs isEqualTo []) then {
			_curvec = vehicle leader _grp;
		};
		
		__TRACE_1("","_curvec")
		__TRACE_1("","_old_pos")
		
		_outsideRadius = true;		
		{
			if (_x distance2D _cur_tgt_pos < _radius) exitWith {
				_outsideRadius = false;
			};
		}foreach _mmvevs;
		
		_playerVehs = [];
		{
			_vehPlayer = vehicle _x;
			if (!(_vehPlayer in _playerVehs)) then {
				_playerVehs pushBack _vehPlayer;
				if ((_vehPlayer isKindOf "Air") || {(_type != "CAP") && {!captive _vehPlayer} && {(_vehPlayer isKindOf "StaticWeapon") || {(_vehPlayer distance2D _cur_tgt_pos) < _radius}}}) then {
					_grp reveal [_vehPlayer, 4];
				};
			};
		}foreach playableUnits;
		
		if ((count _playerVehs) > 0) then {
			_grp setCombatMode "RED";
			_grp setBehaviour "COMBAT";
			{
				if (isNull assignedTarget _x) then {
					_x doTarget (selectRandom _playerVehs);
				};
			} foreach _mmvevs;
			sleep 15;
		} else {
			_grp setCombatMode "YELLOW";
			_grp setBehaviour "AWARE";
		};
		
		//stuck or moved out of AO?
		_notMoved = false;
		if (!isNull _curvec && {_outsideRadius || {_notMoved = (_curvec distance2D _old_pos) < 30; _notMoved}}) then {
									
			if (_type == "AH") then {
			
				_vecTarget = assignedTarget _curvec;
			
				if ((!isNull _vecTarget) && {(speed _curvec) > 10} && {(_vecTarget distance2D _cur_tgt_pos) < _radius}) exitWith {			
					_old_pos = getPosASL _curvec;
					sleep 5;
				};
				
				_curvec doWatch objNull;
				_grp forgetTarget _vecTarget;
				_grp setCombatMode "GREEN";
				_grp setBehaviour "CARELESS";
			
				private _tmp_pos = _pat_pos;
				__patternpos;
				while {_pat_pos distance2D _tmp_pos < 250} do {
					__patternpos;
					sleep 0.01;
				};
				_pat_pos = _pat_pos call d_fnc_WorldBoundsCheck;
				__TRACE_1("HACLAC","_pat_pos")
				[_grp, 1] setWaypointPosition [_pat_pos, 250];
				_grp setSpeedMode "NORMAL";
				_old_pos = getPosASL _curvec;
				{
					_x flyInHeight 250;
					if (_notMoved) then {
						//unstuck them...
						dostop _x;
						sleep 1;
						_x domove ([_x, 500 + random 100, ([_x, _pat_pos] call BIS_fnc_dirTo)] call BIS_fnc_relPos);	
					};
				} forEach _mmvevs;
				//sleep 35.821 + random 15;
				sleep 15;
			} else {
				
				_vecTarget = assignedTarget _curvec;
			
				if ((!isNull _vecTarget) && {(_vecTarget iskindof "Air") || {(_type == "CAS") && {(_vecTarget distance2D _cur_tgt_pos) < _radius}}}) exitWith {		
					_old_pos = getPosASL _curvec;
					sleep 5;
				};
				
				_curvec doWatch objNull;
				_grp forgetTarget _vecTarget;
				_grp setCombatMode "GREEN";
				_grp setBehaviour "CARELESS";
				
				__patternpos;
				_pat_pos = _pat_pos call d_fnc_WorldBoundsCheck;
				__TRACE_1("plane","_pat_pos")
				[_grp, 1] setWaypointPosition [_pat_pos, 500];
				_grp setSpeedMode "NORMAL";
				_old_pos = getPosASL _curvec;
				{
					if (_type == "CAS") then {					
						_x flyInHeight 500;					
					} else {					
						_x flyInHeight 1000;				
					};
					if (_notMoved) then {
						//unstuck them...
						dostop _x;
						sleep 1;
						_x domove ([_x, 1000 + random 100, ([_x, _pat_pos] call BIS_fnc_dirTo)] call BIS_fnc_relPos);						
					};
				} forEach _mmvevs;
				//sleep 80 + random 80;
				sleep 15;			
			};
		} else {
		
			_old_pos = getPosASL _curvec;
			sleep 5;
		
		};
		
		if (_notMoved) then {
			sleep 60;
		};
		
		if !(_vehicles isEqualTo []) then {
			__TRACE("_vehicles array not empty")
			{
				if (isNull _x || {!alive _x || {!canMove _x}}) then {
					__TRACE_1("not alive","_x")
					if (!isNull _x && {!canMove _x}) then {
						_x spawn {
							__TRACE("deleting airai vehicle")
							scriptName "spawn_x_airai_delvec1";
							private _vec = _this;
							sleep 200;
							if (alive _vec && {canMove _vec}) exitWith {};
							if (!isNull _vec) then {_vec call d_fnc_DelVecAndCrew};
						};
					};
					_vehicles set [_forEachIndex, -1];
				} else {
					_x setFuel 1;
					_x setVehicleAmmoDef 1;
				};
			} forEach _vehicles;
			_vehicles = _vehicles - [-1];
		};
		if (_vehicles isEqualTo []) exitWith {
			__TRACE("_vehicles array IS empty")
			{deleteVehicle _x} forEach _funits;
			_funits = [];
			_vehicles = [];
		};
	};
#ifndef __DEBUG__
	/*
	_num_p = call d_fnc_PlayersNumber;
	private _re_random = call {
		if (_num_p < 5) exitWith {2700};
		if (_num_p < 10) exitWith {1200};
		if (_num_p < 25) exitWith {600};
		300;
	};
	sleep (d_airai_respawntime + _re_random + (random _re_random));
	*/
	
	private _sleepTime = 0;
	switch (_type) do {
		case "AH": {
			_sleepTime = call d_airai_AHrespawntime;
		};
		case "CAP": {
			_sleepTime = call d_airai_CASrespawntime;
		};
		case "CAS": {
			_sleepTime = call d_airai_CAPrespawntime;
		};
	};
	
	sleep _sleepTime;
	
#else
	sleep 10;
#endif
};
