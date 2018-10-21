//#define __DEBUG__
#define THIS_FILE "fn_sidedeliver.sqf"
#include "..\..\x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

params ["_spos","_epos","_sdir","_edir"];

if (isNil "d_sm_deliver_truck") then {
	d_sm_deliver_truck = ["B_Truck_01_Repair_F", "B_Truck_01_ammo_F", "B_Truck_01_fuel_F", "B_Truck_01_medical_F"];
};

/*private _hangar = createVehicle ["Land_TentHangar_V1_F", _spos, [], 0, "NONE"];
_hangar setDir _sdir;
_hangar setPos _spos;
d_x_sm_vec_rem_ar pushBack _hangar;
_spos = _hangar ModelToWorld [0,0,0];*/
private _vec = createVehicle [selectRandom d_sm_deliver_truck, _spos, [], 0, "NONE"];
_vec setDir (direction _hangar);
_vec setPos _spos;
_vec setDamage 0;
_vec addMPEventHandler ["MPKilled", {if (isServer) then {[param [0]] call d_fnc_sidempkilled}}];
clearWeaponCargoGlobal _vec;
clearMagazineCargoGlobal _vec;
clearBackpackCargoGlobal _vec;
clearItemCargoGlobal _vec;
_vec addItemCargoGlobal ["ToolKit",1];
_vec addItemCargoGlobal ["FirstAidKit",3];
d_x_sm_vec_rem_ar pushBack _vec;

private _hangar2 = createVehicle ["Land_TentHangar_V1_F", _epos, [], 0, "NONE"];
_hangar2 setDir _edir;
_hangar2 setPos _epos;
d_x_sm_vec_rem_ar pushBack _hangar2;

private _arrow = switch (d_own_side) do {
   case "WEST": {"Sign_Arrow_Large_Blue_F"};
   case "EAST": {"Sign_Arrow_Large_F"};
   case "GUER": {"Sign_Arrow_Large_F"};
};
private _arrowhead = _arrow createVehicle [0,0,0];
_arrowhead setPos [_epos select 0,_epos select 1, 15];
d_x_sm_vec_rem_ar pushBack _arrowhead;

sleep 2.123;
["specops", 2, "allmen", 4, [_epos, 100] call d_fnc_getranpointcircleouter, 200, true] spawn d_fnc_CreateInf;
sleep 2.123;
[selectRandom ["wheeled_apc", "jeep_gl", "jeep_mg"], 1, selectRandom ["tank", "tracked_apc"], 1, "aa", 1, [_epos, 150] call d_fnc_getranpointcircleouter, 1, 250, true] spawn d_fnc_CreateArmor;

sleep 10.213;

private _reached_base = false;

private _markern = format ["d_smvecposc_%1", _vec];

[_markern, [0, 0, 0], "ICON", "ColorBlue", [0.5, 0.5], localize "STR_DOM_MISSIONSTRING_1584" , 0, "mil_dot"] remoteExecCall ["d_fnc_CreateMarkerGlobal", 2];
	
while {alive _vec && {!_reached_base && {!d_sm_resolved}}} do {
	call d_fnc_mpcheck;
	_markern setMarkerPos (getPosWorld _vec);
	if (_vec distance2D _epos < 30) then {_reached_base = true;};
	sleep 5.2134;
};

if (!d_sm_resolved) then {
	if (alive _vec && {_reached_base}) then {
		d_sm_winner = 2;
	} else {
		d_sm_winner = -600;
	};
};

_markern remoteExecCall ["deleteMarker", 2];

d_sm_resolved = true;

if (d_IS_HC_CLIENT) then {
	[missionNamespace, ["d_sm_winner", d_sm_winner]] remoteExecCall ["setVariable", 2];
	[missionNamespace, ["d_sm_resolved", true]] remoteExecCall ["setVariable", 2];
};

sleep 2.123;

if (!isNull _vec && {alive _vec}) then {
	if !((crew _vec) isEqualTo []) then {
		{moveOut _x;false} count (crew _vec);
	};
	[_vec, true] remoteExecCall ["d_fnc_l_v", 2];
	[_vec, false] remoteExecCall ["engineOn", _vec];
};
