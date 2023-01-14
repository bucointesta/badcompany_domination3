#include "x_setup.sqf"
#define VAN_UNIFORMS ["U_I_C_Soldier_Para_2_F","U_I_C_Soldier_Para_3_F","U_I_C_Soldier_Para_4_F","U_I_C_Soldier_Para_1_F"]
#define VAN_VESTS ["V_TacChestrig_oli_F","V_TacChestrig_grn_F","V_TacChestrig_cbr_F"]
#define VAN_ARMOR ["V_CarrierRigKBT_01_light_EAF_F", "V_CarrierRigKBT_01_light_Olive_F"]
#define VAN_HEADGEAR ["H_Shemag_olive","H_ShemagOpen_tan"]
#define VAN_FACEWEAR ["G_Bandanna_tan","G_Bandanna_blk","G_Bandanna_oli","G_Bandanna_aviator"]

#define VAN_BACKPACKS ["B_FieldPack_cbr","B_FieldPack_green_F","B_FieldPack_oli"]

#define RHS_ARMOR ["rhs_6b3_RPK", "rhs_6b3_VOG", "rhs_6b3_VOG_2"]

#define VAN_RIFLE1FROM "arifle_Katiba_F"
#define VAN_RIFLE1TO "arifle_AKM_F"
#define VAN_RIFLE1TO_MAG "30Rnd_762x39_Mag_F"

#define VAN_RIFLE2FROM "arifle_Katiba_GL_F"
#define VAN_RIFLE2TO "arifle_AK12_GL_F"
#define VAN_RIFLE2TO_MAG "30Rnd_762x39_AK12_Mag_F"

#define VAN_RIFLE3FROM "arifle_Katiba_C_F"
#define VAN_RIFLE3TO "arifle_AKM_F"
#define VAN_RIFLE3TO_MAG "30Rnd_762x39_Mag_F"

#define VAN_RIFLEDEFTO "arifle_AKS_F"
#define VAN_RIFLEDEFTO_MAG "30Rnd_545x39_Mag_F"

#define VAN_MMRIFLEFROM "srifle_DMR_01_F"
#define VAN_MMRIFLETO "srifle_DMR_06_hunter_F"
#define VAN_MMRIFLETO_MAG "20Rnd_762x51_Mag"
#define VAN_MMSCOPE "optic_KHS_old"
#define VAN_MMBIPOD "bipod_03_F_blk"

#define VAN_ARTO "arifle_RPK12_F"
#define VAN_ARTO_MAG "75Rnd_762x39_Mag_Tracer_F"
#define VAN_ARSCOPE "optic_SOS"

#define VAN_AAFROM "launch_O_Titan_F"
#define VAN_AATO "launch_B_Titan_olive_F"
#define VAN_AATO_MAG "Titan_AA"

#define VAN_ATFROM "launch_O_Titan_short_F"
#define VAN_ATTO "launch_RPG7_F"
#define VAN_ATTO_MAG "RPG7_F"

