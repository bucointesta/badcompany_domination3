#include "x_setup.sqf"
#define VAN_UNIFORMS ["U_I_C_Soldier_Para_2_F","U_I_C_Soldier_Para_3_F","U_I_C_Soldier_Para_4_F","U_I_C_Soldier_Para_1_F"]
#define VAN_VESTS ["V_TacChestrig_oli_F","V_TacChestrig_grn_F","V_TacChestrig_cbr_F"]
#define VAN_HEADGEAR ["H_Shemag_olive","H_ShemagOpen_tan"]
#define VAN_BACKPACKS ["B_FieldPack_cbr","B_FieldPack_green_F","B_FieldPack_oli"]

#define VAN_RIFLE1FROM "arifle_Katiba_C_F"
#define VAN_RIFLE1TO "arifle_AKM_F"
#define VAN_RIFLE1TO_MAG "30Rnd_762x39_Mag_F"

#define VAN_RIFLE2FROM "arifle_Katiba_GL_F"
#define VAN_RIFLE2TO "arifle_AK12_GL_F"
#define VAN_RIFLE2TO_MAG "30Rnd_762x39_AK12_Mag_F"

#define VAN_RIFLE3FROM "arifle_Katiba_C_F"
#define VAN_RIFLE3TO "arifle_AKS_F"
#define VAN_RIFLE3TO_MAG "30Rnd_545x39_Mag_F"

#define VAN_MMRIFLEFROM "srifle_DMR_01_F"
#define VAN_MMRIFLETO "srifle_DMR_06_hunter_F"
#define VAN_MMSCOPE "optic_KHS_old"

#define VAN_AAFROM "launch_O_Titan_F"
#define VAN_AATO "launch_B_Titan_olive_F"
#define VAN_AATO_MAG "Titan_AA"

#define VAN_ATFROM "launch_O_Titan_short_F"
#define VAN_ATTO "launch_RPG7_F"
#define VAN_ATTO_MAG "RPG7_F"

#ifdef __RHS__

	_vestItems = vestItems _this;
	_uniformItems = uniformItems _this;
	_backpackItems = backpackItems _this;

	_this addheadgear "rhs_ssh68";
	_this addvest "V_TacChestrig_oli_F";
	_container = vestContainer _this;
	{_container addItemCargoGlobal [_x,1];} foreach _vestItems;
	
#else

	_primary = primaryWeapon _this;
	_mag = (primaryWeaponMagazine _this) select 0;
	
	switch (_primary) do {
		case VAN_RIFLE2FROM : {
			_this removeMagazines _mag;
			_this removeWeapon _primary;
			_this addWeapon VAN_RIFLE2TO;
			_this addPrimaryWeaponItem VAN_RIFLE2TO_MAG;
			_this addPrimaryWeaponItem "1Rnd_HE_Grenade_shell";			
			_this addMagazines [VAN_RIFLE2TO_MAG, 10];
			_this addMagazines ["1Rnd_HE_Grenade_shell", 10];
		};
		case VAN_RIFLE1FROM : {
			_this removeMagazines _mag;
			_this removeWeapon _primary;
			_this addWeapon VAN_RIFLE1TO;
			_this addPrimaryWeaponItem VAN_RIFLE1TO_MAG;
			_this addMagazines [VAN_RIFLE1TO_MAG, 10];
		};
		default {
			_this removeMagazines _mag;
			_this removeWeapon _primary;
			_this addWeapon VAN_RIFLE3TO;
			_this addPrimaryWeaponItem VAN_RIFLE3TO_MAG;
			_this addMagazines [VAN_RIFLE3TO_MAG, 10];
		};
	};
	
	_secondary = secondaryWeapon _this;
	_mag = (secondaryWeaponMagazine _this) select 0;
	
	switch (_secondary) do {
		case VAN_AAFROM : {
			_this removeMagazines _mag;
			_this removeWeapon _secondary;
			_this addWeapon VAN_AATO;
			_this addPrimaryWeaponItem VAN_AATO_MAG;
			_this addMagazines [VAN_AATO_MAG, 10];
		};
		case VAN_ATFROM : {
			_this removeMagazines _mag;
			_this removeMagazines "Titan_AT";
			_this removeMagazines "Titan_AP";
			_this removeWeapon _secondary;
			_this addWeapon VAN_ATTO;
			_this addPrimaryWeaponItem VAN_ATTO_MAG;
			_this addMagazines [VAN_ATTO_MAG, 10];
		};
	};
	
	_vestItems = vestItems _this;
	_uniformItems = uniformItems _this;
	

	_this addvest (selectRandom VAN_VESTS);
	_container = vestContainer _this;
	{_container addItemCargoGlobal [_x,1];} foreach _vestItems;
	_this adduniform (selectRandom VAN_UNIFORMS);
	_container = uniformContainer _this;
	{_container addItemCargoGlobal [_x,1];} foreach _uniformItems;
	_this addheadgear (selectRandom VAN_HEADGEAR);
	if ((backpack _this) != "") then {
		_backpackItems = backpackItems _this;		
		_this addBackpack (selectRandom VAN_BACKPACKS);
		_container = backpackContainer _this;
		{_container addItemCargoGlobal [_x,1];} foreach _backpackItems;
		if (VAN_ATFROM_MAG in _backpackItems) then {
			_this removeMagazines "Titan_AT";
			_this removeMagazines "Titan_AP";
			_this addMagazines [VAN_ATTO_MAG, 8];
		};
	};
	_this unlinkItem "NVGoggles_OPFOR";	
	
#endif
