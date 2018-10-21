// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_m40.sqf"
#include "..\..\x_setup.sqf"

d_x_sm_pos = "d_sm_40" call d_fnc_smmapos; // index: 40,   Prison camp, stadion
d_x_sm_type = "normal"; // "convoy"

if (hasInterface) then {
	d_cur_sm_txt = format [localize "STR_DOM_MISSIONSTRING_859", localize "STR_DOM_MISSIONSTRING_860"];
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_789";
};

if (call d_fnc_checkSHC) then {
	[d_x_sm_pos] spawn d_fnc_sideprisoners;
};
