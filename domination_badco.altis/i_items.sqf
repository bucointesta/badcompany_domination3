// by Bucointesta
//#define __DEBUG__
#define THIS_FILE "i_items.sqf"
#include "x_setup.sqf"

// please note that in the non ranked version all weapons and items are available, no matter which rank the player has

__TRACE("i_items.sqf")

d_badco_items = [];
d_public_items = [];
d_sniping_rifles = [];
d_machineguns = [];
d_launchers = [];
d_explosives = [];

d_defaultWeapons = [];
d_defaultItems = [];
d_defaultMagazines = [];
d_defaultBackpacks = [];

d_whitelistWeapons = [];
d_whitelistItems = [];
d_whitelistMagazines = [];
d_whitelistBackpacks = [];

d_pilotWeapons = [];
d_defaultUniforms = [];

d_grenadelaunchers = ["arifle_AK12_GL_F","arifle_CTAR_GL_blk_F","arifle_CTAR_GL_ghex_F","arifle_CTAR_GL_hex_F","arifle_Mk20_GL_plain_F","arifle_Mk20_GL_F","arifle_MX_GL_F","arifle_MX_GL_Black_F","arifle_MX_GL_khk_F","arifle_SPAR_01_GL_khk_F","arifle_SPAR_01_GL_snd_F","arifle_SPAR_01_GL_blk_F","arifle_TRG21_GL_F","arifle_Katiba_GL_F"];
d_simple_optics = ["optic_Aco","optic_Aco_smg","optic_ACO_grn","optic_ACO_grn_smg","optic_Holosight","optic_Holosight_khk_F","optic_Holosight_smg","optic_Holosight_smg_khk_F","optic_Holosight_blk_F","optic_Holosight_smg_blk_F","acc_flashlight_pistol"];
d_better_optics = ["optic_Arco","optic_Arco_ghex_F","optic_Arco_blk_F","optic_ERCO_khk_F","optic_ERCO_blk_F","optic_ERCO_snd_F","optic_MRCO","optic_Hamr_khk_F","optic_DMS_ghex_F","optic_SOS_khk_F"];
d_sniper_optics = ["optic_MRD","optic_AMS","optic_AMS_khk","optic_AMS_snd","optic_KHS_hex","optic_KHS_old","optic_KHS_tan","optic_KHS_blk","optic_LRPS","optic_LRPS_ghex_F","optic_LRPS_tna_F"];
d_hitech_optics = ["optic_NVS","optic_tws","optic_tws_mg"];
d_light_armors = ["V_Chestrig_blk","V_Pocketed_black_F","V_TacVest_blk","V_BandollierB_blk","G_Balaclava_blk","G_Balaclava_combat","G_Balaclava_lowprofile","G_Bandanna_blk","H_Bandanna_gry","H_Watchcap_blk","H_Beret_blk","G_Balaclava_TI_blk_F","G_Balaclava_TI_G_blk_F"];
d_medium_armors = ["V_PlateCarrier1_blk","V_PlateCarrier2_blk","H_PASGT_basic_black_F"];
d_heavy_armors = ["V_PlateCarrierGL_blk","V_PlateCarrierSpec_blk","H_HelmetSpecO_blk"];
d_small_backpacks = ["B_AssaultPack_cbr","B_AssaultPack_dgtl","B_AssaultPack_rgr","B_AssaultPack_ocamo","B_AssaultPack_khk","B_AssaultPack_mcamo","B_AssaultPack_sgg","B_AssaultPack_tna_F","B_FieldPack_cbr","B_FieldPack_ghex_F","B_FieldPack_ocamo","B_FieldPack_khk","B_FieldPack_oli","B_FieldPack_oucamo","B_AssaultPack_blk","B_LegStrapBag_coyote_F","B_LegStrapBag_olive_F","B_LegStrapBag_black_F"];
d_medium_backpacks = ["B_Kitbag_cbr","B_Kitbag_rgr","B_Kitbag_mcamo","B_Kitbag_sgg","B_TacticalPack_blk","B_TacticalPack","B_ViperLightHarness_ghex_F","B_ViperLightHarness_hex_F","B_ViperLightHarness_khk_F", "B_ViperLightHarness_oli_F"];
d_large_backpacks = ["B_Bergen_dgtl_F","B_Bergen_hex_F","B_Bergen_mcamo_F","B_Bergen_tna_F","B_Carryall_cbr","B_Carryall_ghex_F","B_Carryall_ocamo","B_Carryall_khk","B_Carryall_mcamo","B_Carryall_oli","B_Carryall_oucamo","B_ViperHarness_blk_F","B_ViperHarness_ghex_F","B_ViperHarness_hex_F","B_ViperHarness_khk_F", "B_ViperHarness_oli_F"];
d_medic_only = ["Medikit", "U_C_Paramedic_01_F", "V_Plain_crystal_F","V_TacVestIR_blk"];
d_engineer_only =["Toolkit", "V_EOD_olive_F"];
d_sniper_only = ["U_B_FullGhillie_ard","U_B_T_FullGhillie_tna_F","U_B_FullGhillie_lsh","U_B_FullGhillie_sard","U_B_T_Sniper_F","U_B_GhillieSuit"];
d_saboteur_only = ["srifle_DMR_04_F", "srifle_DMR_04_Tan_F", "NVGogglesB_grn_F", "NVGogglesB_gry_F", "U_B_CTRG_Soldier_F", "U_B_CTRG_Soldier_2_F", "U_B_CTRG_Soldier_3_F", "H_HelmetB_TI_tna_F"];
d_pilot_uniforms = ["B_Parachute","U_B_HeliPilotCoveralls","U_B_PilotCoveralls","H_PilotHelmetFighter_B","H_PilotHelmetHeli_B"];

