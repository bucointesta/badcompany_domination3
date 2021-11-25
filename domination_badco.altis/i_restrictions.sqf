//#define __DEBUG__
#define THIS_FILE "i_restrictions.sqf"
#include "x_setup.sqf"

__TRACE("i_restrictions.sqf")

d_badco_items = [];
d_public_items = [];
d_sniping_rifles = [];
d_machineguns = [];
d_machinegunnermags = [];
d_launchers = [];
d_explosives = ["SatchelCharge_Remote_Mag","IEDLandBig_Remote_Mag","IEDUrbanBig_Remote_Mag","IEDLandSmall_Remote_Mag","IEDUrbanSmall_Remote_Mag"];

d_defaultWeapons = [];
d_defaultItems = [];
d_defaultMagazines = [];
d_defaultBackpacks = [];

d_whitelistWeapons = [];
d_whitelistItems = [];
d_whitelistMagazines = [];
d_whitelistBackpacks = [];

d_medium_armors = [];
d_heavy_armors = [];

d_pilotWeapons = [];
d_defaultUniforms = [];

d_grenadelaunchers = [];

#ifdef __RHS__
	d_sniper_optics = ["rhsusf_acc_M8541","rhsusf_acc_M8541_low","rhsusf_acc_M8541_low_d","rhsusf_acc_M8541_low_wd","rhsusf_acc_premier_low","rhsusf_acc_premier_anpvs27","rhsusf_acc_premier","rhsusf_acc_LEUPOLDMK4","rhsusf_acc_LEUPOLDMK4_2","rhsusf_acc_LEUPOLDMK4_d","rhsusf_acc_LEUPOLDMK4_wd","rhsusf_acc_LEUPOLDMK4_2_d","rhs_acc_dh520x56","rhs_acc_pso1m2","rhs_acc_pso1m21", "rhsusf_acc_nxs_3515x50_md", "rhsusf_acc_nxs_3515x50f1_h58", "rhsusf_acc_nxs_3515x50f1_md", "rhsusf_acc_nxs_3515x50f1_h58_sun", "rhsusf_acc_nxs_3515x50f1_md_sun", "rhsusf_acc_nxs_5522x56_md", "rhsusf_acc_nxs_5522x56_md_sun"];
#else
	d_sniper_optics = ["optic_AMS","optic_AMS_khk","optic_AMS_snd","optic_KHS_hex","optic_KHS_old","optic_KHS_tan","optic_KHS_blk","optic_LRPS","optic_LRPS_ghex_F","optic_LRPS_tna_F"];
#endif

d_small_backpacks = ["B_RadioBag_01_hex_F","B_RadioBag_01_oucamo_F","B_RadioBag_01_ghex_F","B_RadioBag_01_black_F","B_RadioBag_01_digi_F","B_RadioBag_01_eaf_F","B_RadioBag_01_mtp_F","B_RadioBag_01_tropic_F","B_RadioBag_01_wdl_F","B_FieldPack_green_F","B_FieldPack_taiga_F","B_AssaultPack_eaf_F", "B_AssaultPack_wdl_F", "B_AssaultPack_cbr","B_AssaultPack_dgtl","B_AssaultPack_rgr","B_AssaultPack_ocamo","B_AssaultPack_khk","B_AssaultPack_mcamo","B_AssaultPack_sgg","B_AssaultPack_tna_F","B_FieldPack_cbr","B_FieldPack_ghex_F","B_FieldPack_ocamo","B_FieldPack_khk","B_FieldPack_oli","B_FieldPack_oucamo","B_AssaultPack_blk","B_LegStrapBag_coyote_F","B_LegStrapBag_olive_F","B_LegStrapBag_black_F"];
#ifdef __RHS__
	d_small_backpacks = d_small_backpacks + ["rhsusf_assault_eagleaiii_coy","rhsusf_assault_eagleaiii_ocp","rhsusf_assault_eagleaiii_ucp","rhsusf_falconii_coy","rhsusf_falconii_mc","rhsusf_falconii"];
#endif

