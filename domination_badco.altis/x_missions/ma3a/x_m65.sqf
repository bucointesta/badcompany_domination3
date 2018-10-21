// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_m65.sqf"
#include "..\..\x_setup.sqf"

d_x_sm_pos = "d_sm_65" call d_fnc_smmapos; // index: 65,   Shot down chopper at the old Quarry South of Pyrgos
d_x_sm_type = "normal"; // "convoy"

if (hasInterface) then {
	d_cur_sm_txt = format [localize "STR_DOM_MISSIONSTRING_813", localize "STR_DOM_MISSIONSTRING_1555"];
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_812";
};

if (call d_fnc_checkSHC) then {
	[d_x_sm_pos,time + ((15 * 60) + random 60)] spawn d_fnc_sideevac;
};
