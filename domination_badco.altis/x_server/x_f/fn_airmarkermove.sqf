// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_airmarkermove.sqf"
#include "..\..\x_setup.sqf"

private _vec = _this;

// disable for stealth aircraft >:D
if ((_vec isKindOf "Plane_Fighter_02_Base_F") || {_vec isKindOf "RHS_T50_base"}) exitWith {};

sleep 30;

waitUntil {
	sleep 4;
	((speed _vec) > 20) || {!alive _vec} || {!canMove _vec}
};

if (alive _vec && {canMove _vec}) then {
	private _markern = format ["%1_d_am_v", _vec];
	[_markern, [0, 0, 0], "ICON", d_e_marker_color, [0.5, 0.5], localize "STR_DOM_MISSIONSTRING_963", 0, "n_air"] call d_fnc_CreateMarkerGlobal;
	while {alive _vec && {canMove _vec}} do {
		sleep (25 + random 10);
		_markern setMarkerPos (getPosWorld _vec);
	};
	deleteMarker _markern;
};