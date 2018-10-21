// by Xeno
#define THIS_FILE "x_playernamehud.sqf"
#include "..\x_setup.sqf"

if (isDedicated) exitWith {};

// 0 = over head, 1 = cursor target
d_show_pname_hud = d_playernames_state > 0 && {d_show_playernames == 0};

d_show_player_namesx = d_playernames_state;

d_dist_pname_hud = 200;

sleep 10;

waitUntil {sleep 0.232;!isNil "d_player_entities"};
waitUntil {sleep 0.232;!d_still_in_intro};

d_phudraw3d = -1;
//d_pnhudgroupcolor = [0.96, 1, 0, 0.7];
//d_pnhudothercolor = [0.86, 0.89, 0.1, 0.7];
d_pnhudgroupcolor = [0, 1, 0, 0.9];
d_pnhudothercolor = [1, 1, 1, 0.8];
d_pnhuddeadcolor = [0, 0, 0, 0];

d_pnhuddo2_prevCT = objNull;
d_showPlayerNameRSC_shown = false;
d_pnhuddo2_frskip = 0;

if (d_show_pname_hud) then {
	d_phudraw3d = addMissionEventHandler ["Draw3D", {call d_fnc_player_name_huddo}];
} else {
	["itemAdd", ["dom_player_hud2", {call d_fnc_player_name_huddo2}, 0]] call bis_fnc_loop;
};