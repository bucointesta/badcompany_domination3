// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_dropammoboxdx.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

params ["_unit", "_caller"];

__TRACE_2("","_unit","_caller")

if (_unit == _caller) then {_unit = d_curvec_dialog};

private _chatfunc = {
	if (vehicle (_this select 1) == (_this select 0)) then {
		(_this select 0) vehicleChat (_this select 2);
	} else {
		(_this select 1) sideChat (_this select 2);
	};
};

if (_caller != driver _unit && {!isNil {_unit getVariable "d_choppertype"} && {_unit getVariable ["d_vec_type", ""] != "MHQ"}}) exitWith {
	[_unit, _caller, localize "STR_DOM_MISSIONSTRING_1428"] call _chatfunc;
};

if (d_all_ammoloads findIf {_x distance2D _unit < 20} > -1) exitWith {[_unit, _caller, localize "STR_DOM_MISSIONSTRING_217"] call _chatfunc};

if ((_unit call d_fnc_GetHeight) > 3) exitWith {_unit vehicleChat (localize "STR_DOM_MISSIONSTRING_218")};

if (speed _unit > 3) exitWith {_unit vehicleChat (localize "STR_DOM_MISSIONSTRING_219")};

/*
if (d_num_ammo_boxes > d_MaxNumAmmoboxes) exitWith {
	[_unit, _caller, format [localize "STR_DOM_MISSIONSTRING_220", d_MaxNumAmmoboxes]] call _chatfunc;
};
*/

if !(_unit getVariable ["d_ammobox", false]) exitWith {[_unit, _caller, localize "STR_DOM_MISSIONSTRING_222"] call _chatfunc};

if ((_unit getVariable ["d_ammobox_next", -1]) > time) exitWith {[_unit, _caller, format [localize "STR_DOM_MISSIONSTRING_223", round ((_unit getVariable "d_ammobox_next") - time)]] call _chatfunc};

[_unit, _caller, localize "STR_DOM_MISSIONSTRING_224"] call _chatfunc;

_unit setVariable ["d_ammobox", false, true];
_unit setVariable ["d_ammobox_next", time + d_drop_ammobox_time, true];

private _boxpos = _unit modelToWorldVisual [4,-3,0];
__TRACE_1("","_boxpos")
(boundingBoxReal _unit) params ["_p1", "_p2"];
private _maxHeight = abs ((_p2 # 2) - (_p1 # 2)) / 2;
__TRACE_1("","_maxHeight")
//_boxpos set [2, ((_unit distance (getPos _unit)) - _maxHeight) max 0];
_boxpos set [2,0];
__TRACE_1("","_boxpos")

if (_unit iskindof "Ship") then {
	_boxpos = _unit modelToWorldVisual [0,-2,2];
};

#ifndef __TT__
//create the actual box if unloading for the first time
_boxobj = _unit getVariable ["actualAmmobox",objNull];
if (isnull _boxobj) then {
	
	if (_unit iskindof "Ship") then {
		[_boxpos, _unit, true] remoteExecCall ["d_fnc_CreateDroppedBox", 2];
	} else {
		[_boxpos, _unit] remoteExecCall ["d_fnc_CreateDroppedBox", 2];
	};

} else {
	
	detach _boxobj;		
	if (_unit iskindof "Ship") then {
		#ifdef __RHS__
		_boxobj attachto [_unit,[0,-1,0.5]];
		#else
		_boxobj attachto [_unit,[0,-6,-2.5]];
		#endif
	} else {
		_boxobj setpos _boxpos;
	};
	_mname = format ["d_bm_%1", _boxpos];
	_markerName = createMarker [_mname, _boxpos];
	_markerName setMarkerShape "ICON";
	_markerName setMarkerType "hd_dot";
	_markerName setMarkerColor "ColorBlue";
	_markerName setMarkerText "Ammo box";
	_boxobj setVariable ["boxMarker",_markerName,true];
	_unit setVariable ["actualAmmobox",objNull,true];

};

#else
//[_boxpos, _unit, d_player_side] remoteExecCall ["d_fnc_CreateDroppedBox", 2];
#endif

[_unit, _caller, localize "STR_DOM_MISSIONSTRING_225"] call _chatfunc;