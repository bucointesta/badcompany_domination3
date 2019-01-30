// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_setupplayer.sqf"
#include "..\x_setup.sqf"

#include "\A3\ui_f\hpp\defineDIKCodes.inc"

diag_log [diag_frameno, diag_ticktime, time, "Executing Dom x_setupplayer.sqf"];

d_name_pl = name player;
d_string_player = str player;
d_player_side = blufor;

player setVariable ["d_tk_cutofft", time + 3];
player setVariable ["xr_pluncon", false];
d_player_in_base = true;
d_player_in_air = false;

if !(d_additional_respawn_points isEqualTo []) then {
	{
		if (_x select 1 isEqualType "") then {
			_x set [1, markerPos (_x select 1)];
		};
	} forEach d_additional_respawn_points;
};

if (d_WithRevive == 1) then {
	if (!d_with_ace) then {
		player addEventHandler ["handleDamage", {_this call xr_fnc_ClientHD}];
	};
	xr_pl_group = group player;
};

if (!isServer) then {execVM "x_bikb\kbinit.sqf"};

["d_dummy_marker", [0, 0, 0], "ICON", "ColorBlack", [1, 1], "", 0, "Empty"] call d_fnc_CreateMarkerLocal;

if (d_the_end) exitWith {
	endMission "END1";
	forceEnd;
};

if (!isMultiplayer) then {
	0 spawn {
		scriptName "spawn_playerstuff";
		sleep 1 + random 3;		
		d_player_autokick_time = d_AutoKickTime;
		xr_phd_invulnerable = false;
		sleep 10;
		if (d_still_in_intro) then {
			d_still_in_intro = false;
		};
	};
};

if (d_WithWinterWeather == 0 && {d_weather == 0}) then {execVM "scripts\weather_winter.sqf"};
if (d_WithWinterWeather == 1 && {d_weather == 0 && {d_withsandstorm == 0}}) then {0 spawn d_fnc_sandstorm};


if (d_with_ranked) then {
	// basic rifle at start
	private _weapp = "";
	private _magp = "";
	switch (d_own_side) do {
		case "WEST": {
			_weapp = "arifle_MX_F";
			_magp = "30Rnd_65x39_caseless_mag";
		};
		case "EAST": {
			_weapp = "arifle_MX_F";
			_magp = "30Rnd_65x39_caseless_mag";
		};
		case "GUER": {
			_weapp = "arifle_MX_F";
			_magp = "30Rnd_65x39_caseless_mag";
		};
	};
	removeAllWeapons player;
	player addMagazines [_magp, 6];
	player addWeapon _weapp;


	if (!d_with_ace) then {
		player addEventHandler ["handleHeal", {_this call d_fnc_handleheal}];
	};
	
	d_sm_p_pos = nil;
	player addEventhandler ["SeatSwitchedMan", {_this call d_fnc_seatswitchedman}];
};

player addEventhandler ["Take", {_this call d_fnc_ptakeweapon}];
player addEventhandler ["Put", {_this call d_fnc_pputweapon}];
player addEventhandler ["Reloaded", {call d_fnc_save_layoutgear}];

removeAllWeapons player;
removeallItems player;
removeAllAssignedItems player;
removeVest player;
removeBackpack player;
removeHeadgear player;
removeGoggles player;

if (d_MissionType != 2) then {
	if !(d_resolved_targets isEqualTo []) then {
		private _codtn = count d_target_names;
		for "_i" from 0 to (count d_resolved_targets - 1) do {
			if (isNil "d_resolved_targets" || {_i >= count d_resolved_targets}) exitWith {};
			private _res = d_resolved_targets select _i;
			if (!isNil "_res" && {_res >= 0 && {_res < _codtn}}) then {
				private _tgt_ar = d_target_names select _res;
				private _cur_tgt_name = _tgt_ar select 1;
				private _tname = format ["d_obj%1", _res + 2];
				private _no = missionNamespace getVariable format ["d_target_%1", _res];
				private _tstate = if (!isNull _no && {!isNil {_no getVariable "d_recaptured"}}) then {
					"Failed"
				} else {
					"Succeeded"
				};
				[true, _tname, [format [localize "STR_DOM_MISSIONSTRING_202", _cur_tgt_name], format [localize "STR_DOM_MISSIONSTRING_203", _cur_tgt_name], format [localize "STR_DOM_MISSIONSTRING_203", _cur_tgt_name]], _tgt_ar select 0, _tstate, 2, false, "Attack", false] call BIS_fnc_taskCreate;
			};
		};
	};

	d_current_seize = "";
	if (d_current_target_index != -1 && {!d_target_clear && {!(d_cur_tgt_pos isEqualTo [])}}) then {
		d_current_seize = d_cur_tgt_name;
		"d_dummy_marker" setMarkerPosLocal d_cur_tgt_pos;
		private _tname = format ["d_obj%1", d_current_target_index + 2];
		[true, _tname, [format [localize "STR_DOM_MISSIONSTRING_202", d_current_seize], format [localize "STR_DOM_MISSIONSTRING_203", d_current_seize], format [localize "STR_DOM_MISSIONSTRING_203", d_current_seize]], d_cur_tgt_pos, true, 2, false, "Attack", false] call BIS_fnc_taskCreate;
		d_current_task = _tname;
		if (!isNil "d_obj00_task") then {
			d_obj00_task = nil;
			["d_obj00", "Succeeded", false] call BIS_fnc_taskSetState;
		};
	};
};

