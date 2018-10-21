// by Xeno
#define THIS_FILE "x_setupserver.sqf"
#include "..\x_setup.sqf"
if (!isServer) exitWith {};

private _confmapsize = if (worldName != "Chernarus_winter") then {getNumber(configFile>>"CfgWorlds">>worldName>>"mapSize")} else {15360};
d_island_center = [_confmapsize / 2, _confmapsize / 2, 300];

d_island_x_max = _confmapsize;
d_island_y_max = _confmapsize;

d_last_bonus_vec = "";

d_sm_triggervb = [
	[0, 0, 0],
	[0, 0, 0, false, 0],
	["NONE", "PRESENT", true],
	[
		"d_sm_resolved && {d_cur_sm_idx != -1}",
		"call d_fnc_SideMissionResolved",
		""
	]
] call d_fnc_createtriggerlocal;

if (d_with_ai) then {execVM "x_server\x_delaiserv.sqf"};

if (d_MissionType in [0,2]) then {
	0 spawn {
		scriptName "spawn_x_serversetup_startsm";
		sleep 20;
		if (d_MissionType != 2) then {
			private _waittime = 200 + random 10;
			private _num_p = call d_fnc_PlayersNumber;
			if (_num_p > 0) then {
				{
					if (_num_p <= (_x select 0)) exitWith {
						_waittime = (_x select 1) + random 10;
						false
					};
					false
				} count d_time_until_next_sidemission;
			};
			sleep _waittime;
		} else {
			sleep 15;
		};
		0 spawn d_fnc_getsidemission;
	};
};

d_air_bonus_vecs = 0;
d_land_bonus_vecs = 0;

{
	if (getText(configFile>>"CfgVehicles">>_x>>"vehicleClass") == "Air") then {
		d_air_bonus_vecs = d_air_bonus_vecs + 1;
	} else {
		d_land_bonus_vecs = d_land_bonus_vecs + 1;
	};
	false
} count d_sm_bonus_vehicle_array;
__TRACE_2("","d_air_bonus_vecs","d_land_bonus_vecs")

private _bpos =+ d_base_array select 0;
_bpos set [2, 1.9];
[_bpos, [d_base_array select 1, d_base_array select 2, d_base_array select 3, true, 2], [d_enemy_side, "PRESENT", true], ["'Man' countType thislist > 0 || {'Tank' countType thislist > 0 || {'Car' countType thislist > 0}}", "d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,'BaseUnderAtack',d_kbtel_chan]", ""]] call d_fnc_createtriggerlocal;

if (d_MissionType == 2) then {
	0 spawn {
		while {true} do {
			sleep 9;
			if (d_all_sm_res) exitWith {
				sleep 10;
				d_the_end = true; publicVariable "d_the_end";
				0 spawn d_fnc_DomEnd;
			};
		};
	};
};

0 spawn d_fnc_cleanerfnc;

diag_log ["Internal D Version: 3.74"];

private _avec_str = "d_artyvec_%1";

private _av_check_fnc = {
	_this addEventHandler ["handleDamage", {_this call d_fnc_pshootatarti;0}];
	_this lockDriver true;
	_this lock 2;
	
	if (!isNull (driver _this)) then {
		_this deleteVehicleCrew (driver _this);
		_this lockDriver true;
		_this lock 2;
	};
	
	{
		_x addEventHandler ["handleDamage", {0}];
		_x setCaptive true;
		false
	} count (crew _this);
	_this setPos [getPosASL _this select 0, getPosASL _this select 1, 0.5];
	_this addEventhandler ["fired", {
		params ["_vec"];
		private _whof = _vec getVariable "d_who_fired";
		if (!isNil "_whof") then {
			private _aop = missionNamespace getVariable _whof;
			if (!isNil "_aop" && {!isNull _aop}) then {
				_this select 6 setShotParents [_vec, _aop];
			};
		};
	}];
	_this spawn {
		sleep 2;
		_this enableSimulationGlobal false;
	};
};

for "_i" from 1 to 30 do {
	private _av = missionNamespace getVariable format [_avec_str, _i];
	if (!isNil "_av") then {
		_av call _av_check_fnc;
	};
};

//0 spawn d_fnc_sendfps;