d_medium_backpacks = ["B_Kitbag_tan","B_Kitbag_cbr","B_Kitbag_rgr","B_Kitbag_mcamo","B_Kitbag_sgg","B_TacticalPack_blk","B_TacticalPack","B_ViperLightHarness_ghex_F","B_ViperLightHarness_hex_F","B_ViperLightHarness_khk_F", "B_ViperLightHarness_oli_F"];
d_large_backpacks = ["B_Carryall_eaf_F","B_Carryall_green_F","B_Carryall_taiga_F","B_Carryall_wdl_F","B_Bergen_dgtl_F","B_Bergen_hex_F","B_Bergen_mcamo_F","B_Bergen_tna_F","B_Carryall_cbr","B_Carryall_ghex_F","B_Carryall_ocamo","B_Carryall_khk","B_Carryall_mcamo","B_Carryall_oli","B_Carryall_oucamo","B_ViperHarness_blk_F","B_ViperHarness_ghex_F","B_ViperHarness_hex_F","B_ViperHarness_khk_F", "B_ViperHarness_oli_F"];

d_crewman_only = ["H_HelmetCrew_B","H_HelmetCrew_I","H_HelmetCrew_I_E","H_HelmetCrew_O_ghex_F"];
#ifdef __RHS__
	d_crewman_only = d_crewman_only + ["rhsusf_cvc_helmet","rhsusf_cvc_alt_helmet","rhsusf_cvc_green_helmet","rhsusf_cvc_green_alt_helmet","rhsusf_cvc_ess","rhsusf_cvc_green_ess"];
#endif

d_medic_only = ["Medikit", "U_C_Paramedic_01_F", "V_Plain_crystal_F"];
#ifdef __RHS__
	d_medic_only = d_medic_only + ["rhsusf_iotv_ocp_Medic","rhsusf_iotv_ucp_Medic","rhsusf_mbav_medic","rhsusf_spc_corpsman","rhsusf_spcs_ocp_medic","rhsusf_spcs_ucp_medic"];
#endif

d_engineer_only = ["ToolKit", "V_EOD_olive_F","V_EOD_blue_F","V_EOD_coyote_F","IEDUrbanBig_Remote_Mag","IEDLandBig_Remote_Mag","IEDUrbanSmall_Remote_Mag","IEDLandSmall_Remote_Mag"]; //only added IEDs because they are Bad Co only and will appear on all Bad Co otherwise. The rest is handled properly by "d_explosives"
#ifdef __RHS__
	d_engineer_backpacks = ["RHS_M2_Gun_Bag","RHS_M2_Tripod_Bag","RHS_M2_MiniTripod_Bag","RHS_Mk19_Gun_Bag","RHS_Mk19_Tripod_Bag","rhs_Tow_Gun_Bag","rhs_TOW_Tripod_Bag","RHS_Metis_Gun_Bag","RHS_Metis_Tripod_Bag","RHS_Kornet_Gun_Bag","RHS_Kornet_Tripod_Bag","RHS_AGS30_Tripod_Bag","RHS_AGS30_Gun_Bag","RHS_DShkM_Gun_Bag","RHS_DShkM_TripodHigh_Bag","RHS_DShkM_TripodLow_Bag","RHS_Kord_Tripod_Bag","RHS_Kord_Gun_Bag","RHS_NSV_Tripod_Bag","RHS_NSV_Gun_Bag","RHS_SPG9_Gun_Bag","RHS_SPG9_Tripod_Bag"];
	{
		d_whitelistBackpacks pushBack _x;
	} foreach ["RHS_SPG9_Gun_Bag","RHS_SPG9_Tripod_Bag","RHS_DShkM_Gun_Bag","RHS_DShkM_TripodHigh_Bag","RHS_DShkM_TripodLow_Bag","RHS_Metis_Gun_Bag","RHS_Metis_Tripod_Bag"];
#else
	d_engineer_backpacks = ["I_G_HMG_02_high_weapon_F", "I_G_HMG_02_weapon_F", "B_HMG_01_high_weapon_F", "B_HMG_01_weapon_F", "B_GMG_01_high_weapon_F","B_GMG_01_weapon_F","B_HMG_01_support_high_F","B_HMG_01_support_F","I_G_HMG_02_support_high_F","I_C_HMG_02_support_F","B_AA_01_weapon_F","B_AT_01_weapon_F"];
	{
		d_whitelistBackpacks pushBack _x;
	} foreach ["I_G_HMG_02_high_weapon_F", "I_G_HMG_02_weapon_F","I_G_HMG_02_support_high_F","I_C_HMG_02_support_F"];
#endif

d_sniper_only = ["U_B_FullGhillie_ard","U_B_T_FullGhillie_tna_F","U_B_FullGhillie_lsh","U_B_FullGhillie_sard","U_B_T_Sniper_F","U_B_GhillieSuit"];

