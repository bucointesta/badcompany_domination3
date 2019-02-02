// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_m47.sqf"
#include "..\..\x_setup.sqf"

d_x_sm_pos = "d_sm_47" call d_fnc_smmapos; // index: 47,   Destroy oil pumps
d_x_sm_type = "normal"; // "convoy"

if (hasInterface) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_866a";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_867";
};

if (call d_fnc_checkSHC) then {
	d_x_sm_pos params ["_poss"];
	private _objs = _poss nearObjects [d_sm_land_oilpump, 150];
	if (count _objs < 3) then {_objs set [2, objNull]};
	sleep 2.123;
	["specops", 2, "allmen", 1, _poss, 200, true] spawn d_fnc_CreateInf;
	sleep 2.221;
	["aa", 1, "tracked_apc", 1, "tank", 1, _poss, 1, 400, true] spawn d_fnc_CreateArmor;
	sleep 5.123;
	[_objs # 0, _objs # 1, _objs # 2] spawn d_fnc_sidefactory;
};
