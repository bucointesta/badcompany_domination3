#include "x_setup.sqf"


#define G_UNIFORMS ([["U_I_C_Soldier_Para_2_F","U_I_C_Soldier_Para_3_F","U_I_C_Soldier_Para_4_F","U_I_C_Soldier_Para_1_F"],["U_I_C_Soldier_Para_3_F"]] select (_isSpecops || {_isOfficer}))
#define G_VESTS ["V_TacChestrig_oli_F","V_TacChestrig_grn_F","V_TacChestrig_cbr_F"]

#ifndef __RHS__
	#define G_ARMOR ["V_CarrierRigKBT_01_light_EAF_F", "V_CarrierRigKBT_01_light_Olive_F"]
	#define G_ARMOR_OFFICER "V_CarrierRigKBT_01_light_Olive_F"
#else
	#define G_ARMOR ["rhs_6b3_RPK", "rhs_6b3_VOG", "rhs_6b3_VOG_2"]
	#define G_ARMOR_OFFICER ""
#endif

#define G_HEADGEAR ["H_Shemag_olive","H_ShemagOpen_tan"]

#ifndef __RHS__
	#define G_HELMET (["H_PASGT_basic_olive_F", "H_HelmetAggressor_F"] select _isSpecops)
#else
	#define G_HELMET (["rhsgref_helmet_pasgt_olive", "rhs_altyn_novisor"] select _isSpecops)
#endif

#define G_FACEWEAR ([["G_Bandanna_tan","G_Bandanna_blk","G_Bandanna_oli","G_Bandanna_aviator"],["G_Bandanna_shades"]] select _isSpecops)

#ifndef __RHS__
	#define G_BACKPACKS ([["B_FieldPack_cbr","B_FieldPack_green_F","B_FieldPack_oli"], ["B_FieldPack_green_F"]] select _isSpecops)
#else
	#define G_BACKPACKS ([["rhs_rd54"], ["rhs_assault_umbts"]] select _isSpecops)
#endif

#define G_RIFLE1FROM "arifle_Katiba_F"
#ifndef __RHS__
	#define G_RIFLE1TO (["arifle_AKM_F","arifle_AK12_F"] select _isSpecops)
	#define G_RIFLE1TO_MAG (["30Rnd_762x39_Mag_F","30Rnd_762x39_AK12_Mag_F"] select _isSpecops)
	#define G_RIFLE1TO_SOP ["muzzle_snds_B","optic_ACO_grn"]
#else
	#define G_RIFLE1TO (["rhs_weap_akm","rhs_weap_akm_zenitco01_b33"] select _isSpecops)
	#define G_RIFLE1TO_MAG (["rhs_30Rnd_762x39mm","rhs_30Rnd_762x39mm_89"] select _isSpecops)
	#define G_RIFLE1TO_SOP ["rhs_acc_pbs1","rhs_acc_ekp8_18","rhs_acc_grip_rk6"]
#endif

#define G_RIFLE2FROM "arifle_Katiba_GL_F"
#ifndef __RHS__
	#define G_RIFLE2TO "arifle_AK12_GL_F"
	#define G_RIFLE2TO_MAG (["30Rnd_762x39_Mag_F","30Rnd_762x39_AK12_Mag_F"] select _isSpecops)
	#define G_RIFLE2TO_SOP ["muzzle_snds_B","optic_Arco_AK_blk_F"]
#else
	#define G_RIFLE2TO (["rhs_weap_akm_gp25","rhs_weap_akmn_gp25"] select _isSpecops)
	#define G_RIFLE2TO_MAG (["rhs_30Rnd_762x39mm","rhs_30Rnd_762x39mm_89"] select _isSpecops)
	#define G_RIFLE2TO_SOP ["rhs_acc_pbs1","rhs_acc_pso1m2"]
#endif

#define G_RIFLE3FROM "arifle_Katiba_C_F"
#ifndef __RHS__
	#define G_RIFLE3TO (["arifle_AKM_F","arifle_AK12_F"] select _isSpecops)
	#define G_RIFLE3TO_MAG (["30Rnd_762x39_Mag_F","30Rnd_762x39_AK12_Mag_F"] select _isSpecops)
	#define G_RIFLE3TO_SOP ["muzzle_snds_B","optic_ACO_grn"]