d_saboteur_only = ["NVGogglesB_grn_F", "NVGogglesB_gry_F", "U_B_CTRG_Soldier_F", "U_B_CTRG_Soldier_2_F", "U_B_CTRG_Soldier_3_F", "H_HelmetB_TI_tna_F"];
#ifdef __RHS__
	d_saboteur_only = d_saboteur_only + ["rhs_weap_vss", "rhs_weap_vss_grip","rhs_weap_vss_grip_npz","rhs_weap_vss_npz","rhs_weap_asval","rhs_weap_asval_grip","rhs_weap_asval_grip_npz","rhs_weap_asval_npz"];
#endif

d_pilot_only = ["U_I_pilotCoveralls","U_O_PilotCoveralls","U_B_PilotCoveralls","U_B_HeliPilotCoveralls","H_PilotHelmetFighter_B","H_PilotHelmetFighter_I","H_PilotHelmetFighter_O","H_PilotHelmetFighter_I_E","H_PilotHelmetHeli_B","H_PilotHelmetHeli_O","H_CrewHelmetHeli_B","H_CrewHelmetHeli_O","H_CrewHelmetHeli_I","H_CrewHelmetHeli_I_E","H_PilotHelmetHeli_I","H_PilotHelmetHeli_I_E"];
#ifdef __RHS__
	d_pilot_only = d_pilot_only + ["RHS_jetpilot_usaf","rhsusf_ihadss","rhsusf_hgu56p","rhsusf_hgu56p_black","rhsusf_hgu56p_green","rhsusf_hgu56p_mask","rhsusf_hgu56p_mask_black","rhsusf_hgu56p_mask_black_skull","rhsusf_hgu56p_mask_green","rhsusf_hgu56p_mask_green_mo","rhsusf_hgu56p_mask_mo","rhsusf_hgu56p_mask_pink","rhsusf_hgu56p_mask_saf","rhsusf_hgu56p_mask_skull","rhsusf_hgu56p_mask_smiley","rhsusf_hgu56p_mask_tan","rhsusf_hgu56p_pink","rhsusf_hgu56p_saf","rhsusf_hgu56p_tan","rhsusf_hgu56p_usa","rhsusf_hgu56p_visor","rhsusf_hgu56p_visor_black","rhsusf_hgu56p_visor_green","rhsusf_hgu56p_visor_mask","rhsusf_hgu56p_visor_mask_black","rhsusf_hgu56p_visor_mask_black_skull","rhsusf_hgu56p_visor_mask_Empire_black","rhsusf_hgu56p_visor_mask_green","rhsusf_hgu56p_visor_mask_green_mo","rhsusf_hgu56p_visor_mask_mo","rhsusf_hgu56p_visor_mask_pink","rhsusf_hgu56p_visor_mask_saf","rhsusf_hgu56p_visor_mask_skull","rhsusf_hgu56p_visor_mask_smiley","rhsusf_hgu56p_visor_mask_tan","rhsusf_hgu56p_visor_pink","rhsusf_hgu56p_visor_saf","rhsusf_hgu56p_visor_tan","rhsusf_hgu56p_visor_usa","rhsusf_hgu56p_visor_white"];
#endif