/*associations between container and his cargo*/
{
	private _box = _x select 0;
	private _i = 0;
	private _obj = getWeaponCargo _box;
	private _weapons = [];
	{_weapons pushBack [((_obj select 0) select _i), ((_obj select 1) select _i)]; _i = _i + 1; false} count (_obj select 0);
	_i = 0;
	_obj = getMagazineCargo _box;
	private _magazines = [];
	{_magazines pushBack [((_obj select 0) select _i), ((_obj select 1) select _i)]; _i = _i + 1; false} count (_obj select 0);
	_i = 0;
	_obj = getBackpackCargo _box;
	private _backpacks = [];
	{_backpacks pushBack [((_obj select 0) select _i), ((_obj select 1) select _i)]; _i = _i + 1; false} count (_obj select 0);
	_i = 0;
	_obj = getItemCargo _box;
	private _items = [];
	{_items pushBack [((_obj select 0) select _i), ((_obj select 1) select _i)]; _i = _i + 1; false} count (_obj select 0);
	_box setVariable ["weapons", _weapons];
	_box setVariable ["magazines", _magazines];
	_box setVariable ["backpacks", _backpacks];
	_box setVariable ["items", _items];
	if (_box in [d_ammobox_16, d_ammobox_17, d_ammobox_18, d_ammobox_19, d_ammobox_20, d_ammobox_21, d_ammobox_22, d_ammobox_23]) then {
		{d_badco_items pushBack (_x select 0); d_whitelistWeapons pushBack (_x select 0); false} count _weapons;
		{d_badco_items pushBack (_x select 0); d_whitelistMagazines pushBack (_x select 0); false} count _magazines;
		{d_badco_items pushBack (_x select 0); d_whitelistBackpacks pushBack (_x select 0); false} count _backpacks;
		{d_badco_items pushBack (_x select 0); d_whitelistItems pushBack (_x select 0); false} count _items;
	};
	if (_box in [d_ammobox_14, d_ammobox_15, d_ammobox_25, d_ammobox_5,d_ammobox_8]) then {
		{d_public_items pushBack (_x select 0); d_pilotWeapons pushBack (_x select 0); d_defaultWeapons pushBack (_x select 0); false} count _weapons;
		{d_public_items pushBack (_x select 0); d_defaultMagazines pushBack (_x select 0); false} count _magazines;
		{d_public_items pushBack (_x select 0); d_defaultBackpacks pushBack (_x select 0); false} count _backpacks;
		{d_public_items pushBack (_x select 0); d_defaultItems pushBack (_x select 0); false} count _items;
	};
	if (_box == d_ammobox_1) then {
	
		{
		
			if (!((_x select 0) in d_grenadelaunchers)) then { 
			
				d_defaultWeapons pushBack (_x select 0);
				
			};
		
		} foreach _weapons;
		
		{
		
			d_defaultMagazines pushBack (_x select 0);
		
		} foreach _magazines;
		
	};
	if ((_box == d_ammobox_2) || {_box == d_ammobox_17}) then {
		{d_machineguns pushBack (_x select 0); false} count _weapons;
	};
	if ((_box == d_ammobox_3) || {_box == d_ammobox_18}) then {
		{d_sniping_rifles pushBack (_x select 0); false} count _weapons;
	};
	if ((_box == d_ammobox_4) || {_box == d_ammobox_21}) then {
		{d_launchers pushBack (_x select 0); false} count _weapons;
	};
	if ((_box == d_ammobox_6) || {_box == d_ammobox_22}) then {
		{d_explosives pushBack (_x select 0); false} count _magazines;
	};
	if (_box == d_ammobox_11) then {
		{d_light_armors pushBack (_x select 0); d_defaultItems pushBack (_x select 0); false} count _items;
	};
	if (_box == d_ammobox_12) then {
		{d_medium_armors pushBack (_x select 0); false} count _items;
	};
	if (_box == d_ammobox_13) then {
		{d_heavy_armors pushBack (_x select 0); false} count _items;
	};
	
	if (_box == d_ammobox_9) then {
		{d_defaultUniforms pushBack (_x select 0); d_defaultItems pushBack (_x select 0); false} count _items;
	};
	
} ForEach d_static_ammoboxes;

{

	d_defaultBackpacks pushBack _x;

} foreach d_small_backpacks;

{

	d_defaultItems pushBack _x;

} foreach d_simple_optics;

{

	d_defaultItems pushBack _x;

} foreach d_better_optics;

{

	d_defaultItems pushBack _x;

} foreach d_hitech_optics;

// in case of any "contamination"...
d_whitelistWeapons = d_whitelistWeapons - d_defaultWeapons;
d_whitelistMagazines = d_whitelistMagazines - d_defaultMagazines;
d_whitelistBackpacks = d_whitelistBackpacks - d_defaultBackpacks;
d_whitelistItems = d_whitelistItems - d_defaultItems;