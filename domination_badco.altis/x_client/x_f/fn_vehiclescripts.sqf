// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_vehiclescripts.sqf"
#include "..\..\x_setup.sqf"

private _enterer = param [0];
private _position = param [1];
private _vec = _this select 2;
private _turret = param[3];
private _vecnum = _vec getvariable ["d_vec",0];

if ((_vec isKindOf "ParachuteBase") || {_vec isKindOf "BIS_Steerable_Parachute"}) exitWith {};
private _do_exit = false;

// disable manual fire
[] spawn {
	waitUntil {
		(vehicle player) != player
	};
	while {(vehicle player) != player} do {
		if (isManualFire vehicle player) then {
			player action ["manualFireCancel", vehicle player];
		};
	};
};

if (!(d_clientScriptsAr # 1) && {!isNil "d_player_autokick_time"}) then {
	if (time >= d_player_autokick_time) exitWith {
		d_clientScriptsAr set [1, true];
		d_player_autokick_time = nil;
	};
	if (_vec isKindOf "Air") then {
		private _type = toUpper (typeOf _vec);
#ifndef __TT__
		if ((_type in d_mt_bonus_vehicle_array || {_type in d_sm_bonus_vehicle_array}) && {player == driver _vec || {player == gunner _vec || {player == commander _vec}}}) then {
#else
		private _numside = [1, 2] select (d_player_side == blufor);
		if ((_type in (d_mt_bonus_vehicle_array # _numside) || {_type in (d_sm_bonus_vehicle_array # _numside)}) && {player == driver _vec || {player == gunner _vec || {player == commander _vec}}}) then {
#endif
			player action ["getOut", _vec];
			[format [localize "STR_DOM_MISSIONSTRING_1416", [_type, "CfgVehicles"] call d_fnc_GetDisplayName, round ((d_player_autokick_time - time) / 60) max 1], "HQ"] call d_fnc_HintChatMsg;
			_do_exit = true;
		};
	};
};
if (_do_exit) exitWith {};

//Hunter: Doesn't just check for pilots, but drivers of reserved vehicles too
if (((_position == "driver") || {(_position == "gunner") && {(((count _turret) > 0) && {(_turret select 0) == 0}) || {_vec isKindOf "StaticWeapon"}}}) && {!([str _enterer,_vec,_vecnum] call d_fnc_isPilotCheck)}) exitWith {				
	//player action ["getOut", _vec];
	moveout player;
	_vec spawn {
		sleep 0.1;
		if (local _this) then {
			_this engineOn false;
		} else {
			[_this, false] remoteExecCall ["engineOn",_this,false];
		};
	};
};

if (_vec isKindOf "Air") then {
	// Hunter: disable pylon customisation
	/*
	if (!unitIsUAV _vec && {isClass (configFile>>"CfgVehicles">>(typeOf _vec)>>"Components">>"TransportPylonsComponent")}) then {
		_vec call d_fnc_addpylon_action;
	};
	*/
	if (_vec isKindOf "Helicopter") then {
		0 spawn d_fnc_chop_hudsp;
		// currently the only way to disable slingload assistant and rope action for sling loadling.
		// sadly yet another Arma bug is not fixed, therefore inputAction is also needed... http://feedback.arma3.com/view.php?id=20845
		d_heli_kh_ro = (findDisplay 46) displayAddEventHandler ["KeyDown", {((_this select 1) in actionKeys "HeliRopeAction" || {(_this select 1) in actionKeys "HeliSlingLoadManager" || {inputAction "HeliRopeAction" > 0 || {inputAction "HeliSlingLoadManager" > 0}}})}];
	};
	/*
	if (d_pilots_only == 0 && {!([_enterer,_vec,_vecnum] call d_fnc_isPilotCheck) && {(_position == "driver") || {(_turret select 0 == 0) && {_position == "gunner"}}}}) then {
		player action ["getOut", _vec];
		hintSilent localize "STR_DOM_MISSIONSTRING_1417";
		_do_exit = true;
	};
	*/
	if (!d_with_ace) then {
		_vec setVariable ["d_rappel_self_action", [
				/* 0 object */						_vec,
				/* 1 action title */				localize "STR_DOM_MISSIONSTRING_1863",
				/* 2 idle icon */					"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
				/* 3 progress icon */				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
				/* 4 condition to show */			"[player, vehicle player] call AR_fnc_Rappel_From_Heli_Action_Check",
				/* 5 condition for action */		"true",
				/* 6 code executed on start */		{},
				/* 7 code executed per tick */		{},
				/* 8 code executed on completion */	{
					[player, vehicle player] call AR_fnc_Rappel_From_Heli_Action;
				},
				/* 9 code executed on interruption */	{},
				/* 10 arguments */					[],
				/* 11 action duration */			1,
				/* 12 priority */					-1,
				/* 13 remove on completion */		false,
				/* 14 show unconscious */			false
			] call bis_fnc_holdActionAdd
		];

		if (d_with_ai) then {
			d_ai_rappeling = false;
			_vec setVariable ["d_rappel_ai_action", [
					/* 0 object */						_vec,
					/* 1 action title */				localize "STR_DOM_MISSIONSTRING_1864",
					/* 2 idle icon */					"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
					/* 3 progress icon */				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
					/* 4 condition to show */			"!d_ai_rappeling && {[player] call AR_fnc_Rappel_AI_Units_From_Heli_Action_Check}",
					/* 5 condition for action */		"true",
					/* 6 code executed on start */		{},
					/* 7 code executed per tick */		{},
					/* 8 code executed on completion */	{
						d_ai_rappeling = true;
						{
							if !(_x call d_fnc_isplayer) then {
								sleep 1;
								[_x, vehicle _x] call AR_fnc_Rappel_From_Heli_Action;
							};
						} forEach (units player);
						0 spawn {
							sleep 10;
							d_ai_rappeling = false;
						};
					},
					/* 9 code executed on interruption */	{},
					/* 10 arguments */					[],
					/* 11 action duration */			1,
					/* 12 priority */					-1,
					/* 13 remove on completion */		false,
					/* 14 show unconscious */			false
				] call bis_fnc_holdActionAdd
			];
		};

		_vec setVariable ["d_rappel_detach_action", [
				/* 0 object */						_vec,
				/* 1 action title */				localize "STR_DOM_MISSIONSTRING_1865",
				/* 2 idle icon */					"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
				/* 3 progress icon */				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
				/* 4 condition to show */			"[player] call AR_fnc_Rappel_Detach_Action_Check",
				/* 5 condition for action */		"true",
				/* 6 code executed on start */		{},
				/* 7 code executed per tick */		{},
				/* 8 code executed on completion */	{
					[player] call AR_fnc_Rappel_Detach_Action;
				},
				/* 9 code executed on interruption */	{},
				/* 10 arguments */					[],
				/* 11 action duration */			1,
				/* 12 priority */					-1,
				/* 13 remove on completion */		false,
				/* 14 show unconscious */			false
			] call bis_fnc_holdActionAdd
		];
	};
} else {
	if ((_vec isKindOf "LandVehicle" && {!(_vec isKindOf "StaticWeapon")}) || {_vec isKindOf "StaticWeapon" && {!(_vec isKindOf "StaticATWeapon")}}) then {
		[_vec] spawn d_fnc_vec_hudsp;
	};
	if (d_MHQDisableNearMT != 0 && {!d_playerInMHQ && {(_vec getVariable ["d_vec_type", ""]) == "MHQ"}}) then {
		d_playerInMHQ = true;
		[_vec] spawn d_fnc_mhqCheckNearTarget;
	};
  if ((_vec iskindof "StaticWeapon") && {!(_vec getVariable ["staticWepCustomDmgHandlerAdded", false])}) then {
  
  _vec setVariable ["staticWepCustomDmgHandlerAdded", true];
  
  _vec addEventHandler ["HandleDamage", {
  
    _return = _this select 2;
		_source = _this select 3;
		_unit = _this select 0;
		_selection = _this select 1;
    
    if (_selection isEqualTo "") then {
      _return = (damage _unit) + (_return*10);
    } else {
      _return = (_unit getHit _selection) + (_return*10);
    };
    
    _return
    
  }];
  
};
};
if (_do_exit) exitWith {};

if (d_with_ranked || {d_database_found}) then {
	if (_vec isKindOf "Car" || {_vec isKindOf "Air"}) then {
		[_vec] spawn d_fnc_playervectrans;
	};
	if (d_with_ranked) then {
		[_vec] call d_fnc_playerveccheck;
	};
};
if ((d_without_vec_ti == 0) || {_vec isKindOf "StaticWeapon"}) then {
	_vec disableTIEquipment true;
};
if (d_without_vec_nvg == 0) then {
	_vec disableNVGEquipment true;
};

if (toUpper (typeOf _vec) in d_check_ammo_load_vecs) then {
	{
		[_x] execFSM "fsms\fn_AmmoLoad.fsm";
	} forEach d_all_ammoloads;
};