_this spawn {

	// Not ideal to do it one by one this way but a sleep is needed to determine group side if different factions are used
	sleep 2;
	if ((str side group _this) != d_enemy_side) exitWith {};

	#ifdef __RHS__

		_vestItems = vestItems _this;
		_uniformItems = uniformItems _this;
		_backpackItems = backpackItems _this;
		
		removeGoggles _this; // RHS uses headphones as goggles so remove them just in case
		if ((call d_fnc_PlayersNumber) < 15) then {
			if ((random 1) < 0.5) then {
				_this addheadgear (selectRandom VAN_HEADGEAR);
			} else {
				removeHeadgear _this;
				_this linkItem (selectRandom VAN_FACEWEAR);
			};
		} else {
			_this addHeadgear "rhsgref_helmet_pasgt_olive";
			if ((random 1) < 0.5) then {
				_this linkItem (selectRandom VAN_FACEWEAR);
			};
		};
		
		if ((call d_fnc_PlayersNumber) < 15) then {
			_this addvest (selectRandom VAN_VESTS);
		} else {
			_this addvest (selectRandom RHS_ARMOR);
		};
		
		_container = vestContainer _this;
		{_container addItemCargoGlobal [_x,1];} foreach _vestItems;
		
		_this forceAddUniform (selectRandom VAN_UNIFORMS);
		_container = uniformContainer _this;
		{_container addItemCargoGlobal [_x,1];} foreach _uniformItems;
		
		_mags = primaryWeaponMagazine _this;
		if ((count _mags) > 0) then {
			_this addMagazines [_mags select 0, 10];
		};
		
		if ((backpack _this) == "rhs_rpg") then {
			_container = backpackContainer _this;
			clearMagazineCargoGlobal _container;
			_container addMagazineCargoGlobal ["rhs_rpg7_PG7VL_mag", 4];
			_container addMagazineCargoGlobal ["rhs_rpg7_PG7VR_mag", 3];
		};
		
		if ((secondaryWeapon _this) == "rhs_weap_rpg7_pgo") then {
			_this addSecondaryWeaponItem "rhs_rpg7_PG7VL_mag";
		};
		
		switch (true) do {
		
			case ((count (primaryWeaponMagazine _this)) > 1) : {
				_glMag = (primaryWeaponMagazine _this) select 1;
				_container = uniformContainer _this;
				_container addMagazineCargoGlobal [_glMag, 12];
			};
		
			case ((secondaryWeapon _this) == "rhs_weap_rpg26") : {
				_this addWeapon "launch_O_Vorona_green_F";
				_this addSecondaryWeaponItem "Vorona_HEAT";
				_this addBackpack "rhs_assault_umbts";
				_container = backpackContainer _this;
				_container addMagazineCargoGlobal ["Vorona_HEAT", 4];
			};
			
			case (((backpack _this) == "rhs_rpg") && {(secondaryWeapon _this) == ""}) : {
				_this addWeapon "rhs_weap_rpg7_pgo";	
				_this addSecondaryWeaponItem "rhs_rpg7_PG7VR_mag";
			};
			
			case ((secondaryWeapon _this) == "rhs_weap_igla") : {
				_this addBackpack "rhs_assault_umbts";
				_container = backpackContainer _this;
				_container addMagazineCargoGlobal ["rhs_mag_9k38_rocket", 10];
			};		
		
		};
		
		if ((backpack _this) != "") then {
			_backpackItems = backpackItems _this;		
			removeBackpack _this;
			_this addBackpack (selectRandom VAN_BACKPACKS);
			_container = backpackContainer _this;
			{_container addItemCargoGlobal [_x,1];} foreach _backpackItems;
		};
		
		
	#else

		_primary = primaryWeapon _this;
		_mag = (primaryWeaponMagazine _this) select 0;
		
		//if vehicle crew force into default
		private _vehThis = vehicle _this;
		if ((_vehThis != _this) && {!(_vehThis isKindOf d_non_steer_para)} && {_this in [driver _vehThis, gunner _vehThis, commander _vehThis]}) then {
			_this removeWeapon _primary;
			_primary = "hgun_esd_01_dummy_F";
		};
		
		switch ([_primary] call BIS_fnc_baseWeapon) do {
			case VAN_RIFLE2FROM : {
				_this removeMagazines _mag;
				_this removeWeapon _primary;
				_this addWeapon VAN_RIFLE2TO;
				_this addPrimaryWeaponItem VAN_RIFLE2TO_MAG;
				_this addPrimaryWeaponItem "1Rnd_HE_Grenade_shell";			
				_this addMagazines [VAN_RIFLE2TO_MAG, 10];
				_this addMagazines ["1Rnd_HE_Grenade_shell", 20];
			};
			case VAN_RIFLE1FROM : {
				_this removeMagazines _mag;
				_this removeWeapon _primary;
				
				if ((secondaryWeapon _this) != "") then {
					_this addWeapon VAN_RIFLE1TO;
					_this addPrimaryWeaponItem VAN_RIFLE1TO_MAG;
					_this addMagazines [VAN_RIFLE1TO_MAG, 10];
				} else {
					if ((random 1) < 0.3) then {
						_this addWeapon VAN_MMRIFLETO;
						_this addPrimaryWeaponItem VAN_MMSCOPE;
						_this addPrimaryWeaponItem VAN_MMBIPOD;
						_this addPrimaryWeaponItem VAN_MMRIFLETO_MAG;
						_this addMagazines [VAN_MMRIFLETO_MAG, 12];
					} else {
						_this addWeapon VAN_ARTO;
						_this addPrimaryWeaponItem VAN_ARSCOPE;
						_this addPrimaryWeaponItem VAN_ARTO_MAG;
						_this addMagazines [VAN_ARTO_MAG, 10];
					};
				};
			};
			case VAN_RIFLE3FROM : {
				_this removeMagazines _mag;
				_this removeWeapon _primary;
				_this addWeapon VAN_RIFLE3TO;
				_this addPrimaryWeaponItem VAN_RIFLE3TO_MAG;
				_this addMagazines [VAN_RIFLE3TO_MAG, 10];
			};
			default {
				if (!isNil "_mag") then {
					_this removeMagazines _mag;
				};				
				_this removeWeapon _primary;
				_this addWeapon VAN_RIFLEDEFTO;
				_this addPrimaryWeaponItem VAN_RIFLEDEFTO_MAG;
				_this addMagazines [VAN_RIFLEDEFTO_MAG, 10];
			};
		};
		
		_secondary = secondaryWeapon _this;
		_mag = (secondaryWeaponMagazine _this) select 0;
		
		switch ([_secondary] call BIS_fnc_baseWeapon) do {
			case VAN_AAFROM : {
				_this removeMagazines _mag;
				_this removeWeapon _secondary;
				_this addWeapon VAN_AATO;
				_this addSecondaryWeaponItem VAN_AATO_MAG;
				_this addMagazines [VAN_AATO_MAG, 10];
			};
			case VAN_ATFROM : {
				_this removeMagazines _mag;
				_this removeMagazines "Titan_AT";
				_this removeMagazines "Titan_AP";
				_this removeWeapon _secondary;
				_this addWeapon VAN_ATTO;
				_this addSecondaryWeaponItem VAN_ATTO_MAG;
				_this addMagazines [VAN_ATTO_MAG, 10];
			};
		};
		
		_vestItems = vestItems _this;
		_uniformItems = uniformItems _this;
		
		if ((call d_fnc_PlayersNumber) < 15) then {
			_this addvest (selectRandom VAN_VESTS);
		} else {
			_this addvest (selectRandom VAN_ARMOR);
		};
		
		_container = vestContainer _this;
		{_container addItemCargoGlobal [_x,1];} foreach _vestItems;
		_this forceAddUniform (selectRandom VAN_UNIFORMS);
		_container = uniformContainer _this;
		{_container addItemCargoGlobal [_x,1];} foreach _uniformItems;
		
		if ((call d_fnc_PlayersNumber) < 15) then {
			if ((random 1) < 0.5) then {
				_this addheadgear (selectRandom VAN_HEADGEAR);
			} else {
				removeHeadgear _this;
				_this linkItem (selectRandom VAN_FACEWEAR);
			};
		} else {
			_this addHeadgear "H_PASGT_basic_olive_F";
			if ((random 1) < 0.5) then {
				_this linkItem (selectRandom VAN_FACEWEAR);
			};
		};
		
		if ((backpack _this) != "") then {
			_backpackItems = backpackItems _this;		
			removeBackpack _this;
			_this addBackpack (selectRandom VAN_BACKPACKS);
			_container = backpackContainer _this;
			{_container addItemCargoGlobal [_x,1];} foreach _backpackItems;
			if ("Titan_AT" in _backpackItems) then {
				_this removeMagazines "Titan_AT";
				_this removeMagazines "Titan_AP";
				_this addMagazines [VAN_ATTO_MAG, 8];
			};
		};
		_this unlinkItem "NVGoggles_OPFOR";	
		
		if ((secondaryWeapon _this) == "launch_O_Vorona_brown_F") then {
			_container = backpackContainer _this;
			_container addMagazineCargoGlobal ["Vorona_HEAT", 2];
		};
		
	#endif

	if ((primaryWeapon _this) != "") then {
		_this selectWeapon (primaryWeapon _this);
	};

};