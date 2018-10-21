// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_ffunc.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

if (alive player && {isNull objectParent player && {!(player getVariable ["xr_pluncon", false]) && {!(player getVariable ["ace_isunconscious", false])}}}) then {
	d_objectID1 = cursorObject;
	if (isNull d_objectID1 || {!(d_objectID1 isKindOf "LandVehicle") || {!alive d_objectID1 || {player distance2D d_objectID1 > 8}}}) exitWith {false};
	private _vUp = vectorUpVisual d_objectID1;
	if (_vUp select 2 < 0) then {
		true
	} else {
		private _l = sqrt((_vUp select 0)^2 + (_vUp select 1)^2);
		[false, ((_vUp select 2) atan2 _l < 30)] select (_l != 0)
	};
} else {
	false
}