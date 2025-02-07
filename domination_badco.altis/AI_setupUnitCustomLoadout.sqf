#include "x_setup.sqf"


#define VAN_UNIFORMS ([["U_I_C_Soldier_Para_2_F","U_I_C_Soldier_Para_3_F","U_I_C_Soldier_Para_4_F","U_I_C_Soldier_Para_1_F"],["U_I_C_Soldier_Para_3_F"]] select _isSpecops)
#define VAN_VESTS ["V_TacChestrig_oli_F","V_TacChestrig_grn_F","V_TacChestrig_cbr_F"]

#ifdef __RHS__
	#define G_ARMOR ["rhs_6b3_RPK", "rhs_6b3_VOG", "rhs_6b3_VOG_2"]
#else
	#define G_ARMOR ["V_CarrierRigKBT_01_light_EAF_F", "V_CarrierRigKBT_01_light_Olive_F"]
#endif

#define VAN_HEADGEAR ["H_Shemag_olive","H_ShemagOpen_tan"]

#ifdef __RHS__
	#define G_HELMET (["rhsgref_helmet_pasgt_olive", ""] select _isSpecops)
#else
	#define G_HELMET (["H_PASGT_basic_olive_F", "H_HelmetAggressor_F"] select _isSpecops)
#endif

#define VAN_FACEWEAR ([["G_Bandanna_tan","G_Bandanna_blk","G_Bandanna_oli","G_Bandanna_aviator"],["G_Bandanna_shades"]] select _isSpecops)

#define VAN_BACKPACKS ([["B_FieldPack_cbr","B_FieldPack_green_F","B_FieldPack_oli"], ["B_FieldPack_green_F"]] select _isSpecops)

#define VAN_RIFLE1FROM "arifle_Katiba_F"
#define VAN_RIFLE1TO (["arifle_AKM_F","arifle_AK12_F"] select _isSpecops)
#define VAN_RIFLE1TO_MAG (["30Rnd_762x39_Mag_F","30Rnd_762x39_AK12_Mag_F"] select _isSpecops)
#define VAN_RIFLE1TO_SOP ["muzzle_snds_B","optic_ACO_grn"]

#define VAN_RIFLE2FROM "arifle_Katiba_GL_F"
#define VAN_RIFLE2TO "arifle_AK12_GL_F"
#define VAN_RIFLE2TO_MAG (["30Rnd_762x39_Mag_F","30Rnd_762x39_AK12_Mag_F"] select _isSpecops)
#define VAN_RIFLE2TO_SOP ["muzzle_snds_B","optic_Arco_AK_blk_F"]

#define VAN_RIFLE3FROM "arifle_Katiba_C_F"
#define VAN_RIFLE3TO (["arifle_AKM_F","arifle_AK12_F"] select _isSpecops)
#define VAN_RIFLE3TO_MAG (["30Rnd_762x39_Mag_F","30Rnd_762x39_AK12_Mag_F"] select _isSpecops)
#define VAN_RIFLE3TO_SOP ["muzzle_snds_B","optic_ACO_grn"]

#define VAN_RIFLEDEFTO (["arifle_AKS_F","arifle_AK12U_F"] select _isSpecops)
#define VAN_RIFLEDEFTO_MAG (["30Rnd_545x39_Mag_F","30Rnd_762x39_AK12_Mag_F"] select _isSpecops)
#define VAN_RIFLEDEFTO_SOP ["muzzle_snds_B","optic_ACO_grn"]

#define VAN_MMRIFLETO (["srifle_DMR_06_hunter_F","srifle_DMR_07_blk_F"] select _isSpecops)
#define VAN_MMRIFLETO_MAG (["20Rnd_762x51_Mag","20Rnd_650x39_Cased_Mag_F"] select _isSpecops)
#define VAN_MMSCOPE (["optic_KHS_old","optic_DMS_weathered_F"] select _isSpecops)
#define VAN_MMBIPOD "bipod_03_F_blk"
#define VAN_MMRIFLETO_SOP ["muzzle_snds_H"]

#define VAN_ARTO (["arifle_RPK12_F","arifle_RPK12_F"] select _isSpecops)
#define VAN_ARTO_MAG (["75Rnd_762x39_Mag_Tracer_F","75rnd_762x39_AK12_Mag_F"] select _isSpecops)
#define VAN_ARTO_SOP ["muzzle_snds_B","optic_Arco_AK_blk_F"]

#define VAN_AAFROM "launch_O_Titan_F"
#define VAN_AATO "launch_B_Titan_olive_F"
#define VAN_AATO_MAG "Titan_AA"

#define VAN_ATFROM "launch_O_Titan_short_F"
#define VAN_ATTO "launch_RPG7_F"
#define VAN_ATTO_MAG "RPG7_F"

#ifdef __RHS__
	#define NVGFROM ""
	#define NVGTO ""
#else
	#define NVGFROM "NVGoggles_OPFOR"
	#define NVGTO "NVGoggles_INDEP"
