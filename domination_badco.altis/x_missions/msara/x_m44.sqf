// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_m44.sqf"
#include "..\..\x_setup.sqf"

d_x_sm_pos = [[9529.46,3492.03,0], [9570.09,3566.11,0]]; // index: 44,   Steal chopper prototype on San Thomas
d_x_sm_type = "normal"; // "convoy"

if (hasInterface) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_1809";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_750";
};

if (call d_fnc_checkSHC) then {
	d_x_sm_pos params ["_poss"];
	private _vec = createVehicle [d_sm_chopper, _poss, [], 0, "NONE"];
	_vec setDir 90;
	_vec setPos _poss;
	sleep 2.123;
	["specops", 1, "allmen", 1, _poss, 100, true] spawn d_fnc_CreateInf;
	sleep 2.221;
	["aa", 1, "tracked_apc", 1, "tank", 1, d_x_sm_pos # 1, 1, 140, true] spawn d_fnc_CreateArmor;
	sleep 2.543;
	[_vec] spawn d_fnc_sidesteal;
	_vec addMPEventHandler ["MPKilled", {if (isServer) then {[_this select 0] call d_fnc_sidempkilled}}];
	_vec setDamage 0;
	
	#ifdef __RHS__
		private _pylons = ["rhs_mag_b8v20a_ka52_s8t","rhs_mag_fab500_ka52","rhs_mag_apu6_9m127m_ka52","rhs_mag_apu6_9m127m_ka52","rhs_UV26_CMFlare_Chaff_Magazine_x4"];
		private _pylonPaths = (configProperties [configFile >> "CfgVehicles" >> typeof _vec >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply {getArray (_x >> "turret")};
		{ _vec removeWeaponGlobal getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon") } forEach getPylonMagazines _vec;
		{ _vec setPylonLoadout [_forEachIndex + 1, _x, true, _pylonPaths select _forEachIndex] } forEach _pylons;
	#else
    if ((typeof _vec) == "B_Heli_Transport_01_pylons_F") then {
      private _pylonPaths = (configProperties [configFile >> "CfgVehicles" >> "B_Heli_Transport_01_pylons_F" >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply {getArray (_x >> "turret")};
      private _pylons = ["PylonRack_12Rnd_PGM_missiles","PylonRack_12Rnd_missiles","PylonRack_12Rnd_missiles","PylonRack_12Rnd_PGM_missiles"];
      if ((count _pylons) > 0) then {
        { _vec removeWeaponGlobal getText (configFile >> "CfgMagazines" >> "B_Heli_Transport_01_pylons_F" >> "pylonWeapon") } forEach getPylonMagazines _vec;
        { _vec setPylonLoadout [_forEachIndex + 1, _vec, true, _pylonPaths select _forEachIndex] } forEach _pylons;
      };
    }; 
  #endif
	
};