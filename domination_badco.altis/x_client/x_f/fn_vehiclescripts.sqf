// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_vehiclescripts.sqf"
#include "..\..\x_setup.sqf"

private _enterer = param [0];
private _position = param [1];
private _vec = param [2];
private _vecnum = _vec getvariable "d_vec";
private _turret = param[3];

if ((_vec isKindOf "ParachuteBase") || {_vec isKindOf "BIS_Steerable_Parachute"}) exitWith {};

private _do_exit = false;
if ((d_pilots_only == 0) && {(_position == "driver") || {(_turret select 0 == 0) && {_position == "gunner"}}}) then {
	if (!([str _enterer, _vec] call d_fnc_checkpilot)) then {
		player action ["getOut", _vec];
		_do_exit = true;
	} else {
		if ((_vecnum == 3001) || {(_vecnum == 3004) || {(_vecnum == 3010) || {(_vecnum == 3011)}}}) then {
			if (d_chophud_on) then {
				player setVariable ["d_hud_id", _vec addAction [format ["<t color='#7F7F7F'>%1</t>", localize "STR_DOM_MISSIONSTRING_176"], {_this call d_fnc_sethud},0,-1,false]];
			} else {
				player setVariable ["d_hud_id", _vec addAction [format ["<t color='#7F7F7F'>%1</t>", localize "STR_DOM_MISSIONSTRING_177"], {_this call d_fnc_sethud},1,-1,false]];
			};			
			[_vec] spawn d_fnc_helilift;
		};
		_enterer addEventHandler ["getOutMan", {call d_fnc_checkpilotout}];
	};
};
if (_do_exit) exitWith {};
//_enterer addEventHandler ["seatSwitchedMan", {call d_fnc_checkswitchseat}];


if (_vec isKindOf "Air") then {
	if (_vec isKindOf "Helicopter") then {
		0 spawn d_fnc_chop_hudsp;
		// currently the only way to disable slingload assistant and rope action for sling loadling.
		// sadly yet another Arma bug is not fixed, therefore inputAction is also needed... http://feedback.arma3.com/view.php?id=20845
		d_heli_kh_ro = (findDisplay 46) displayAddEventHandler ["KeyDown", {(param [1] in actionKeys "HeliRopeAction" || {param [1] in actionKeys "HeliSlingLoadManager" || {inputAction "HeliRopeAction" > 0 || {inputAction "HeliSlingLoadManager" > 0}}})}];
	};
} else {
	if ((_vec isKindOf "LandVehicle" && {!(_vec isKindOf "StaticWeapon")}) || {_vec isKindOf "StaticWeapon" && {!(_vec isKindOf "StaticATWeapon")}}) then {
		[_vec] spawn d_fnc_vec_hudsp;
	};
	if (d_MHQDisableNearMT != 0 && {!d_playerInMHQ && {(_vec getVariable ["d_vec_type", ""]) == "MHQ"}}) then {
		d_playerInMHQ = true;
		[_vec] spawn d_fnc_mhqCheckNearTarget;
	};
};

if (d_with_ranked) then {
	if (_vec isKindOf "Car" || {_vec isKindOf "Air"}) then {
		[_vec] spawn d_fnc_playervectrans;
	};
	[_vec] call d_fnc_playerveccheck;
};
if (d_without_vec_ti == 0) then {
	_vec disableTIEquipment true;
};
if (d_without_vec_nvg == 0) then {
	_vec disableNVGEquipment true;
};

if (toUpper (typeOf _vec) in d_check_ammo_load_vecs) then {
	//[d_AMMOLOAD] call d_fnc_AmmoLoad;
	[d_AMMOLOAD] execFSM "fsms\fn_AmmoLoad.fsm"; // hopefully fixes a problem with Ammoload stop working because sometimes FSMs which are added in CfgFunctions do not start at all when called!
};
