// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_m63.sqf"
#include "..\..\x_setup.sqf"

d_x_sm_pos = "d_sm_63" call d_fnc_smmapos; //index:63 Specop camp near Nr Lakke
d_x_sm_type = "normal"; // "convoy"

if (hasInterface) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_1553";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_760";
};

if (call d_fnc_checkSHC) then {
	[d_x_sm_pos select 0] spawn d_fnc_sidespecops;
};

