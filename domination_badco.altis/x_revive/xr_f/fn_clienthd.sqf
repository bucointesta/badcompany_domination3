// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_clienthd.sqf"
#include "..\..\x_macros.sqf"

#define __shots ["shotBullet","shotShell","shotRocket","shotMissile","shotTimeBomb","shotMine","shotGrenade","shotSpread","shotSubmunitions","shotDeploy","shotBoundingMine","shotDirectionalBomb"]

if (isDedicated) exitWith {};

params ["_unit", "_part", "_dam", "_injurer", "_ammo", "_idx"];
__TRACE_1("","_this")
if (!alive _unit) exitWith {
	__TRACE("unit not alive, removing hd EH")
	_unit removeEventHandler ["handleDamage", _thisEventhandler];
};
if (_dam == 0) exitWith {
	__TRACE_1("exiting, unit healing","_dam")
	_dam
};
if (_unit getVariable ["xr_pluncon", false] || {xr_phd_invulnerable}) exitWith {
	__TRACE_2("exiting, unit uncon or invulnerable","_part")
	0
};
if (d_no_teamkill == 0 && {_dam >= 0.1 && {!isNull _injurer && {isPlayer _injurer && {_injurer != _unit && {isNull objectParent _unit && {side (group _injurer) == side (group _unit)}}}}}}) exitWith {
	if (_idx == -1 && {_ammo != "" && {time > (player getVariable "d_tk_cutofft") && {getText (configFile>>"CfgAmmo">>_ammo>>"simulation") in __shots}}}) then {
		_unit setVariable ["d_tk_cutofft", time + 3];
		hint format [localize "STR_DOM_MISSIONSTRING_497", name _injurer];
		[_unit, _injurer] remoteExecCall ["d_fnc_TKR", 2];
	};
	0
};

if (_dam >= 0.9 && {isNull objectParent _unit && {time > (player getVariable "d_tk_cutofft")}}) then {
	player setVariable ["d_curvismode", currentVisionMode player];
	_unit setVariable ["d_tk_cutofft", time + 3];
};

_dam