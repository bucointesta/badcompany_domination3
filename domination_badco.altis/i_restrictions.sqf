//#define __DEBUG__
#define THIS_FILE "i_restrictions.sqf"
#include "x_setup.sqf"

__TRACE("i_restrictions.sqf")

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

d_medium_armors = [];
d_heavy_armors = [];

d_pilotWeapons = [];
d_defaultUniforms = [];

d_grenadelaunchers = [];

d_sniper_optics = ["rhsusf_acc_M8541","rhsusf_acc_M8541_low","rhsusf_acc_M8541_low_d","rhsusf_acc_M8541_low_wd","rhsusf_acc_premier_low","rhsusf_acc_premier_anpvs27","rhsusf_acc_premier","rhsusf_acc_LEUPOLDMK4","rhsusf_acc_LEUPOLDMK4_2","rhsusf_acc_LEUPOLDMK4_d","rhsusf_acc_LEUPOLDMK4_wd","rhsusf_acc_LEUPOLDMK4_2_d","rhs_acc_dh520x56","rhs_acc_pso1m2","rhs_acc_pso1m21"];

d_small_backpacks = ["B_AssaultPack_cbr","B_AssaultPack_dgtl","B_AssaultPack_rgr","B_AssaultPack_ocamo","B_AssaultPack_khk","B_AssaultPack_mcamo","B_AssaultPack_sgg","B_AssaultPack_tna_F","B_FieldPack_cbr","B_FieldPack_ghex_F","B_FieldPack_ocamo","B_FieldPack_khk","B_FieldPack_oli","B_FieldPack_oucamo","B_AssaultPack_blk","B_LegStrapBag_coyote_F","B_LegStrapBag_olive_F","B_LegStrapBag_black_F"];
d_medium_backpacks = ["B_Kitbag_cbr","B_Kitbag_rgr","B_Kitbag_mcamo","B_Kitbag_sgg","B_TacticalPack_blk","B_TacticalPack","B_ViperLightHarness_ghex_F","B_ViperLightHarness_hex_F","B_ViperLightHarness_khk_F", "B_ViperLightHarness_oli_F"];
d_large_backpacks = ["B_Bergen_dgtl_F","B_Bergen_hex_F","B_Bergen_mcamo_F","B_Bergen_tna_F","B_Carryall_cbr","B_Carryall_ghex_F","B_Carryall_ocamo","B_Carryall_khk","B_Carryall_mcamo","B_Carryall_oli","B_Carryall_oucamo","B_ViperHarness_blk_F","B_ViperHarness_ghex_F","B_ViperHarness_hex_F","B_ViperHarness_khk_F", "B_ViperHarness_oli_F"];

d_medic_only = ["Medikit", "U_C_Paramedic_01_F", "V_Plain_crystal_F","rhsusf_iotv_ocp_Medic","rhsusf_iotv_ucp_Medic","rhsusf_mbav_medic","rhsusf_spc_corpsman","rhsusf_spcs_ocp_medic","rhsusf_spcs_ucp_medic"];
d_engineer_only = ["ToolKit", "V_EOD_olive_F","V_EOD_blue_F","V_EOD_coyote_F"];
d_sniper_only = ["U_B_FullGhillie_ard","U_B_T_FullGhillie_tna_F","U_B_FullGhillie_lsh","U_B_FullGhillie_sard","U_B_T_Sniper_F","U_B_GhillieSuit"];
d_saboteur_only = ["rhs_weap_vss", "rhs_weap_vss_grip","rhs_weap_vss_grip_npz","rhs_weap_vss_npz","rhs_weap_asval","rhs_weap_asval_grip","rhs_weap_asval_grip_npz","rhs_weap_asval_npz", "NVGogglesB_grn_F", "NVGogglesB_gry_F", "U_B_CTRG_Soldier_F", "U_B_CTRG_Soldier_2_F", "U_B_CTRG_Soldier_3_F", "H_HelmetB_TI_tna_F"];
d_pilot_uniforms = ["B_Parachute","U_B_HeliPilotCoveralls","U_B_PilotCoveralls","H_PilotHelmetFighter_B","H_PilotHelmetHeli_B"];
d_pilot_only = ["U_B_HeliPilotCoveralls","U_B_PilotCoveralls","H_PilotHelmetFighter_B","H_PilotHelmetHeli_B"];

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
		{d_badco_items pushBackUnique (_x select 0); d_whitelistWeapons pushBackUnique (_x select 0); false} count _weapons;
		{d_badco_items pushBackUnique (_x select 0); d_whitelistMagazines pushBackUnique (_x select 0); false} count _magazines;
		{d_badco_items pushBackUnique (_x select 0); d_whitelistBackpacks pushBackUnique (_x select 0); false} count _backpacks;
		{d_badco_items pushBackUnique (_x select 0); d_whitelistItems pushBackUnique (_x select 0); false} count _items;
	};
	if (_box in [d_ammobox_14, d_ammobox_15, d_ammobox_25, d_ammobox_5,d_ammobox_8]) then {
		{d_public_items pushBackUnique (_x select 0); d_pilotWeapons pushBackUnique (_x select 0); d_defaultWeapons pushBackUnique (_x select 0); false} count _weapons;
		{d_public_items pushBackUnique (_x select 0); d_defaultMagazines pushBackUnique (_x select 0); false} count _magazines;
		{d_public_items pushBackUnique (_x select 0); d_defaultBackpacks pushBackUnique (_x select 0); false} count _backpacks;
		{d_public_items pushBackUnique (_x select 0); d_defaultItems pushBackUnique (_x select 0); false} count _items;
	};
	if (_box == d_ammobox_1) then {
	
		{
		
			if (!((_x select 0) in d_grenadelaunchers)) then { 
			
				d_defaultWeapons pushBackUnique (_x select 0);
				
			};
		
		} foreach _weapons;
		
		{
		
			d_defaultMagazines pushBackUnique (_x select 0);
		
		} foreach _magazines;
		
	};
	if ((_box == d_ammobox_2) || {_box == d_ammobox_17}) then {
		{d_machineguns pushBackUnique (_x select 0); false} count _weapons;
	};
	if ((_box == d_ammobox_3) || {_box == d_ammobox_18}) then {
		{d_sniping_rifles pushBackUnique (_x select 0); false} count _weapons;
	};
	if ((_box == d_ammobox_4) || {_box == d_ammobox_21}) then {
		{d_launchers pushBackUnique (_x select 0); false} count _weapons;
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
		{d_grenadelaunchers pushBackUnique (_x select 0); false} count _weapons;
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