if (d_MissionType != 2) then {
	{
		if (d_jumpflag_vec == "") then {
			_x setVariable ["d_jf_id", _x addAction [format ["<t color='#AAD9EF'>%1</t>", localize "STR_DOM_MISSIONSTRING_296"], {_this spawn d_fnc_paraj}]];
		} else {
			_x setVariable ["d_jf_id", _x addAction [format ["<t color='#AAD9EF'>%1</t>", format [localize "STR_DOM_MISSIONSTRING_297", [d_jumpflag_vec, "CfgVehicles"] call d_fnc_GetDisplayName]], {_this spawn d_fnc_bike},[d_jumpflag_vec,1]]];
		};
		false
	} count ((allMissionObjects d_flag_pole) select {!isNil {_x getVariable "d_is_jf"} && {isNil {_x getVariable "d_jf_id"}}});
};

if (d_all_sm_res) then {d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_522"} else {[false] call d_fnc_getsidemissionclient};

player addEventHandler ["Killed", {
	[param [0], param [1], param[2]] remoteExecCall ["d_fnc_plcheckkill", 2];
	d_respawngear = getunitloadout player;
	[0] call d_fnc_playerspawn;
	d_player_in_vec = false;
}];
player addEventHandler ["respawn", {_this call d_fnc_prespawned}];

// one entry: [box_object, color as array (R, G, B, Alpha), "Text to show above box"]
d_all_p_a_boxes = [];

/* d_ammo_boxes is an array where each entry represent an ammobox
	each entry has:
	0) position of the ammobox
	1) name in the format d_bm_%position
*/
if !(d_ammo_boxes isEqualTo []) then {
	{
		private _boxnew = d_the_box createVehicleLocal [0,0,0];
		_boxnew setPos (_x select 0);
		[_boxnew] call d_fnc_weaponcargo;
		_boxnew allowDamage false;
		false
	} count (d_ammo_boxes select {_x isEqualType []});
};

player setVariable ["d_isinaction", false];

#define __scale3 private _scale = 0.033 - (_distp / 9000); \
_pos set [2, 5 + (_distp * 0.05)]; \
private _alpha = 1 - (_distp / 200)

#define __scale4 private _scale = 0.033 - (_distp / 9000); \
_pos set [2, 1.5 + (_distp * 0.05)]; \
private _alpha = 1 - (_distp / 200)

#define __scale5 private _scale = 0.033 - (_distp / 9000); \
_pos set [2, 2.5 + (_distp * 0.05)]; \
private _alpha = 1 - (_distp / 200)

#define __scale6 private _scale = 0.033 - (_distp / 9000); \
_pos set [2, 15 + (_distp * 0.05)]; \
private _alpha = 1 - (_distp / 200)

0 spawn {
	waitUntil {!d_still_in_intro};
	d_d3d_locs1 = localize "STR_DOM_MISSIONSTRING_524";
	d_d3d_locs2 = localize "STR_DOM_MISSIONSTRING_526";
	d_d3d_locs3 = localize "STR_DOM_MISSIONSTRING_528";
	d_d3d_locs4 = localize "STR_DOM_MISSIONSTRING_0";
	d_d3d_locs4a = localize "STR_DOM_MISSIONSTRING_1718";
	d_d3d_locs5 = localize "STR_DOM_MISSIONSTRING_531";
	d_d3d_locs6 = localize "STR_DOM_MISSIONSTRING_1644";
	d_d3d_locs7 = "Armory";
	d_pl_flag_base = d_FLAG_BASE;
	d_pl_vec_trig = d_vecre_trigger;
	d_pl_jet_trig = d_jet_trigger;
	if (!d_ifa3lite) then {
		d_pl_chop_trig = d_chopper_trigger;
	};
	d_pl_wreck_trig = d_wreck_rep;
	d_pl_ammoload_trig = d_AMMOLOAD;
	d_pl_armory = d_armory;

	addMissionEventHandler ["Draw3D", {
		private _pos_cam = positionCameraToWorld [0,0,0];
		if (_pos_cam inArea "d_base_marker") then {
			private _distp = _pos_cam distance2D d_pl_vec_trig;
			if (_distp < 200) then {
				private _pos = getPosATL d_pl_vec_trig;
				__scale3;
				drawIcon3D ["#(argb,8,8,3)color(0,0,0,0)", [0,0,1,_alpha], _pos, 1, 1, 0, d_d3d_locs1, 1, _scale, "RobotoCondensed"];
			};
			_distp = _pos_cam distance2D d_pl_jet_trig;
			if (_distp < 200) then {
				private _pos = getPosATL d_pl_jet_trig;
				__scale3;
				drawIcon3D ["#(argb,8,8,3)color(0,0,0,0)", [0,0,1,_alpha], _pos, 1, 1, 0, d_d3d_locs2, 1, _scale, "RobotoCondensed"];
			};
			if (!d_ifa3lite) then {
				_distp = _pos_cam distance2D d_pl_chop_trig;
				if (_distp < 200) then {
					private _pos = getPosATL d_pl_chop_trig;
					__scale3;
					
					drawIcon3D ["#(argb,8,8,3)color(0,0,0,0)", [0,0,1,_alpha], _pos, 1, 1, 0, d_d3d_locs3, 1, _scale, "RobotoCondensed"];
				};
			};
			_distp = _pos_cam distance2D d_pl_wreck_trig;
			if (_distp < 200) then {
				private _pos = getPosATL d_pl_wreck_trig;
				__scale3;
				private _cwt = d_pl_wreck_trig getVariable ["d_curreptime" , -1];
				if (_cwt == -1) then {
					drawIcon3D ["#(argb,8,8,3)color(0,0,0,0)", [0,0,1,_alpha], _pos, 1, 1, 0, d_d3d_locs4, 1, _scale, "RobotoCondensed"];
				} else {
					drawIcon3D ["#(argb,8,8,3)color(0,0,0,0)", [0,0,1,_alpha], _pos, 1, 1, 0, format [d_d3d_locs4a, round (_cwt - time)], 1, _scale, "RobotoCondensed"];
				};
			};
			_distp = _pos_cam distance2D d_pl_ammoload_trig;
			if (_distp < 200) then {
				private _pos = getPosATL d_pl_ammoload_trig;
				__scale3;
				drawIcon3D ["#(argb,8,8,3)color(0,0,0,0)", [0,0,1,_alpha], _pos, 1, 1, 0, d_d3d_locs5, 1, _scale, "RobotoCondensed"];
			};
			_distp = _pos_cam distance2D d_pl_flag_base;
			if (_distp < 80) then {
				private _pos = getPosATL d_pl_flag_base;
				__scale5;
				drawIcon3D ["#(argb,8,8,3)color(0,0,0,0)", [1,1,0,_alpha], _pos, 1, 1, 0, d_d3d_locs6, 1, _scale, "RobotoCondensed"];
			};
			_distp = _pos_cam distance2D d_pl_armory;
			if (_distp < 1000) then {
				private _pos = getPosATL d_pl_armory;
				__scale6;
				drawIcon3D ["#(argb,8,8,3)color(0,0,0,0)", [1,1,0,_alpha], _pos, 1, 1, 0, d_d3d_locs7, 1, _scale, "RobotoCondensed"];
			};
			{
				private _box = _x select 0;
				if (!isNull _box) then {
					//private _distp = _pos_cam distance2D _box;
					private _distp = _pos_cam distance _box;
					if (_distp < 20) then {
						private _pos = getPosATL _box;
						__scale4;
						drawIcon3D ["#(argb,8,8,3)color(0,0,0,0)", [1,0,0,_alpha], _pos, 1, 1, 0, _x select 1, 1, _scale, "RobotoCondensed"];
					};
				};
				false
			} count d_static_ammoboxes;
		};
		if !(d_all_p_a_boxes isEqualTo []) then {
			{
				private _box = _x select 0;
				if (!isNull _box) then {
					//private _distp = _pos_cam distance2D _box;
					private _distp = _pos_cam distance _box;
					if (_distp < 80) then {
						private _pos = getPosATL _box;
						__scale4;
						private _col = _x select 1;
						_col set [3, _alpha];
						drawIcon3D ["#(argb,8,8,3)color(0,0,0,0)", _col, _pos, 1, 1, 0, _x select 2, 1, _scale, "RobotoCondensed"];
					};
				};
				false
			} count d_all_p_a_boxes;
		};
		{
			if (alive _x && {isTouchingGround _x}) then {
				private _distp = _pos_cam distance _x;
				if (_distp < 150) then {
					private _pos = ASLToAGL (visiblePositionASL _x);
					_pos set [2, (_pos select 2) + 2];
					__scale3;
					drawIcon3D ["#(argb,8,8,3)color(0,0,0,0)", [0,0,1,_alpha], _pos, 1, 1, 0, format ["%1", _x getVariable "d_ma_text"], 1, _scale, "RobotoCondensed"];
				};
			};
			false
		} count d_mhq_3ddraw;
	}];
	
	//"d_fpsresource" cutRsc ["d_fpsresource", "PLAIN"];
	if (d_player_can_call_arti > 0 || {d_player_can_call_drop > 0 || {d_string_player in d_can_call_cas || {!d_no_ai}}}) then {
		"d_RscSupportL" cutRsc ["d_RscSupportL", "PLAIN"];
	};
	
	xr_phd_invulnerable = false;
	sleep 2;
	player setVariable ["d_player_old_rank", 0];
	if (d_database_found && {d_set_pl_score_db}) then {
		d_points_needed = d_points_needed_db;
	};
	0 spawn d_fnc_playerrankloop;
};

diag_log ["Internal D Version: 3.74"];

if (!d_no_ai) then {
	if (d_with_ai) then {
		if (isNil "d_AI_HUT") then {
			0 spawn {
				scriptName "spawn_wait_for_ai_hut";
				waitUntil {sleep 0.512; !isNil "d_AI_HUT"};
				call compile preprocessFileLineNumbers "x_client\x_recruitsetup.sqf";
			};
		} else {
			call compile preprocessFileLineNumbers "x_client\x_recruitsetup.sqf";
		};

		private _grpp = group player;
		private _leader = leader _grpp;
		if (!isPlayer _leader || {player == _leader}) then {
			{
				if (isNull objectParent _x) then {
					deleteVehicle _x;
				} else {
					(vehicle _x) deleteVehicleCrew _x;
				};
				false
			} count ((units _grpp) select {!isPlayer _x});
		};
	};

	d_player_can_call_arti = 1;
	d_player_can_call_drop = 1;
	d_player_can_call_cas = 1;
  	player setUnitTrait ["Medic", true];
	player setUnitTrait ["engineer", true];
} else {
	if (d_string_player in d_can_use_artillery) then {
		d_player_can_call_arti = 1;
	} else {
		enableEngineArtillery false;
	};
	if (d_string_player in d_can_call_drop_ar) then {
		d_player_can_call_drop = 1;
	};
	if (d_string_player in d_can_call_cas) then {
		d_player_can_call_cas = 1;
	};
};
/*player setUnitTrait ["explosiveSpecialist", true];*/

private _respawn_marker = "";
private _base_spawn_m = "base_spawn_1";
switch (d_own_side) do {
	case "GUER": {
		_respawn_marker = "respawn_guerrila";
		deleteMarkerLocal "respawn_west";
		deleteMarkerLocal "respawn_east";
	};
	case "WEST": {
		_respawn_marker = "respawn_west";
		deleteMarkerLocal "respawn_guerrila";
		deleteMarkerLocal "respawn_east";
	};
	case "EAST": {
		_respawn_marker = "respawn_east";
		deleteMarkerLocal "respawn_west";
		deleteMarkerLocal "respawn_guerrila";
	};
};

_respawn_marker setMarkerPosLocal markerPos _base_spawn_m;

// special triggers for engineers, AI version, everybody can repair and flip vehicles
if (d_string_player in d_is_engineer || {!d_no_ai}) then {
	d_eng_can_repfuel = true;

	if (d_engineerfull == 0 || {!d_no_ai}) then {
 		private _engineer_trigger = createTrigger ["EmptyDetector" ,d_base_array select 0, false];
		_engineer_trigger setTriggerArea [d_base_array select 1, d_base_array select 2, d_base_array select 3, true, 2];
		_engineer_trigger setTriggerActivation [d_own_side, "PRESENT", true];
		_engineer_trigger setTriggerStatements["!d_eng_can_repfuel && {player in thislist}", "d_eng_can_repfuel = true;systemChat (localize 'STR_DOM_MISSIONSTRING_340')", ""];
	};

	if (d_with_ranked) then {d_last_base_repair = -1};

	["itemAdd", ["dom_eng_1_trig", {
		if (player getVariable ["d_has_ffunc_aid", -9999] == -9999 && {player call d_fnc_hastoolkit && {call d_fnc_ffunc}}) then {
			player setVariable ["d_has_ffunc_aid", player addAction [format ["<t color='#7F7F7F'>%1</t>", localize 'STR_DOM_MISSIONSTRING_1408'], {_this call d_fnc_unflipVehicle},[d_objectID1],-1,false]];
		} else {
			if (player getVariable ["d_has_ffunc_aid", -9999] != -9999 && {!(call d_fnc_ffunc)}) then {
				player removeAction (player getVariable "d_has_ffunc_aid");
				player setVariable ["d_has_ffunc_aid", -9999];
			};
		};
	}, 0.51]] call bis_fnc_loop;

	if (d_engineerfull == 0 || {!d_no_ai}) then {
		player setVariable ["d_has_sfunc_aid", false];
		["itemAdd", ["dom_eng_2_trig", {
			if (!(player getVariable ["d_has_sfunc_aid", false]) && {player call d_fnc_hastoolkit && {call d_fnc_sfunc}}) then {
				d_actionID6 = player addAction [format ["<t color='#7F7F7F'>%1</t>", localize "STR_DOM_MISSIONSTRING_1509"], {_this call d_fnc_repanalyze},[],-1,false];
				d_actionID2 = player addAction [format ["<t color='#7F7F7F'>%1</t>", localize "STR_DOM_MISSIONSTRING_1510"], {_this spawn d_fnc_repengineer},[],-1,false];
				player setVariable ["d_has_sfunc_aid", true];
			} else {
				if (player getVariable ["d_has_sfunc_aid", false] && {!(call d_fnc_sfunc)}) then {
					player removeAction d_actionID6;
					player removeAction d_actionID2;
					player setVariable ["d_has_sfunc_aid", false];
				};
			};
		}, 0.56]] call bis_fnc_loop;
	};

	player setVariable ["d_is_engineer", true];
	player setVariable ["d_farp_pos", []];

	if (d_engineerfull == 0 || {!d_no_ai}) then {
		{_x addAction [format ["<t color='#AAD9EF'>%1</t>", localize "STR_DOM_MISSIONSTRING_513"], {_this call d_fnc_restoreeng}];false} count d_farps;
	};
};

{
	_x addAction [format ["<t color='#FF0000'>%1</t>", localize "STR_DOM_MISSIONSTRING_286a"], {_this call d_fnc_healatmash}, 0, -1, false, false, "", "damage player > 0 && {alive player && {!(player getVariable 'xr_pluncon') && {!(player getVariable ['ace_isunconscious', false]) && {!(player getVariable 'd_isinaction') && {!(player getVariable ['ace_isunconscious', false]) && {!(player getVariable ['ace_isunconscious', false])}}}}}}"];
	false
} count d_mashes;

{
	private _farpc = _x getVariable ["d_objcont", []];
	if !(_farpc isEqualTo []) then {
		private _trig = _farpc select 0;
		_trig setTriggerActivation ["ANY", "PRESENT", true];
		_trig setTriggerStatements ["thislist call d_fnc_tallservice", "0 = [thislist] spawn d_fnc_reload", ""];
	};
	false
} count d_farps;

// Enemy at base
"d_enemy_base" setMarkerPosLocal (d_base_array select 0);
"d_enemy_base" setMarkerDirLocal (d_base_array select 3);
[d_base_array select 0, [d_base_array select 1, d_base_array select 2, d_base_array select 3, true, 2], [d_enemy_side, "PRESENT", true], ["'Man' countType thislist > 0 || {'Tank' countType thislist > 0 || {'Car' countType thislist > 0}}", "[0] call d_fnc_BaseEnemies;'d_enemy_base' setMarkerSizeLocal [d_base_array select 1,d_base_array select 2];d_there_are_enemies_atbase = true", "[1] call d_fnc_BaseEnemies;'d_enemy_base' setMarkerSizeLocal [0,0];d_there_are_enemies_atbase = false"]] call d_fnc_createtriggerlocal;
[d_base_array select 0, [(d_base_array select 1) + 300, (d_base_array select 2) + 300, d_base_array select 3, true, 2], [d_enemy_side, "PRESENT", true], ["'Man' countType thislist > 0 || {'Tank' countType thislist > 0 || {'Car' countType thislist > 0}}", "if (!(player getVariable ['xr_pluncon', false]) && {!(player getVariable ['ace_isunconscious', false])}) then {hint (localize 'STR_DOM_MISSIONSTRING_1409')};d_enemies_near_base = true", "d_enemies_near_base = false"]] call d_fnc_createtriggerlocal;

// TODO Add trait medic players too? Dunno yet, maybe too much medic tents cluttering the island then
if (player getUnitTrait "Medic") then {
	d_player_is_medic = true;
	player setVariable ["d_medtent", []];
};

d_x_loop_end = false;
if (d_WithMHQTeleport == 0) then {
	d_FLAG_BASE addAction [format ["<t color='#7F7F7F'>%1</t>", localize "STR_DOM_MISSIONSTRING_533"], {_this call d_fnc_teleportx}];
};
if (d_with_ai || {d_ParaAtBase == 0}) then {
	d_FLAG_BASE addaction [format ["<t color='#7F7F7F'>%1</t>", localize "STR_DOM_MISSIONSTRING_296"], {_this spawn d_fnc_paraj}];
};

d_FLAG_BASE addaction [format ["<t color='#3F3F3F'>%1</t>", localize "STR_DOM_MISSIONSTRING_1745"], {_this call d_fnc_playerspectate}];

if (d_ParaAtBase == 1) then {
	"d_Teleporter" setMarkerTextLocal (localize "STR_DOM_MISSIONSTRING_534");
};

if (!d_with_ace) then {
	execVM "x_client\x_playernamehud.sqf";
};

private _primw = primaryWeapon player;
if (_primw != "") then {
	player selectWeapon _primw;
};

if (d_MissionType != 2) then {
	execFSM "fsms\fn_CampDialog.fsm";
	// call d_fnc_CampDialog;
	
	if (!isNil "d_searchbody" && {!isNull d_searchbody} && {isNil {d_searchbody getVariable "d_search_body"}}) then {
		d_searchbody setVariable ["d_search_id", d_searchbody addAction [localize "STR_DOM_MISSIONSTRING_518", {_this spawn d_fnc_searchbody}]];
	};
};

player setVariable ["d_p_f_b", 0];

player addEventHandler ["firedMan", {_this call d_fnc_playerfiredeh}];

if (d_no_3rd_person == 0) then {
	//call d_fnc_3rdperson;
	execFSM "fsms\fn_3rdperson.fsm";
};

d_mark_loc280 = localize "STR_DOM_MISSIONSTRING_280";
d_mark_loc261 = localize "STR_DOM_MISSIONSTRING_261";

d_map_ameh = addMissionEventHandler ["Map", {
	if (param [0]) then {
		findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", {[_this, 0] call d_fnc_mapondraw}];
	};
	removeMissionEventHandler ["Map", d_map_ameh];
	d_map_ameh = nil;
}];

0 spawn d_fnc_waitforgps;
/*
private _box_array = d_player_ammobox_pos;
__TRACE_1("","d_the_base_box")
__TRACE_1("","_box_array")
private _box = d_the_base_box createVehicleLocal [0,0,0];
__TRACE_1("","_box")
_box setDir (_box_array select 1);
_box setPos (_box_array select 0);
player reveal _box;
[_box] call d_fnc_weaponcargo;

d_player_ammobox_pos = nil;

//[_box,_box_array] call d_fnc_PlayerAmmobox;
[_box, _box_array] execFSM "fsms\fn_PlayerAmmobox.fsm";
*/

(findDisplay 46) displayAddEventHandler ["MouseZChanged", {_this call d_fnc_MouseWheelRec}];

if (d_WithRevive == 0) then {
	call compile preprocessFileLineNumbers "x_revive.sqf";
};

0 spawn d_fnc_dcmcc;

(findDisplay 46) displayAddEventHandler ["KeyDown", {if (param [1] in actionKeys "TeamSwitch" && {alive player && {!(player getVariable "xr_pluncon") && {!(player getVariable ["ace_isunconscious", false]) && {!(param [2]) && {!(param [3]) && {!(param [4])}}}}}}) then {[0, _this] call d_fnc_KeyDownCommandingMenu; true} else {false}}];
(findDisplay 46) displayAddEventHandler ["KeyUp", {if (param [1] in actionKeys "TeamSwitch"&& {!(param [2]) && {!(param [3]) && {!(param [4])}}}) then {[1, _this] call d_fnc_KeyDownCommandingMenu; true} else {false}}];

// by R34P3R
d_p_isju = false;
(findDisplay 46) displayAddEventHandler ["KeyDown", {
	if (param [1] in actionKeys "GetOver" &&  {alive player && {currentWeapon player == primaryWeapon player && {currentWeapon player != "" && {isNull objectParent player && {speed player > 11 && {stance player == "STAND" && {getFatigue player < 0.5 && {isTouchingGround (vehicle player) &&  {!(player getVariable ["xr_pluncon", false]) && {!(player getVariable ["ace_isunconscious", false]) && {!d_p_isju}}}}}}}}}}}) then {
		d_p_isju = true;
		0 spawn {
			private _v = velocity player;
			private _veloH = [(_v select 0) + 0.6, (_v select 1) + 0.6, (_v select 2) + 0.1];
			private _veloL = [_v select 0, _v select 1, (_v select 2) - 1];
			private _maxHight = (getPosATL player select 2) + 1.3;
			
			[player, "AovrPercMrunSrasWrflDf"] remoteExecCall ["switchMove"];
			sleep 0.05;
			while {animationState player == "AovrPercMrunSrasWrflDf"} do {
				if (getPosATL player select 2 > _maxHight) then {
					player setVelocity _veloL;
				} else {
					player setVelocity _veloH;
				};
				sleep 0.05;
			};
			sleep 1;
			d_p_isju = false;
		};
		true
	} else {
		false
	};
}];

d_vec_role_pl = [];
player addEventhandler ["getInMan", {
	d_player_in_base = false;
	d_vec_role_pl = assignedVehicleRole player;
	if (alive player && {!(player getVariable ["xr_pluncon", false]) && {!(player getVariable ["ace_isunconscious", false])}}) then {
		d_player_in_vec = true;
		_this call d_fnc_vehicleScripts;
	} else {
		d_player_in_vec = false;
	};
}];

player addEventHandler ["SeatSwitchedMan", {
	
	_this call d_fnc_checkswitchseat;
	
}];

player addEventhandler ["getOutMan", {
	d_player_in_vec = false;
	d_vec_role_pl = [];
	if (!isNil "d_heli_kh_ro") then {
		(findDisplay 46) displayRemoveEventHandler ["KeyDown", d_heli_kh_ro];
		d_heli_kh_ro = nil;
	};
	if (getPos player select 2 > 5) then {
		d_player_in_air = true;
		0 spawn {
			while {alive player && {!(player getVariable ["xr_pluncon", false]) && {getPos player select 2 > 2 && {!(player getVariable ["ace_isunconscious", false])}}}} do {sleep 1};
			d_player_in_air = false;
			if (alive player && {!(player getVariable ["xr_pluncon", false]) && {!(player getVariable ["ace_isunconscious", false]) && {player inArea d_base_array && {!(player getVariable ["ace_isunconscious", false])}}}}) then {
				d_player_in_base = true;
			};			
		};
	} else {
		if (alive player && {!(player getVariable ["xr_pluncon", false]) && {!(player getVariable ["ace_isunconscious", false]) && {player inArea d_base_array}}}) then {
			d_player_in_base = true;
		};
	};
}];

d_pisadminp = false;
if (d_AutoKickTime == 0 || {d_with_ranked || {d_MissionType == 2}}) then {
	d_clientScriptsAr set [1, true];
};

["itemAdd", ["dom_cl_scripts_x", {call d_fnc_startClientScripts}, 0.6]] call bis_fnc_loop;

if !(markerPos "d_runwaymarker" isEqualTo [0,0,0]) then {
	private _msize = markerSize "d_runwaymarker";
	[[markerPos "d_runwaymarker" select 0, markerPos "d_runwaymarker" select 1, 1.9], [_msize select 0, _msize select 1, markerDir "d_runwaymarker", true, 2], ["ANY", "PRESENT", true], ["!((thislist unitsBelowHeight 1) isEqualTo [])", "'d_runwaymarker' setMarkerColorLocal 'ColorRed'", "'d_runwaymarker' setMarkerColorLocal 'ColorGreen'"]] call d_fnc_createtriggerlocal;
};

/*
player call d_fnc_removenvgoggles_fak;

if (d_without_nvg == 1 && {!(player call d_fnc_hasnvgoggles)}) then {
	player linkItem (switch (d_player_side) do {
		case opfor: {"NVGoggles_OPFOR"};
		case independent: {"NVGoggles_INDEP"};
		default {"NVGoggles"};
	});
};

private _bino = binocular player;
if (d_string_player in d_can_use_artillery || {d_string_player in d_can_mark_artillery || {d_string_player in d_can_call_cas}}) then {
	if (_bino != "LaserDesignator") then {
		if (_bino != "") then {
			player removeWeapon _bino;
		};
		player addWeapon "LaserDesignator";
	};
	if !("Laserbatteries" in magazines player) then {
		player addMagazine ["Laserbatteries", 1];
	};
} else {
	if (_bino == "") then {
		player addWeapon "Binocular";
	};
};*/

if !("ItemGPS" in (assignedItems player)) then {
	player linkItem "ItemGPS";
};

call d_fnc_save_respawngear;
call d_fnc_save_layoutgear;

//if (sunOrMoon < 0.99 && {d_without_nvg == 1}) then {player action ["NVGoggles", player]};

["itemAdd", ["dom_clean_craters", {["itemRemove", ["dom_clean_craters"]] call bis_fnc_loop; 0 spawn d_fnc_clean_craters}, 240 + random 240]] call bis_fnc_loop;

private _avec_str = "d_artyvec_%1";

for "_i" from 0 to 30 do {
	private _vvx = missionNamespace getVariable format [_avec_str, _i];
	if (!isNil "_vvx") then {
		d_ao_arty_vecs pushBack _vvx;
		d_areArtyVecsAvailable = true;
	};
};
/*
if (!d_no_ai || {d_string_player in d_can_use_artillery || {d_string_player in d_can_mark_artillery}}) then {
	player setVariable ["d_ld_action", player addAction [format ["<t color='#FF0000'>%1</t>", localize "STR_DOM_MISSIONSTRING_1520"], {_this call d_fnc_mark_artillery} , 0, 9, true, false, "", "alive player && {!(player getVariable ['xr_pluncon', false]) && {!(player getVariable ['ace_isunconscious', false]) && {!(player getVariable ['d_isinaction', false]) && {!d_player_in_vec && {cameraView == 'GUNNER' && {!isNull (laserTarget player) && {currentWeapon player isKindOf ['LaserDesignator', configFile >> 'CfgWeapons']}}}}}}}"]];
};
*/
if (!d_no_ai || {d_string_player in d_can_call_cas}) then {
	if (!d_ifa3lite) then {
		player setVariable ["d_ccas_action", player addAction [format ["<t color='#FF0000'>%1</t>", localize "STR_DOM_MISSIONSTRING_1711"], {_this call d_fnc_call_cas} , 0, 9, true, false, "", "d_cas_available && {alive player && {!(player getVariable ['xr_pluncon', false]) && {!(player getVariable ['ace_isunconscious', false]) && {!(player getVariable ['d_isinaction', false]) && {!d_player_in_vec && {cameraView == 'GUNNER' && {!isNull (laserTarget player) && {!((laserTarget player) inArea d_base_array) && {currentWeapon player isKindOf ['LaserDesignator', configFile >> 'CfgWeapons']}}}}}}}}}"]];
	} else {
		player setVariable ["d_ccas_action", player addAction [format ["<t color='#FF0000'>%1</t>", localize "STR_DOM_MISSIONSTRING_1711"], {_this call d_fnc_call_cas} , 0, 9, true, false, "", "d_cas_available && {alive player && {!(player getVariable ['xr_pluncon', false]) && {!(player getVariable ['ace_isunconscious', false]) && {!(player getVariable ['d_isinaction', false]) && {!d_player_in_vec && {cameraView == 'GUNNER' && {!(screenToWorld [0.5, 0.5] inArea d_base_array) && {currentWeapon player isKindOf ['Binocular', configFile >> 'CfgWeapons']}}}}}}}}"]];
	};
};

player addEventhandler["InventoryClosed", {_this call d_fnc_inventoryclosed}];
player addEventhandler["InventoryOpened", {_this call d_fnc_inventoryopened}];

/*[missionNamespace, "arsenalOpened", {
	disableSerialization;
	params ["_disp"];
	(_disp displayCtrl 44150) ctrlEnable false; // random
	(_disp displayCtrl 44148) ctrlEnable false; // export
	(_disp displayCtrl 44149) ctrlEnable false; // import
	(_disp displayCtrl 44151) ctrlEnable false; // hide
	_disp displayAddEventHandler ["KeyDown", {(_this select 1) in [19, 29]}];
	if (d_with_ranked) then {
		(_disp displayCtrl 44147) ctrlEnable false; // Load
		(_disp displayCtrl 44146) ctrlEnable false; // Save
		_disp displayAddEventHandler ["KeyDown", {
			_this select 3 && {_this select 1 == DIK_O}
		}];
	};
}] call BIS_fnc_addScriptedEventHandler;

[missionNamespace, "arsenalClosed", {
	call d_fnc_save_respawngear;
	call d_fnc_save_layoutgear;
	[player, getUnitLoadout player, d_player_side] remoteExecCall ["d_fnc_storeploadout", 2];
	if (!isNil "d_arsenal_nvg_used") then {
		d_arsenal_nvg_used = nil;
		camUseNVG false;
	};
	if (d_with_ranked) then {
		call d_fnc_store_rwitems;
	};
}] call BIS_fnc_addScriptedEventHandler;

player addEventhandler ["HandleRating", {
	if (param [1] < 0) then {0} else {param [1]}
}];

["Preload"] call bis_fnc_arsenal;
*/

d_pisadminp = false;
//(findDisplay 46) displayAddEventHandler ["MouseMoving", {call d_fnc_SCACheck}];
//(findDisplay 46) displayAddEventHandler ["MouseHolding", {call d_fnc_SCACheck}];
addMissionEventhandler ["EachFrame", {call d_fnc_SCACheck}];

if (d_enablefatigue == 0) then {
	player setFatigue 0;
	player enableFatigue false;
};

if (d_enablesway == 0) then {
	player setCustomAimCoef 0.1;
};

player setVariable ["xr_isleader", false];
0 spawn {
	sleep 10;
	private _islead = leader (group player) == player;
	player setVariable ["xr_isleader", _islead];
	if (_islead) then {
		{
			[_x, ["xr_isleader", false]] remoteExecCall ["setVariable", _x];
			false
		} count ((units (group player)) - [player]);
	};
};

player addEventhandler ["WeaponAssembled", {
	["aw", d_string_player, param [1]] remoteExecCall ["d_fnc_p_o_ar", 2];
}];

{_x call d_fnc_initvec;false} count vehicles;

missionNamespace setVariable ["BIS_dynamicGroups_allowInterface", false];

if (d_with_ace) then {
	addMissionEventHandler ["Draw3D", {
		if (alive player && {!(player getVariable ["ace_isunconscious", false])}) then {
			{
				private _u = missionNamespace getVariable _x;
				if (!isNil "_u" && {!isNull _u && {_u getVariable ["ace_isunconscious", false]}}) then {
					private _dist = (positionCameraToWorld [0,0,0]) distance _u;
					if (_dist < 400) then {
						private _pos = getPosATLVisual _u;
						_pos set [2, (_pos select 2) + 1 + (_dist * 0.05)];
						drawIcon3D ["\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa", [1,0,0,1 - (_dist / 200)], _pos, 1, 1, 0, "(Uncon) " + name _u, 1, 0.032 - (_dist / 9000), "RobotoCondensed"];
					};
				};
				false
			} count d_player_entities;
		};
	}];
};

d_last_placed_zeus_obj = objNull;
{
	_x addEventhandler ["CuratorObjectPlaced", {
		addToRemainsCollector [param [1]];
	}];
	false
} count allCurators;

0 spawn {
	waitUntil {time > 0};
	enableEnvironment [false, true];
};

if (isMultiplayer) then {
	execVM "x_client\x_intro.sqf";
} else {
	{_x enableSimulation false;false} count (switchableUnits select {_x != player});
};

diag_log [diag_frameno, diag_ticktime, time, "Dom x_setupplayer.sqf processed"];
