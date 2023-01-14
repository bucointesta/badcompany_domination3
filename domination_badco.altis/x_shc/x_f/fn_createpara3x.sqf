// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_createpara3x.sqf"
#include "..\..\x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

params ["_startpoint", "_attackpoint", "_flytopos", "_heliendpoint", "_number_vehicles"];
__TRACE_3("","_startpoint","_attackpoint","_heliendpoint")
__TRACE_2("","_number_vehicles","_flytopos")

d_should_be_there = _number_vehicles;

d_c_attacking_grps = [];

private _delveccrew = {
	scriptName "spawn_x_createpara3_delveccrew";
	params ["_crew_vec", "_vec", "_time"];
	sleep _time;
	{_x setDamage 1} forEach (_crew_vec select {!isNull _x});
	sleep 1;
	if (!isNull _vec) then {_vec setDamage 1};
};

private _make_jump = {
	scriptName "spawn_x_createpara3_make_jump";
	params ["_vgrp", "_vec", "_attackpoint", "_flytopos", "_heliendpoint", "_delveccrew", "_crew_vec"];
	
	__TRACE("_make_jump")
	
	private _startpos = getPosATL _vec;
	private _driver_vec = driver _vec;
	
	if (_vec isKindOf "Plane") then {_flytopos = _attackpoint} else {_flytopos set [2, 80]};
	
	_heliendpoint set [2, 80];
	_attackpoint set [2, 0];
	
	sleep 10;
	
	private _wp = _vgrp addWaypoint [_flytopos, 0];
	_wp setWaypointBehaviour "CARELESS";
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointtype "MOVE";
	_wp setWaypointFormation "VEE";
	_wp setWaypointForceBehaviour true;
	_wp = _vgrp addWaypoint [_heliendpoint, 0];
	_wp setWaypointBehaviour "CARELESS";
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointtype "MOVE";
	_wp setWaypointFormation "VEE";
	_wp setWaypointForceBehaviour true;
	
	_vec flyInHeight 100;
	
	sleep 10.0231;
	
	_vec doMove _flytopos;
	[_vec, _flytopos] spawn {
		params ["_vec", "_flytopos"];
		sleep 30;
		_vec doMove _flytopos;
		sleep 30;
		_vec doMove _flytopos;
	};
	
	sleep 5;
	
	private _stop_me = false;
	private _checktime = time + 300;
	//Hunter: Increased distance from DZ because #armaAI.... (was 300)
	while {_posLead = getPosASL (leader _vgrp); (_flytopos distance2D _posLead > 1900) || {surfaceIsWater _posLead}} do {
		if (!alive _vec || {!alive _driver_vec || {((getposATL _vec) select 2) < 20}}) exitWith {d_should_be_there = d_should_be_there - 1};
		sleep 0.01;
		// Hunter: let them come :)
		/*
		if (d_mt_radio_down && {_attackpoint distance2D (leader _vgrp) > 10000}) exitWith {
			[_crew_vec, _vec, 1 + random 1] spawn _delveccrew;
			_stop_me = true;
		};
		*/
		sleep 0.01;
		if (time > _checktime) then {
			if (_startpos distance2D _vec < 500) then {
				d_should_be_there = d_should_be_there - 1;
				[_crew_vec, _vec, 1 + random 1] spawn _delveccrew;
				_stop_me = true;
			} else {
				_checktime = time + 9999999;
			};
		};
		if (_stop_me) exitWith {};
		sleep 2.023;
	};
	if (_stop_me) exitWith {};
	
	sleep 0.534;
	
	if (alive _vec && {alive _driver_vec && {((getposATL _vec) select 2) > 20}}) then {
	
		private _paragrp = [d_side_enemy] call d_fnc_creategroup;
		private _real_units = ["allmen", d_enemy_side_short] call d_fnc_getunitlistm;
		//Hunter: get full capacity of chopper and decide unit count from there...
		_chopperCap = _vec emptyPositions "Cargo";
		if (count _real_units < _chopperCap) then {
			while {count _real_units < _chopperCap} do {
				sleep 0.1;
				_real_units = _real_units + (["allmen", d_enemy_side_short] call d_fnc_getunitlistm);
			};
		} else {
			sleep 0.1;
		};
		private _subskill = if (diag_fps > 29) then {
			(0.1 + (random 0.2))
		} else {
			(0.12 + (random 0.04))
		};
		private _sleeptime = [0.551, 0.15] select (speed _vec > 80);
		{
			if (_foreachIndex == _chopperCap) exitWith {};
			private _pposcx = getPosATL _vec;
			private _one_unit = _paragrp createUnit [_x, [_pposcx # 0, _pposcx # 1, 0], [], 0,"NONE"];
			if (Hz_customUnitLoadouts) then {
				_one_unit call AI_setupUnitCustomLoadout;
			};
			_one_unit addEventHandler ["HandleDamage",{
				_return = _this select 2;
				_source = _this select 3;
				_unit = _this select 0;
				_selection = _this select 1;
				if (((_this select 4) == "") && {(isnull _source) || {((side _source) getFriend (side _unit)) >= 0.6}}) then {
					if (_selection isEqualTo "") then {
						_return = damage _unit;
					} else {
						_return = _unit getHit _selection;
					};
				};
				_return 
			}];
			[_one_unit] joinSilent _paragrp;
			__TRACE_1("","_one_unit")
			private _para = createVehicle [d_non_steer_para, _pposcx, [], 20, "NONE"];
			_one_unit moveInDriver _para;
			_para setDir random 360;
			_pposcx = getPosATL _vec;
			_para setPos [_pposcx # 0, _pposcx # 1, (_pposcx # 2) - 10];
			_one_unit call d_fnc_removenvgoggles_fak;
#ifdef __TT__
			_one_unit addEventHandler ["killed", {[[15, 3, 2, 1], _this # 1, _this # 0] remoteExecCall ["d_fnc_AddKills", 2]}];
#endif
			if (d_with_ai && {d_with_ranked}) then {
				_one_unit addEventHandler ["Killed", {
					[1, _this select 1] remoteExecCall ["d_fnc_addkillsai", 2];
					(_this select 0) removeAllEventHandlers "Killed";
				}];
			};
			/*
			_one_unit setUnitAbility ((d_skill_array # 0) + (random (d_skill_array # 1)));
			_one_unit setSkill ["aimingAccuracy", _subskill];
			_one_unit setSkill ["spotTime", _subskill];
			*/				
			_one_unit call AI_setSkill;
			
			d_delinfsm  pushBack _one_unit;
			sleep _sleeptime;
			if (!alive _vec) exitWith {};
		} forEach _real_units;
		_paragrp deleteGroupWhenEmpty true;
		__TRACE_1("","_real_units")
#ifndef __TT__
		(units _paragrp) remoteExecCall ["d_fnc_addceo", 2];
#endif
		_paragrp allowFleeing 0;
		_paragrp setFormation "WEDGE";
		
		private _grpTarget = [];
		
		if (!d_mt_radio_down) then {
			_grpTarget = markerpos "d_main_target_radiotower";
		} else {
			if (!d_mt_mobile_hq_down) then {
				_grpTarget = getpos d_mt_mobile_hq_obj;
			} else {
			
				[_paragrp, d_cur_tgt_pos, d_cur_target_radius] spawn {
					scriptName "spawn_x_createpara3_usegroup";
					params ["_grp", "_pos"];
					sleep 40;
					if ((units _grp) findIf {alive _x} > -1) then {
						[_grp, _pos, [_pos, _this select 2], [10, 20, 50], "", 0] spawn d_fnc_MakePatrolWPX;
						_grp setVariable ["d_PATR", true];
						if (d_with_dynsim == 0) then {
							_grp enableDynamicSimulation true;
						};
					};
				};
			
			};
		
		};
		
		if ((count _grpTarget) > 0) then {
			
			private _wpTroops = _paragrp addWaypoint [_grpTarget, 10];
			_wpTroops setWaypointType "MOVE";
			_wpTroops setWaypointSpeed "FULL";
			_wpTroops setWaypointBehaviour "AWARE";
			_wpTroops setWaypointCombatMode "GREEN";
			_wpTroops setWaypointStatements ["true", "if (local this) then {(group this) setBehaviour 'COMBAT'; (group this) setCombatMode 'RED'; (group this) setVariable ['d_PATR', true]; [group this, d_cur_tgt_pos, [d_cur_tgt_pos, d_cur_target_radius], [10, 20, 50], '', 0] spawn d_fnc_MakePatrolWPX; {_x forceSpeed -1; _x setUnitPos 'AUTO'; _x enableAI 'AUTOCOMBAT';} foreach thisList;};"];
			_paragrp setCurrentWaypoint _wpTroops;
			
			{
				_x forceSpeed 20;
				_x setUnitPosWeak "MIDDLE";
				_x disableAI "AUTOCOMBAT";
			} forEach (units _paragrp);
			
			_paragrp setCombatMode "GREEN";
			_paragrp setBehaviour "AWARE";
			
		};
		
		d_c_attacking_grps pushBack _paragrp;
		
		sleep 0.112;
		d_should_be_there = d_should_be_there - 1;
		
		_vec doMove _heliendpoint;
		_vec flyInHeight 100;
		
		while {_heliendpoint distance2D (leader _vgrp) > 1000} do {
			if (!alive _vec || {!alive _driver_vec || {!canMove _vec}}) exitWith {};
			sleep 5.123;
		};
		
		if (!isNull _vec && {_heliendpoint distance2D _vec > 1000}) then {
			[_crew_vec, _vec, 60 + random 60] spawn _delveccrew;
		} else {
			_vec call d_fnc_DelVecAndCrew;
		};
		if (!isNull _driver_vec) then {_driver_vec setDamage 1};
		
	} else {
		[_crew_vec, _vec, 60 + random 60] spawn _delveccrew;
	};
};

private _cur_tgt_pos =+ d_cur_tgt_pos;
private _stop_it = false;

if (d_searchintel # 0 == 1) then {
	[43] remoteExecCall ["d_fnc_DoKBMsg", 2];
};

private _flyToHeight = _flytopos select 2;
for "_i" from 1 to _number_vehicles do {
	if (d_mt_radio_down) exitWith {_stop_it = true};
	if (d_cur_tgt_pos distance2D _cur_tgt_pos > 500) exitWith {_stop_it = true};
	private _vgrp = [d_side_enemy] call d_fnc_creategroup;
	private _heli_type = selectRandom d_transport_chopper;
	private _spos = [(_startpoint # 0) + (random 500), (_startpoint # 1) + (random 500), 300];
	([_spos, _spos getDir _attackpoint, _heli_type, _vgrp] call d_fnc_spawnVehicle) params ["_vec", "_crew"];
	addToRemainsCollector [_vec];
	_vec remoteExec ["d_fnc_airmarkermove", 2];

	_vec lock true;
	
	_vgrp deleteGroupWhenEmpty true;

	sleep 5.012;
	
	_vec flyInHeight 100;

	if (d_mt_radio_down) exitWith {
		_stop_it = true;
		{_vec deleteVehicleCrew _x} forEach (crew _vec);
		deleteVehicle _vec;
	};
	
	[_vgrp, _vec, _attackpoint, _flytopos, _heliendpoint, _delveccrew, _crew] spawn _make_jump;
	// Hunter: make following choppers drop further
	_attackpoint = [_attackpoint, 400, ([_startpoint,_attackpoint] call bis_fnc_dirto)] call BIS_fnc_relPos;
	_flytopos = _startpoint getPos [(_startpoint distance2D _attackpoint) + 1500, _startpoint getDir _attackpoint];
	_flytopos set [2, _flyToHeight];
	
	//Hunter: no need to wait so much
	//sleep 30 + random 30;
	sleep 20;
};

if (_stop_it) exitWith {};

while {d_should_be_there > 0 && {!d_mt_radio_down}} do {sleep 1.021};

if (!d_mt_radio_down) then {
	sleep 20.0123;
	if !(d_c_attacking_grps isEqualTo []) then {
		[d_c_attacking_grps] spawn d_fnc_handleattackgroups;
	} else {
		d_c_attacking_grps = [];
		d_create_new_paras = true;
	};
};