// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_m46.sqf"
#include "..\..\x_setup.sqf"

d_x_sm_pos = "d_sm_46" call d_fnc_smmapos; // index: 46,   Destroy tanks in power plant near Aggelochori
d_x_sm_type = "normal"; // "convoy"

if (hasInterface) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_866";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_865";
};

if (call d_fnc_checkSHC) then {
	private _poss = d_x_sm_pos select 0;
	private _objs = _poss nearObjects [d_sm_land_tankbig, 150];
	//private _objs = nearestObjects [_poss, [d_sm_land_tankbig], 150];
	if (count _objs < 3) then {_objs set [2, objNull]};
	sleep 2.123;
	["specops", 2, "allmen", 1, _poss, 200, true] spawn d_fnc_CreateInf;
	sleep 2.221;
	["aa", 1, "tracked_apc", 1, "tank", 1, _poss, 1, 400, true] spawn d_fnc_CreateArmor;
	sleep 5.123;
	[_objs select 0, _objs select 1, _objs select 2] spawn d_fnc_sidefactory;
};