#endif


private _isCrew = false;
if ((vehicle _this) != _this) then {
	_isCrew = true;
};

[_this, _isCrew] spawn {
	
	params ["_unit", "_isCrew"];

	// Not ideal to do it one by one this way but a sleep is needed to determine group side if different factions are used
	sleep 2;
	_grp = group _unit;
	if ((str side _grp) != d_enemy_side) exitWith {};
	
	_isSpecops = _grp getVariable ["d_isSpecOps", false];
	
	_unit unlinkItem NVGFROM;
		
	if (_isSpecops || {(call d_fnc_PlayersNumber) >= 15}) then {
		_unit addHeadgear G_HELMET;
		if (_isSpecops || {(random 1) < 0.5}) then {
			_unit linkItem (selectRandom VAN_FACEWEAR);
		};
		if (_isSpecops || {(daytime > 19) || {daytime < 5}}) then {
			_unit linkItem NVGTO;
		};
	} else {
		if ((random 1) < 0.5) then {
			_unit addheadgear (selectRandom VAN_HEADGEAR);
		} else {
			removeHeadgear _unit;
			_unit linkItem (selectRandom VAN_FACEWEAR);
		};
	};
	
	_vestItems = vestItems _unit;		
	if (_isSpecops || {(call d_fnc_PlayersNumber) >= 15}) then {
		_unit addvest (selectRandom G_ARMOR);
	} else {
		_unit addvest (selectRandom VAN_VESTS);
	};		
	_container = vestContainer _unit;
	{_container addItemCargoGlobal [_x,1];} foreach _vestItems;
	
	_uniformItems = uniformItems _unit;
	_unit forceAddUniform (selectRandom VAN_UNIFORMS);
	_container = uniformContainer _unit;
	{_container addItemCargoGlobal [_x,1];} foreach _uniformItems;
	
	if (!((backpack _unit) in ["", "rhs_rpg"])) then {
		_backpackItems = backpackItems _unit;
		removeBackpack _unit;
		_unit addBackpack (selectRandom VAN_BACKPACKS);
		_container = backpackContainer _unit;
		{_container addItemCargoGlobal [_x,1];} foreach _backpackItems;
	};
	
	
	#ifdef __RHS__
		
		#ifdef __CUP_TAKISTAN__
			[_unit, selectRandom Hz_TKfaces, selectRandom Hz_TKspeakers, -1, "", (selectRandom Hz_TKfnames) + (selectRandom Hz_TKlnames)] call BIS_fnc_setIdentity;
			
		#else
			[_unit, selectRandom Hz_RUfaces, selectRandom Hz_RUspeakers, -1, "", (selectRandom Hz_RUfnames) + (selectRandom Hz_RUlnames)] call BIS_fnc_setIdentity;
		#endif
	
		removeGoggles _unit; // RHS uses headphones as goggles so remove them just in case
		
		_mags = primaryWeaponMagazine _unit;
		if ((count _mags) > 0) then {
			_unit addMagazines [_mags select 0, 10];
		};
		
		if ((backpack _unit) == "rhs_rpg") then {
			_container = backpackContainer _unit;
			clearMagazineCargoGlobal _container;
			_container addMagazineCargoGlobal ["rhs_rpg7_PG7VL_mag", 4];
			_container addMagazineCargoGlobal ["rhs_rpg7_PG7VR_mag", 3];
		};
		
		if ((secondaryWeapon _unit) == "rhs_weap_rpg7_pgo") then {
			_unit addSecondaryWeaponItem "rhs_rpg7_PG7VL_mag";
		};
		
		switch (true) do {
		
			case ((count (primaryWeaponMagazine _unit)) > 1) : {
				_glMag = (primaryWeaponMagazine _unit) select 1;
				_unit addMagazines [_glMag, 20];
			};
		
			case ((secondaryWeapon _unit) == "rhs_weap_rpg26") : {
				if ((_grp getVariable ["vorona_diceroll", -1]) == -1) then {
					_grp setVariable ["vorona_diceroll", random 1];
				};
				if ((_grp getVariable ["vorona_diceroll", -1]) < 0.5) then {
					_unit addWeapon "launch_O_Vorona_green_F";
					_unit addSecondaryWeaponItem "Vorona_HEAT";
					_unit addBackpack "rhs_assault_umbts";
					_unit addMagazines ["Vorona_HEAT", 2];
				};
			};
			
			case (((backpack _unit) == "rhs_rpg") && {(secondaryWeapon _unit) == ""}) : {
				_unit addWeapon "rhs_weap_rpg7_pgo";	
				_unit addSecondaryWeaponItem "rhs_rpg7_PG7VL_mag";
			};
			
			case ((secondaryWeapon _unit) == "rhs_weap_igla") : {
				_unit addBackpack "rhs_assault_umbts";
				_unit addMagazines ["rhs_mag_9k38_rocket", 2];
			};
		
		};
		
		
	#else
	
		_primary = primaryWeapon _unit;
		
		_mag = "";
		_mags = primaryWeaponMagazine _unit;
		if ((count _mags) > 0) then {
			_mag = _mags select 0;
		};
		
		//if vehicle crew force into default
		if (_isCrew) then {
			_unit removeWeapon _primary;
			_primary = "hgun_esd_01_dummy_F";
		};
		
		switch ([_primary] call BIS_fnc_baseWeapon) do {
			case VAN_RIFLE2FROM : {
				_unit removeMagazines _mag;
				_unit removeWeapon _primary;
				_unit addWeapon VAN_RIFLE2TO;
				_unit addPrimaryWeaponItem VAN_RIFLE2TO_MAG;
				_unit addPrimaryWeaponItem "1Rnd_HE_Grenade_shell";			
				_unit addMagazines [VAN_RIFLE2TO_MAG, 10];
				_unit addMagazines ["1Rnd_HE_Grenade_shell", 20];
				if (_isSpecops) then {
					{
						_unit addPrimaryWeaponItem _x;
					} foreach VAN_RIFLE2TO_SOP;
				};
			};
			case VAN_RIFLE1FROM : {
				_unit removeMagazines _mag;
				_unit removeWeapon _primary;
				
				if ((secondaryWeapon _unit) != "") then {
					_unit addWeapon VAN_RIFLE1TO;
					_unit addPrimaryWeaponItem VAN_RIFLE1TO_MAG;
					_unit addMagazines [VAN_RIFLE1TO_MAG, 10];
					if (_isSpecops) then {
						{
							_unit addPrimaryWeaponItem _x;
						} foreach VAN_RIFLE1TO_SOP;
					};
				} else {
					if ((random 1) < 0.3) then {
						_unit addWeapon VAN_MMRIFLETO;
						_unit addPrimaryWeaponItem VAN_MMSCOPE;
						_unit addPrimaryWeaponItem VAN_MMRIFLETO_MAG;
						_unit addMagazines [VAN_MMRIFLETO_MAG, 12];
						if (_isSpecops) then {
							{
								_unit addPrimaryWeaponItem _x;
							} foreach VAN_MMRIFLETO_SOP;
						} else {
							_unit addPrimaryWeaponItem VAN_MMBIPOD;
						};
					} else {
						_unit addWeapon VAN_ARTO;
						_unit addPrimaryWeaponItem VAN_ARTO_MAG;
						_unit addMagazines [VAN_ARTO_MAG, 10];
						if (_isSpecops) then {
							{
								_unit addPrimaryWeaponItem _x;
							} foreach VAN_ARTO_SOP;
						};
					};
				};
			};
			case VAN_RIFLE3FROM : {
				_unit removeMagazines _mag;
				_unit removeWeapon _primary;
				_unit addWeapon VAN_RIFLE3TO;
				_unit addPrimaryWeaponItem VAN_RIFLE3TO_MAG;
				_unit addMagazines [VAN_RIFLE3TO_MAG, 10];
				if (_isSpecops) then {
					{
						_unit addPrimaryWeaponItem _x;
					} foreach VAN_RIFLE3TO_SOP;
				};
			};
			default {
				if (_mag != "") then {
					_unit removeMagazines _mag;
				};
				_unit removeWeapon _primary;
				_unit addWeapon VAN_RIFLEDEFTO;
				_unit addPrimaryWeaponItem VAN_RIFLEDEFTO_MAG;
				_unit addMagazines [VAN_RIFLEDEFTO_MAG, 10];
				if (_isSpecops) then {
					{
						_unit addPrimaryWeaponItem _x;
					} foreach VAN_RIFLEDEFTO_SOP;
				};
			};
		};
		
		_secondary = secondaryWeapon _unit;
		
		switch ([_secondary] call BIS_fnc_baseWeapon) do {
			case VAN_AAFROM : {
				_unit removeMagazines ((secondaryWeaponMagazine _unit) select 0);
				_unit removeWeapon _secondary;
				_unit addWeapon VAN_AATO;
				_unit addSecondaryWeaponItem VAN_AATO_MAG;
				_unit addMagazines [VAN_AATO_MAG, 10];
			};
			case VAN_ATFROM : {
				_unit removeMagazines ((secondaryWeaponMagazine _unit) select 0);
				_unit removeMagazines "Titan_AT";
				_unit removeMagazines "Titan_AP";
				_unit removeWeapon _secondary;
				_unit addWeapon VAN_ATTO;
				_unit addSecondaryWeaponItem VAN_ATTO_MAG;
				_unit addMagazines [VAN_ATTO_MAG, 10];
			};
			case "launch_O_Vorona_brown_F" : {
				_unit addMagazines ["Vorona_HEAT", 2];
			};
		};
		
		
	#endif

	if ((primaryWeapon _unit) != "") then {
		_unit selectWeapon (primaryWeapon _unit);
	};

};