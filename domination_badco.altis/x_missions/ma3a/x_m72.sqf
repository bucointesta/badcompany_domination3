// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_m72.sqf"
#include "..\..\x_setup.sqf"

d_x_sm_pos = "d_sm_72" call d_fnc_smmapos;
d_x_sm_type = "normal"; // "convoy"

if (hasInterface) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_1807";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_750";
};

if (call d_fnc_checkSHC) then {
	d_x_sm_pos params ["_poss"];
	private _vec = createVehicle [d_sm_plane, _poss, [], 0, "NONE"];
	_vec setDir (markerDir "d_sm_72");
	_vec setPos _poss;
	sleep 2.123;
	["specops", 3, "allmen", 1, _poss, 50, true] spawn d_fnc_CreateInf;
	sleep 2.221;
	["aa", 2, "tracked_apc", 1, "tank", 0, d_x_sm_pos # 1, 1, 50, true] spawn d_fnc_CreateArmor;
	[_vec] spawn d_fnc_sidesteal;
	_vec addMPEventHandler ["MPKilled", {if (isServer) then {[_this select 0] call d_fnc_sidempkilled}}];
	_vec setDamage 0;
	
	#ifdef __RHS__
		[_vec, [[],["antenna_hide",0,"sensors_hide",0]]] call BIS_fnc_initvehicle;
		private _pylons = ["rhs_mag_kab250_int","rhs_mag_kab250_int","rhs_mag_R77M","rhs_mag_R77M","rhs_mag_R74M2_int","rhs_mag_R74M2_int"];
		private _pylonPaths = (configProperties [configFile >> "CfgVehicles" >> typeof _vec >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply {getArray (_x >> "turret")};
		{ _vec removeWeaponGlobal getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon") } forEach getPylonMagazines _vec;
		{ _vec setPylonLoadout [_forEachIndex + 1, _x, true, _pylonPaths select _forEachIndex] } forEach _pylons;
	#endif
	
};
