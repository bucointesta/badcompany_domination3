// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_createdroppedbox.sqf"
#include "..\..\x_setup.sqf"

__TRACE_1("","_this")

params ["_box_pos","_unit",["_isBoat",false]];
private _mname = format ["d_bm_%1", _box_pos];
/*
#ifndef __TT__
d_ammo_boxes pushBack [_box_pos, _mname];
#else
d_ammo_boxes pushBack [_box_pos, _mname, _this select 2];
#endif
publicVariable "d_ammo_boxes";

[_mname, _box_pos, "ICON", "ColorBlue", [0.5, 0.5], localize "STR_DOM_MISSIONSTRING_523", 0, d_dropped_box_marker] call d_fnc_CreateMarkerGlobal;
#ifdef __TT__
_mname remoteExecCall ["deleteMarkerLocal", [blufor, opfor] select (_this select 2 == blufor)];
#endif
*/

//_this remoteExecCall ["d_fnc_create_boxNet", 2];

//changed to create actual global box
_box = d_the_box createVehicle [0,0,1000];
if (_isBoat) then {
	#ifdef __RHS__
		_box attachto [_unit,[0,-1,0.5]];
	#else
		_box attachto [_unit,[0,-6,-2.5]];
	#endif
} else {
	_box setpos _box_pos;
};
_box setDamage 0.8;
_box setVariable ["d_no_lift", true, true];
_box enableRopeAttach false;
_markerName = createMarker [_mname, _box_pos];
_markerName setMarkerShape "ICON";
_markerName setMarkerType "hd_dot";
_markerName setMarkerColor "ColorBlue";
_markerName setMarkerText "Ammo box";
_box setVariable ["boxMarker",_markerName,true];
_box addEventHandler ["Killed",{

	deletemarker ((_this select 0) getVariable ["boxMarker",""]);
	d_num_ammo_boxes = d_num_ammo_boxes - 1;
	publicVariable "d_num_ammo_boxes";

}];

if (!(_unit getVariable ["d_ammobox_isEmpty", false])) then {

	//merge with launcher crate stuff -- very inefficient to do this every time but too lazy rip

	#ifdef __RHS__			
		private _createType = "rhsusf_launcher_crate";
	#else
		private _createType = "I_CargoNet_01_ammo_F";
	#endif
	_dummybox = _createType createVehicleLocal [0,0,10000];
	_itemType = (getMagazineCargo _dummybox) select 0;
	_itemType append ((getWeaponCargo _dummybox) select 0);
	_itemCount = (getMagazineCargo _dummybox) select 1;
	_itemCount append ((getWeaponCargo _dummybox) select 1);
	deleteVehicle _dummybox;
	{
		_box addItemCargoGlobal [_x,_itemCount select _foreachIndex];
	} foreach _itemType;
	#ifdef __RHS__			
		_box addItemCargoGlobal ["FirstAidKit",10];
		_box addItemCargoGlobal ["Toolkit",1];
		_box addItemCargoGlobal ["rhs_weap_m72a7",10];
		_box addItemCargoGlobal ["rhs_weap_M136",10];
	#else

	#endif

} else {

	clearItemCargoGlobal _box;
	clearBackpackCargoGlobal _box;
	clearMagazineCargoGlobal _box;
	clearWeaponCargoGlobal _box;
	
	// reset to default for the next box
	_unit setVariable ["d_ammobox_isEmpty", false, true];	

};

[_box] remoteExecCall ["KPCF_fnc_manageActions", 0, true];
