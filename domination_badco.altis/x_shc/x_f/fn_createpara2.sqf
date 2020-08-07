﻿// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_createpara2.sqf"
#include "..\..\x_setup.sqf"

if (!isServer) exitWith {};

#define __exitchop if (!alive _chopper || {!canMove _chopper || {!alive driver _chopper}}) exitWith {[_crew_vec, _chopper,240 + random 100] spawn _delveccrew}

params ["_vgrp", "_chopper", "_helifirstpoint", "_heliendpoint"];
private _crew_vec = crew _chopper;

sleep 2.123;

private _wp = _vgrp addWaypoint [_helifirstpoint, 30];
_wp setWaypointBehaviour "CARELESS";
_wp setWaypointSpeed "NORMAL";
_wp setwaypointtype "MOVE";
_wp setWaypointFormation "WEDGE";

private _wp2 = _vgrp addWaypoint [_heliendpoint, 0];
_wp2 setwaypointtype "MOVE";
_wp2 setWaypointBehaviour "CARELESS";
_wp2 setWaypointSpeed "NORMAL";
_wp2 setwaypointtype "MOVE";

_chopper flyinheight 100;

#ifndef __TT__
if (d_searchintel # 6 == 1) then {
	d_kb_logic1 kbTell [d_kb_logic2, d_kb_topic_side, "TellInfiltrateAttack", d_kbtel_chan];
};
#endif

private _delveccrew = {
	params ["_crew_vec", "_vec", "_time"];
	sleep _time;
	{_x setDamage 1} forEach (_crew_vec select {!isNull _x});
	sleep 1;
	if (!isNull _vec && {({_x call d_fnc_isplayer} count (crew _vec)) == 0}) then {_vec setDamage 1};
};

while {_helifirstpoint distance2D (leader _vgrp) > 300} do {
	__exitchop;
	sleep 2.123;
};

if (alive _chopper && {canMove _chopper && {alive driver _chopper}}) then {
	private _subskill = if (diag_fps > 29) then {
		(0.1 + (random 0.2))
	} else {
		(0.12 + (random 0.04))
	};
	private _real_units = ["sabotage", d_enemy_side_short] call d_fnc_getunitlistm;
	if (count _real_units < 6) then {
		while {count _real_units < 6} do {
			_real_units pushBack (selectRandom _real_units);
		};
	};
	private _paragrp = [d_side_enemy] call d_fnc_creategroup;
	{
		private _pposcx = getPosATL _chopper;
		_one_unit = _paragrp createUnit [_x, [_pposcx # 0, _pposcx # 1, 0], [], 0,"NONE"];
		if (Hz_customUnitLoadouts) then {
			_one_unit call AI_setupUnitCustomLoadout;
		};
		_one_unit addEventHandler ["HandleDamage",{
			_return = _this select 2;
			_source = _this select 3;
			_unit = _this select 0;		
			if (((_this select 4) == "") && {(isnull _source) || {((side _source) getFriend (side _unit)) >= 0.6}}) then {
				_return = 0;
			};
			_return 
		}];
		[_one_unit] joinSilent _paragrp;
		
		private _para = createVehicle [d_non_steer_para, _pposcx, [], 20, "NONE"];
		_one_unit moveInDriver _para;
		_para setDir random 360;
		_pposcx = getPosATL _chopper;
		_para setPos [_pposcx # 0, _pposcx # 1, (_pposcx # 2) - 10];
		_one_unit call d_fnc_removenvgoggles_fak;
		
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
		sleep 0.551;
	} forEach _real_units;
	_paragrp allowFleeing 0;
	_paragrp setCombatMode "YELLOW";
	_paragrp setBehaviour "STEALTH";
	
	sleep 0.113;
	_paragrp spawn {
		private "_grp";
		_grp = _this;
		sleep 20;
		if ((units _grp) findIf {alive _x} > -1) then {
			[_grp, d_base_array # 0, [d_base_array # 0, d_base_array # 1, d_base_array # 2, d_base_array # 3]] spawn d_fnc_MakePatrolWPX;
			_grp setVariable ["d_PATR", true];
		};
	};
	sleep 0.112;
	[_paragrp] spawn d_fnc_sabotage;
};

__exitchop;

while {(_heliendpoint distance2D (leader _vgrp) > 300)} do {
	__exitchop;
	sleep 5.123;
};

if (!isNull _chopper) then {_chopper call d_fnc_DelVecAndCrew};