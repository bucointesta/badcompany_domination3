// by Xeno
#define THIS_FILE "fn_sidemissionwinner.sqf"
#include "..\x_setup.sqf"

if (isDedicated || {d_IS_HC_CLIENT}) exitWith {};

private _bonus_vecn = _this;

sleep 1;

d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_712";

if (d_sm_winner != 0 && {_bonus_vecn != ""}) then {
	if (d_with_ranked) then {
		private _get_points = false;
		if (alive player && {!(player getVariable ["xr_pluncon", false]) && {!(player getVariable ["ace_isunconscious", false])}}) then {
			if (isNil "d_sm_p_pos") then {
				if (player distance2D (d_x_sm_pos select 0) < d_ranked_a select 12) then {_get_points = true};
			} else {
				if (!isNil "d_sm_p_pos") then {
					if (d_was_at_sm && {d_x_sm_type != "convoy"}) then {
						if (player distance2D d_sm_p_pos < d_ranked_a select 12) then {_get_points = true};
					};
				};
			};
		};
		if (_get_points) then {
			[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_713", d_ranked_a select 11];
			0 spawn {
				sleep (0.5 + random 2);
				[player, d_ranked_a select 11] remoteExecCall ["addScore", 2];
			};
		};
		d_sm_p_pos = nil;
	};

	if (d_MissionType != 2) then {
		private _bonus_string = format[localize "STR_DOM_MISSIONSTRING_714", [_bonus_vecn, "CfgVehicles"] call d_fnc_GetDisplayName];
		hint composeText[
			parseText("<t color='#ffffffff' size='1.5'>" + localize "STR_DOM_MISSIONSTRING_1708" + "</t>"), lineBreak,lineBreak,
			localize "STR_DOM_MISSIONSTRING_572", lineBreak,lineBreak,
			d_current_mission_resolved_text, lineBreak, lineBreak,
			_bonus_string
		];
	} else {
		hint composeText[
			parseText("<t color='#ffffffff' size='1.5'>" + localize "STR_DOM_MISSIONSTRING_1708" + "</t>"), lineBreak,lineBreak,
			localize "STR_DOM_MISSIONSTRING_572", lineBreak,lineBreak,
			d_current_mission_resolved_text
		];
	};
} else {
	private _s = switch (d_sm_winner) do {
		case -1: {localize "STR_DOM_MISSIONSTRING_716"};
		case -2: {localize "STR_DOM_MISSIONSTRING_717"};
		case -300: {localize "STR_DOM_MISSIONSTRING_718"};
		case -400: {localize "STR_DOM_MISSIONSTRING_719"};
		case -500: {localize "STR_DOM_MISSIONSTRING_720"};
		case -600: {localize "STR_DOM_MISSIONSTRING_721"};
		case -700: {localize "STR_DOM_MISSIONSTRING_722"};
		case -878: {localize "STR_DOM_MISSIONSTRING_723"};
		case -879: {localize "STR_DOM_MISSIONSTRING_724"};
		case -880: {localize "STR_DOM_MISSIONSTRING_1556"};//didnt get supplies there in time
		case -881: {localize "STR_DOM_MISSIONSTRING_1557"};//time ran out. sm failed
		case -882: {localize "STR_DOM_MISSIONSTRING_1558"};//time ran out. sm failed
		case -883: {localize "STR_DOM_MISSIONSTRING_1559"};//They have died, you have failed.. sm failed
		case -900: {localize "STR_DOM_MISSIONSTRING_724a"};
		default {""};
	};
	if (_s != "") then {
		hint composeText[
			parseText("<t color='#ffffffff' size='1.5'>" + (localize "STR_DOM_MISSIONSTRING_725") + "</t>"), lineBreak,lineBreak,
			_s
		];
	};
};

["d_sm_task"] call BIS_fnc_deleteTask;

sleep 1;
d_sm_winner = 0;
