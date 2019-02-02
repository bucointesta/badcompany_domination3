// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_m34.sqf"
#include "..\..\x_setup.sqf"

d_x_sm_pos = [[7020.78,7634.42,0]]; // index: 34,   Transformer station near Novy Sobor
d_x_sm_type = "normal"; // "convoy"

if (hasInterface) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_1804";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_741";
};

if (call d_fnc_checkSHC) then {
	d_x_sm_pos params ["_poss"];
	private _vec = createVehicle [d_sm_land_transformer, _poss, [], 0, "NONE"];
	_vec setDir 347.852;
	_vec setPos _poss;
	_vec setVectorUp [0,0,1];
	d_x_sm_vec_rem_ar pushBack _vec;
	_vec call d_fnc_addKilledEHSM;
	sleep 2.22;
	["aa", 1, "tracked_apc", 1, "tank", 1, _poss, 1, 400, true] spawn d_fnc_CreateArmor;
	sleep 2.123;
	["specops", 1, "allmen", 2, _poss, 300, true] spawn d_fnc_CreateInf;
};