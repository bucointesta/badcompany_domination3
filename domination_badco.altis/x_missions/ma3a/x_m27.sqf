// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_m27.sqf"
#include "..\..\x_setup.sqf"

d_x_sm_pos = "d_sm_27" call d_fnc_smmapos; // index: 27,   Radio tower on top of mountain Agios Panagiotis
d_x_sm_type = "normal"; // "convoy"

if (hasInterface) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_847";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_727";
};

if (call d_fnc_checkSHC) then {
	private _poss = d_x_sm_pos select 0;
	private _vec = createVehicle [d_illum_tower, _poss, [], 0, "NONE"];
	_vec setPos _poss;
	_vec setVectorUp [0,0,1];
	_vec call d_fnc_addKilledEHSM;
	d_x_sm_vec_rem_ar pushBack _vec;
	sleep 2.333;
	["specops", 2, "allmen", 2, _poss, 220, true] spawn d_fnc_CreateInf;
};
