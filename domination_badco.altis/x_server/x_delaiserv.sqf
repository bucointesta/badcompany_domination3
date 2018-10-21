// by Xeno
#define THIS_FILE "x_delaiserv.sqf"
#include "..\x_setup.sqf"

if (!isServer) exitWith {};

sleep 60;

while {true} do {
	call d_fnc_mpcheck;
	{
		if (!isNull _x) then {
			private _group = _x;
			if ({isPlayer _x} count (units _group) == 0 /*&& {isNull (d_player_groups_lead select _forEachIndex)}*/) then { // disabled for now
				{
					if (!isNull (objectParent _x)) then {
						(objectParent _x) deleteVehicleCrew _x;
					} else {
						deleteVehicle _x;
					};
					false
				} count ((units _group) select {!isPlayer _x});
				d_player_groups set [_forEachIndex, grpNull];
				d_player_groups_lead set [_forEachIndex, -1];
			};
		} else {
			d_player_groups set [_forEachIndex, grpNull];
			d_player_groups_lead set [_forEachIndex, -1];
		};
	} forEach d_player_groups;
	d_player_groups = d_player_groups - [grpNull, objNull];
	d_player_groups_lead = d_player_groups_lead - [-1];
	sleep 10.321;
};