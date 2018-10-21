// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_cleanerfnc.sqf"
#include "..\..\x_setup.sqf"

while {true} do {
	sleep (300 + random 150);
	// TODO How to improve this? Means how to improve cleanup? AllmissionObjects is not the fastest engine command...
	private _allmisobjs = allMissionObjects "groundWeaponHolder";
	sleep 4;
	private _helperx = allMissionObjects "WeaponHolder";
	if !(_helperx isEqualTo []) then {
		_allmisobjs append _helperx;
	};
	sleep 4;
	//_helperx = allMissionObjects "WeaponHolderSimulated";
	_helperx = entities "WeaponHolderSimulated";
	if !(_helperx isEqualTo []) then {
		_allmisobjs append _helperx;
	};
	sleep 4;
	_helperx = allMissionObjects "WeaponHolder_Single_F";
	if !(_helperx isEqualTo []) then {
		_allmisobjs append _helperx;
	};
	sleep 4;
	_helperx = allMissionObjects "Chemlight_green";
	if !(_helperx isEqualTo []) then {
		_allmisobjs append _helperx;
	};
	sleep 4;
	_helperx = allMissionObjects "Chemlight_red";
	if !(_helperx isEqualTo []) then {
		_allmisobjs append _helperx;
	};
	sleep 4;
	_helperx = allMissionObjects "Chemlight_yellow";
	if !(_helperx isEqualTo []) then {
		_allmisobjs append _helperx;
	};
	sleep 4;
	_helperx = allMissionObjects "Chemlight_blue";
	if !(_helperx isEqualTo []) then {
		_allmisobjs append _helperx;
	};
	sleep 4;
/*	_helperx = allMissionObjects "CraterLong";
	if !(_helperx isEqualTo []) then {
		_allmisobjs append _helperx;
	};
	sleep 4;
	_helperx = allMissionObjects "CraterLong_small";
	if !(_helperx isEqualTo []) then {
		_allmisobjs append _helperx;
	};
*/
	if !(_allmisobjs isEqualTo []) then {
		{
			if (_x inArea "d_base_marker") then {
				deleteVehicle _x;
			} else {
				if ({isPlayer _x} count (_x nearEntities ["CAManBase", 50]) == 0) then {
					deleteVehicle _x;
				};
			};
			sleep 0.212;
		} forEach (_allmisobjs select {!isNull _x});
	};
	_allmisobjs = nil;
	sleep 3;
	if (!isNil "d_player_created") then {
		{
			private _hastime = _x getVariable "d_end_time";
			if (!isNil "_hastime" && {time > _hastime}) then {
				if ({alive _x} count (crew _x) == 0) then {
					deleteVehicle _x;
				} else {
					if ({isPlayer _x} count (crew _x) > 0) then {
						_x setVariable ["d_end_time", time + 600];
					};
				};
			};
			false
		} count (d_player_created select {!isNull _x});
		d_player_created = d_player_created - [objNull];
	};
};