#else
	#define G_RIFLE3TO (["rhs_weap_akms","rhs_weap_akmn"] select _isSpecops)
	#define G_RIFLE3TO_MAG (["rhs_30Rnd_762x39mm","rhs_30Rnd_762x39mm_89"] select _isSpecops)
	#define G_RIFLE3TO_SOP ["rhs_acc_pbs1","rhs_acc_ekp1"]
#endif

#ifndef __RHS__
	#define G_RIFLEDEFTO (["arifle_AKS_F","arifle_AK12U_F"] select _isSpecops)
	#define G_RIFLEDEFTO_MAG (["30Rnd_545x39_Mag_F","30Rnd_762x39_AK12_Mag_F"] select _isSpecops)
	#define G_RIFLEDEFTO_SOP ["muzzle_snds_B","optic_ACO_grn"]
#else
	#define G_RIFLEDEFTO (["rhs_weap_aks74u","rhs_weap_aks74un"] select _isSpecops)
	#define G_RIFLEDEFTO_MAG (["rhs_30Rnd_545x39_7N6_AK","rhs_30Rnd_545x39_7U1_AK"] select _isSpecops)
	#define G_RIFLEDEFTO_SOP ["rhs_acc_tgpa","rhs_acc_ekp1"]
#endif

#ifndef __RHS__
	#define G_MMRIFLETO (["srifle_DMR_06_hunter_F","srifle_DMR_07_blk_F"] select _isSpecops)
	#define G_MMRIFLETO_MAG (["20Rnd_762x51_Mag","20Rnd_650x39_Cased_Mag_F"] select _isSpecops)
	#define G_MMSCOPE (["optic_KHS_old","optic_DMS_weathered_F"] select _isSpecops)
	#define G_MMBIPOD "bipod_03_F_blk"
	#define G_MMRIFLETO_SOP ["muzzle_snds_H"]
#else
	#define G_MMRIFLETO "rhs_weap_svdp"
	#define G_MMRIFLETO_MAG (["rhs_10Rnd_762x54mmR_7N1","rhs_10Rnd_762x54mmR_7N14"] select _isSpecops)
	#define G_MMSCOPE (["rhs_acc_pso1m2","rhs_acc_1pn34"] select _isSpecops)
	#define G_MMBIPOD "bipod_03_F_blk"
	#define G_MMRIFLETO_SOP ["rhs_acc_tgpv2"]
#endif

#ifndef __RHS__
	#define G_ARTO (["arifle_RPK12_F","arifle_RPK12_F"] select _isSpecops)
	#define G_ARTO_MAG (["75Rnd_762x39_Mag_Tracer_F","75rnd_762x39_AK12_Mag_F"] select _isSpecops)
	#define G_ARTO_SOP ["muzzle_snds_B","optic_Arco_AK_blk_F"]
#else
	#define G_ARTO (["rhs_weap_pkm","rhs_weap_rpk74m"] select _isSpecops)
	#define G_ARTO_MAG (["rhs_100Rnd_762x54mmR","rhs_60Rnd_545X39_7N22_AK"] select _isSpecops)
	#define G_ARTO_SOP ["rhs_acc_tgpa","rhs_acc_pso1m2"]
#endif


#define G_AAFROM "launch_O_Titan_F"
#ifndef __RHS__
	#define G_AATO "launch_B_Titan_olive_F"
	#define G_AATO_MAG "Titan_AA"
#else
	#define G_AATO "rhs_weap_igla"
	#define G_AATO_MAG "rhs_mag_9k38_rocket"
#endif

#define G_ATFROM "launch_O_Titan_short_F"
#ifndef __RHS__
	#define G_ATTO "launch_RPG7_F"
	#define G_ATTO_MAG "RPG7_F"
#else
	#define G_ATTO "rhs_weap_rpg7"
	#define G_ATTO_MAG "rhs_rpg7_PG7VL_mag"
#endif

#define G_NVGFROM "NVGoggles_OPFOR"
#ifndef __RHS__
	#define G_NVGTO "NVGoggles_INDEP"
