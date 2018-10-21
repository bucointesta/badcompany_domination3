// by Xeno
#define THIS_FILE "fn_clean_craters.sqf"
#include "..\..\x_setup.sqf"

{
	deleteVehicle _x;
	sleep 0.212;
} forEach (allMissionObjects "CraterLong" + allMissionObjects "CraterLong_small");

if (!isNil "d_airboxes" && {!(d_airboxes isEqualTo [])}) then {
	{
		if (time > _x getVariable ["d_airboxtime", -1]) then {
			deleteVehicle _x;
		};
		false
	} count d_airboxes;
	d_airboxes = d_airboxes - [objNull];
};

["itemAdd", ["dom_clean_craters", {["itemRemove", ["dom_clean_craters"]] call bis_fnc_loop; 0 spawn d_fnc_clean_craters}, 240 + random 240]] call bis_fnc_loop;
