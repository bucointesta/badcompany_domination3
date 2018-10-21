// by Xeno
#define THIS_FILE "fn_target_clear_client.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

playSound "d_fanfare";

private _extra_bonusn = _this;

if (!isNil "d_obj00_task") then {
	d_obj00_task = nil;
	["d_obj00", "Succeeded", false] call BIS_fnc_taskSetState;
};

if (!isNil "d_current_task") then {
	[d_current_task, "Succeeded", true] call BIS_fnc_taskSetState;
};

private _mt_str = format [localize "STR_DOM_MISSIONSTRING_570", d_cur_tgt_name];
if (count d_resolved_targets < d_MainTargets) then {
	if (_extra_bonusn != "") then {
		private _bonus_string = format[localize "STR_DOM_MISSIONSTRING_571", [_extra_bonusn, "CfgVehicles"] call d_fnc_GetDisplayName];
		
		hint composeText[
			parseText format ["<t color='#ffffffff' size='1.5'>%1</t>", _mt_str], lineBreak, lineBreak,
			localize "STR_DOM_MISSIONSTRING_572", lineBreak,lineBreak,
			_bonus_string, lineBreak,lineBreak,
			localize "STR_DOM_MISSIONSTRING_573"
		];
	} else {
		hint composeText[
			parseText format ["<t color='#ffffffff' size='1.5'>%1</t>", _mt_str], lineBreak, lineBreak,
			localize "STR_DOM_MISSIONSTRING_572", lineBreak,lineBreak,
			localize "STR_DOM_MISSIONSTRING_573"
		];
	};
	if (d_with_ranked) then {
		if (player distance2D d_cur_tgt_pos < (d_ranked_a select 10)) then {
			[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_574", d_ranked_a select 9];
			0 spawn {
				scriptName "spawn_x_target_clear_client_sendscore";
				sleep (0.5 + random 2);
				[player, d_ranked_a select 9] remoteExecCall ["addScore", 2];
			};
		};
	};
} else {
	hint  composeText[
		parseText("<t color='#f02b11ed' size='1'>" + format [localize "STR_DOM_MISSIONSTRING_570", d_cur_tgt_name] + "</t>"), lineBreak, lineBreak,
		localize "STR_DOM_MISSIONSTRING_572"
	];
};