#else
	#define G_NVGTO "rhs_1PN138"
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
	
	private _isOfficer = _unit isKindOf d_soldier_officer;
	private _isSniper = _unit isKindOf d_sniper;
	private _isGovMember = _unit isKindOf d_government_member;
	
	#ifdef __RHS__
		
		#ifndef __CUP_TAKISTAN__
			[_unit, selectRandom Hz_RUfaces, selectRandom Hz_RUspeakers, -1, "", (selectRandom Hz_RUfnames) + (selectRandom Hz_RUlnames)] call BIS_fnc_setIdentity;			
		#else
			private _faction = gettext (configfile >> "cfgvehicles" >> (typeof _unit) >> "faction");
			if (_faction != "OPF_F") then {
				[_unit, selectRandom Hz_TKfaces, selectRandom Hz_TKspeakers, -1, "", (selectRandom Hz_TKfnames) + (selectRandom Hz_TKlnames)] call BIS_fnc_setIdentity;
			};			
		#endif		
		
	#endif
	
	if (_isGovMember) exitWith {
		_unit addWeapon "hgun_Rook40_F";
		_unit addHandgunItem "16Rnd_9x21_Mag";
		_unit addVest "V_CarrierRigKBT_01_light_Olive_F";
		_unit addMagazines ["16Rnd_9x21_Mag", 7];
	};
	
	_isSpecops = _isSniper || {_grp getVariable ["d_isSpecOps", false]};
	
	_unit unlinkItem G_NVGFROM;
	
	if (_isOfficer) then {
		//////
	} else {
			if (_isSpecops || {(call d_fnc_PlayersNumber) >= 15}) then {
			_unit addHeadgear G_HELMET;
			if (_isSpecops || {(random 1) < 0.5}) then {
				_unit linkItem (selectRandom G_FACEWEAR);
			};
			if (_isSpecops || {(daytime > 19) || {daytime < 5}}) then {
				_unit linkItem G_NVGTO;
			};
		} else {
			if ((random 1) < 0.5) then {
				_unit addheadgear (selectRandom G_HEADGEAR);
			} else {
				removeHeadgear _unit;
				_unit linkItem (selectRandom G_FACEWEAR);
			};
		};
	};	
	
	_vestItems = vestItems _unit;
	if (_isOfficer) then {
		_unit addvest G_ARMOR_OFFICER;
	} else {
		if (_isSpecops || {(call d_fnc_PlayersNumber) >= 15}) then {
			_unit addvest (selectRandom G_ARMOR);
		} else {
			_unit addvest (selectRandom G_VESTS);
		};
	};
	_container = vestContainer _unit;
	{_container addItemCargoGlobal [_x,1];} foreach _vestItems;
	
	_uniformItems = uniformItems _unit;
	_unit forceAddUniform (selectRandom G_UNIFORMS);
	_container = uniformContainer _unit;
	{_container addItemCargoGlobal [_x,1];} foreach _uniformItems;
	
	if ((backpack _unit) != "") then {
		_backpackItems = backpackItems _unit;
		removeBackpack _unit;
		_unit addBackpack (selectRandom G_BACKPACKS);
		_container = backpackContainer _unit;
		{_container addItemCargoGlobal [_x,1];} foreach _backpackItems;
	};
	
	_primary = primaryWeapon _unit;
	
	_mag = "";
	_mags = primaryWeaponMagazine _unit;
	if ((count _mags) > 0) then {
		_mag = _mags select 0;
	};
	
	//if vehicle crew or officer force into default
	if (_isCrew || {_isOfficer}) then {
		_unit removeWeapon _primary;
		_primary = "hgun_esd_01_dummy_F";
	};
	
	if (_isSniper) then {
		_unit removeMagazines _mag;
		_unit removeWeapon _primary;
		_unit addWeapon G_MMRIFLETO;
		_unit addPrimaryWeaponItem G_MMSCOPE;
		_unit addPrimaryWeaponItem G_MMRIFLETO_MAG;
		_unit addMagazines [G_MMRIFLETO_MAG, 20];
		_unit addPrimaryWeaponItem G_MMBIPOD;
		{
			_unit addPrimaryWeaponItem _x;
		} foreach G_MMRIFLETO_SOP;
	} else {
		switch ([_primary] call BIS_fnc_baseWeapon) do {
			case G_RIFLE2FROM : {
				_unit removeMagazines _mag;
				_unit removeWeapon _primary;
				_unit addWeapon G_RIFLE2TO;
				_unit addPrimaryWeaponItem G_RIFLE2TO_MAG;
				_unit addMagazines [G_RIFLE2TO_MAG, 10];
				#ifndef __RHS__
					_unit addPrimaryWeaponItem "1Rnd_HE_Grenade_shell";
					_unit addMagazines ["1Rnd_HE_Grenade_shell", 20];
				#else
					_unit addPrimaryWeaponItem "rhs_VOG25";
					_unit addMagazines ["rhs_VOG25", 20];
				#endif
				if (_isSpecops) then {
					{
						_unit addPrimaryWeaponItem _x;
					} foreach G_RIFLE2TO_SOP;
				};
			};
			case G_RIFLE1FROM : {
				_unit removeMagazines _mag;
				_unit removeWeapon _primary;
				
				if ((secondaryWeapon _unit) != "") then {
					_unit addWeapon G_RIFLE1TO;
					_unit addPrimaryWeaponItem G_RIFLE1TO_MAG;
					_unit addMagazines [G_RIFLE1TO_MAG, 10];
					if (_isSpecops) then {
						{
							_unit addPrimaryWeaponItem _x;
						} foreach G_RIFLE1TO_SOP;
					};
				} else {
					if ((random 1) < 0.3) then {
						_unit addWeapon G_MMRIFLETO;
						_unit addPrimaryWeaponItem G_MMSCOPE;
						_unit addPrimaryWeaponItem G_MMRIFLETO_MAG;
						_unit addMagazines [G_MMRIFLETO_MAG, 20];
						_unit addPrimaryWeaponItem G_MMBIPOD;
						if (_isSpecops) then {
							{
								_unit addPrimaryWeaponItem _x;
							} foreach G_MMRIFLETO_SOP;
						};
					} else {
						_unit addWeapon G_ARTO;
						_unit addPrimaryWeaponItem G_ARTO_MAG;
						_unit addMagazines [G_ARTO_MAG, 10];
						if (_isSpecops) then {
							{
								_unit addPrimaryWeaponItem _x;
							} foreach G_ARTO_SOP;
						};
					};
				};
			};
			case G_RIFLE3FROM : {
				_unit removeMagazines _mag;
				_unit removeWeapon _primary;
				_unit addWeapon G_RIFLE3TO;
				_unit addPrimaryWeaponItem G_RIFLE3TO_MAG;
				_unit addMagazines [G_RIFLE3TO_MAG, 10];
				if (_isSpecops) then {
					{
						_unit addPrimaryWeaponItem _x;
					} foreach G_RIFLE3TO_SOP;
				};
			};
			default {
				if (_mag != "") then {
					_unit removeMagazines _mag;
				};
				_unit removeWeapon _primary;
				_unit addWeapon G_RIFLEDEFTO;
				_unit addPrimaryWeaponItem G_RIFLEDEFTO_MAG;
				_unit addMagazines [G_RIFLEDEFTO_MAG, 10];
				if (_isSpecops) then {
					{
						_unit addPrimaryWeaponItem _x;
					} foreach G_RIFLEDEFTO_SOP;
				};
			};
		};
	};
	
	_secondary = secondaryWeapon _unit;
	
	switch ([_secondary] call BIS_fnc_baseWeapon) do {
		case G_AAFROM : {
			_unit removeMagazines ((secondaryWeaponMagazine _unit) select 0);
			_unit removeWeapon _secondary;
			_unit addWeapon G_AATO;
			_unit addSecondaryWeaponItem G_AATO_MAG;
			_unit addMagazines [G_AATO_MAG, 10];
		};
		case G_ATFROM : {
			_unit removeMagazines ((secondaryWeaponMagazine _unit) select 0);
			_unit removeMagazines "Titan_AT";
			_unit removeMagazines "Titan_AP";
			_unit removeWeapon _secondary;
			_unit addWeapon G_ATTO;
			_unit addSecondaryWeaponItem G_ATTO_MAG;
			#ifndef __RHS__
				_unit addMagazines [G_ATTO_MAG, 10];
			#else
				_unit addMagazines [G_ATTO_MAG, 4];
				_unit addMagazines ["rhs_rpg7_PG7VR_mag", 3];
			#endif
		};
		case "launch_O_Vorona_brown_F" : {
			_unit addMagazines ["Vorona_HEAT", 2];
		};
	};

	if ((primaryWeapon _unit) != "") then {
		_unit selectWeapon (primaryWeapon _unit);
	};

};