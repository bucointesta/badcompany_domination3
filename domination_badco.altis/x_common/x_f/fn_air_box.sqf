// by Xeno
#define THIS_FILE "fn_air_box.sqf"
#include "..\..\x_setup.sqf"

private _box = d_the_box createVehicle [0,0,1000];
_box setPos [_this select 0, _this select 1, 0];
_box setDamage 0.9;
player reveal _box;
//[_box] call d_fnc_weaponcargo;
_box enableRopeAttach false;
private _mname = format ["d_bm_%1", getpos _box];
_markerName = createMarker [_mname, _box_pos];
_markerName setMarkerShape "ICON";
_markerName setMarkerType "hd_dot";
_markerName setMarkerColor "ColorBlue";
_markerName setMarkerText "Ammo box";
_box setVariable ["boxMarker",_markerName,true];
d_num_ammo_boxes = d_num_ammo_boxes + 1;
publicVariable "d_num_ammo_boxes";
_box addEventHandler ["Killed",{

	deletemarker ((_this select 0) getVariable ["boxMarker",""]);
	d_num_ammo_boxes = d_num_ammo_boxes - 1;
	publicVariable "d_num_ammo_boxes";

}];
/*
if (isNil "d_airboxes") then {
	d_airboxes = [];
};
_box setVariable ["d_airboxtime", time + 3600];
d_airboxes pushBack _box;
*/