/*associations between container and his cargo*/
{
	private _box = _x select 0;
	private _i = 0;
	private _obj = getWeaponCargo _box;
	private _weapons = [];
	{_weapons pushBackUnique [((_obj select 0) select _i), ((_obj select 1) select _i)]; _i = _i + 1; false} count (_obj select 0);
	_i = 0;
	_obj = getMagazineCargo _box;
	private _magazines = [];
	{_magazines pushBackUnique [((_obj select 0) select _i), ((_obj select 1) select _i)]; _i = _i + 1; false} count (_obj select 0);
	_i = 0;
	_obj = getBackpackCargo _box;
	private _backpacks = [];
	{_backpacks pushBackUnique [((_obj select 0) select _i), ((_obj select 1) select _i)]; _i = _i + 1; false} count (_obj select 0);
	_i = 0;
	_obj = getItemCargo _box;
	private _items = [];
	{_items pushBackUnique [((_obj select 0) select _i), ((_obj select 1) select _i)]; _i = _i + 1; false} count (_obj select 0);
	_box setVariable ["weapons", _weapons];
	_box setVariable ["magazines", _magazines];
	_box setVariable ["backpacks", _backpacks];
	_box setVariable ["items", _items];
	if (_box in [d_ammobox_16, d_ammobox_17, d_ammobox_18, d_ammobox_19, d_ammobox_20, d_ammobox_21, d_ammobox_22, d_ammobox_23]) then {
		{_wep = [_x select 0] call BIS_fnc_baseWeapon; d_badco_items pushBackUnique _wep; d_whitelistWeapons pushBackUnique _wep; false} count _weapons;
		{d_badco_items pushBackUnique (_x select 0); d_whitelistMagazines pushBackUnique (_x select 0); false} count _magazines;
		{d_badco_items pushBackUnique (_x select 0); d_whitelistBackpacks pushBackUnique (_x select 0); false} count _backpacks;
		{d_badco_items pushBackUnique (_x select 0); d_whitelistItems pushBackUnique (_x select 0); false} count _items;
	};
	if (_box in [d_ammobox_14, d_ammobox_15, d_ammobox_25, d_ammobox_5,d_ammobox_8]) then {
		{_wep = [_x select 0] call BIS_fnc_baseWeapon; d_public_items pushBackUnique _wep; d_pilotWeapons pushBackUnique _wep; d_defaultWeapons pushBackUnique _wep; false} count _weapons;
		{d_public_items pushBackUnique (_x select 0); d_defaultMagazines pushBackUnique (_x select 0); false} count _magazines;
		{d_public_items pushBackUnique (_x select 0); d_defaultBackpacks pushBackUnique (_x select 0); false} count _backpacks;
		{d_public_items pushBackUnique (_x select 0); d_defaultItems pushBackUnique (_x select 0); false} count _items;
	};
	if (_box == d_ammobox_1) then {
	
		{
		
			if (!((_x select 0) in d_grenadelaunchers)) then { 
			
				d_defaultWeapons pushBackUnique ([_x select 0] call BIS_fnc_baseWeapon);
				
			};
		
		} foreach _weapons;
		
		{
		
			d_defaultMagazines pushBackUnique (_x select 0);
		
		} foreach _magazines;
		
	};
	if ((_box == d_ammobox_2) || {_box == d_ammobox_17}) then {
		{
			d_machineguns pushBackUnique ([_x select 0] call BIS_fnc_baseWeapon);			
		} foreach _weapons;
		{		
			d_machinegunnermags pushBackUnique (_x select 0);		
		} foreach _magazines;		
	};
	if ((_box == d_ammobox_3) || {_box == d_ammobox_18}) then {
		{d_sniping_rifles pushBackUnique ([_x select 0] call BIS_fnc_baseWeapon); false} count _weapons;
	};
	if ((_box == d_ammobox_4) || {_box == d_ammobox_21}) then {
		{d_launchers pushBackUnique ([_x select 0] call BIS_fnc_baseWeapon); false} count _weapons;
	};
	if ((_box == d_ammobox_6) || {_box == d_ammobox_22}) then {
		{d_explosives pushBackUnique (_x select 0); false} count _magazines;
	};
	if (_box == d_ammobox_11) then {
		{d_defaultItems pushBackUnique (_x select 0); false} count _items;
	};
	if (_box == d_ammobox_12) then {
		{d_medium_armors pushBackUnique (_x select 0); false} count _items;
	};
	if (_box == d_ammobox_13) then {
		{d_heavy_armors pushBackUnique (_x select 0); false} count _items;
	};
	
	if (_box == d_ammobox_9) then {
		{d_defaultUniforms pushBackUnique (_x select 0); d_defaultItems pushBackUnique (_x select 0); false} count _items;
	};
	
	if (_box == d_ammobox_0) then {
		{d_grenadelaunchers pushBackUnique ([_x select 0] call BIS_fnc_baseWeapon); false} count _weapons;
	};
	
} ForEach d_static_ammoboxes;

{

	d_defaultBackpacks pushBackUnique _x;

} foreach d_small_backpacks;

d_whitelistWeapons = d_whitelistWeapons - d_defaultWeapons;
d_whitelistMagazines = d_whitelistMagazines - d_defaultMagazines;
d_whitelistBackpacks = d_whitelistBackpacks - d_defaultBackpacks;
d_whitelistItems = d_whitelistItems - d_defaultItems;
d_badco_items = d_badco_items - d_defaultWeapons - d_defaultMagazines - d_defaultBackpacks - d_defaultItems;