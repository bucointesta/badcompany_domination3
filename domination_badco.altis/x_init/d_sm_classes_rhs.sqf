d_sm_fortress = "Land_Cargo_House_V2_F";
d_functionary = "C_Nikos_aged";
d_government_member = "C_Man_formal_4_F";
d_fuel_station = "Land_FuelStation_Build_F";//Land_FuelStation_Shed_F
d_sm_cargo = switch (d_enemy_side_short) do {
	case "E": {"rhs_typhoon_vdv"};
	case "W": {"rhsusf_M1078A1P2_B_D_CP_fmtv_usarmy"};
	case "G": {"I_Truck_02_box_F"};
};
//d_sm_hangar = "Land_TentHangar_V1_F"; // Land_TentHangar_V1_F creates 3 objects and adding a killed eh makes it useless as the correct object might never get destroyed

#ifdef __CUP_TAKISTAN__
	d_sm_hangar = "Land_Ss_hangard";
	d_sm_land_tankbig = "Land_Ind_TankBig";
	d_sm_barracks = "Land_u_Barracks_V2_F";
#else
	d_sm_hangar = "Land_Hangar_F";
	d_sm_land_tankbig = "Land_dp_bigTank_old_F";
	d_sm_barracks = "Land_Barracks_01_dilapidated_F";
#endif
d_sm_tent = "Land_TentA_F";
d_sm_land_transformer = "Land_Trafostanica_velka";
d_sm_land_tanksmall = "Land_dp_smallTank_old_F";
d_sm_land_factory = "Land_Tovarna2";
d_sm_small_radar = "rhs_p37";

d_soldier_officer = switch (d_enemy_side_short) do {
	//case "E": {"rhs_vdv_officer"};
	case "E": {"O_T_Officer_F"};
	case "W": {"rhsusf_army_ocp_officer"};
	case "G": {"I_officer_F"};
};
d_sniper = switch (d_enemy_side_short) do {
	//case "E": {"rhs_vdv_marksman"};
	case "E": {"I_ghillie_ard_F"};
	case "W": {"rhsusf_socom_marsoc_sniper_m107"};
	case "G": {"I_sniper_F"};
};
d_sm_arty = switch (d_enemy_side_short) do {
	case "E": {"rhs_2s3_tv"};
	case "W": {"rhsusf_m109d_usarmy"};
	case "G": {"B_MBT_01_arty_F"}; // no independent arty in Alpha 3
};
d_sm_plane = switch (d_enemy_side_short) do {
	case "E": {"RHS_T50_vvs_054"};
	case "W": {"rhsusf_f22"};
	case "G": {"I_Plane_Fighter_03_CAS_F"};
};
d_sm_tank = switch (d_enemy_side_short) do {
	case "E": {"rhsgref_cdf_t80uk_tv"};
	case "W": {"rhsusf_m1a2sep1tuskiid_usarmy"};
	case "G": {"I_MBT_03_cannon_F"};
};
d_sm_HunterGMG = switch (d_enemy_side_short) do {
	case "E": {"rhs_bmp3mera_msv"};
	case "W": {"rhsusf_M1237_M2_usarmy_d"};
	case "G": {"I_MRAP_03_hmg_F"};
};
d_sm_chopper = switch (d_enemy_side_short) do {
	case "E": {"RHS_Ka52_vvsc"};
	case "W": {"RHS_AH64DGrey"};
	case "G": {"I_Heli_light_03_F"};
};
d_sm_pilottype = switch (d_enemy_side_short) do {
	case "E": {"rhsusf_airforce_pilot"};
	case "W": {"rhs_pilot"};
	case "G": {"rhsusf_airforce_pilot"};
};
d_sm_wrecktype = switch (d_enemy_side_short) do {
	case "E": {"BlackhawkWreck"};
	case "W": {"Land_rhs_mi28_wreck"};
	case "G": {"BlackhawkWreck"};
};
d_sm_ammotrucktype = switch (d_enemy_side_short) do {
	case "E": {"rhsgref_cdf_gaz66_ammo"};
	case "W": {"rhsusf_M977A4_AMMO_usarmy_d"};
	case "G": {"I_Truck_02_ammo_F"};
};
d_sm_cargotrucktype = switch (d_enemy_side_short) do {
	case "E": {"rhsgref_nat_ural"};
	case "W": {"B_Truck_01_covered_F"};
	case "G": {"I_Truck_02_covered_F"};
};
d_sm_fueltrucktype = switch (d_enemy_side_short) do {
	case "E": {"rhsgref_cdf_ural_fuel"};
	case "W": {"B_Truck_01_fuel_F"};
	case "G": {"I_Truck_02_fuel_F"};
};
d_sm_camo_net = call {
   if (d_enemy_side_short == "W") exitWith {"CamoNet_BLUFOR_big_F"};
   if (d_enemy_side_short == "E") exitWith {"CamoNet_OPFOR_big_F"};
   "CamoNet_INDP_big_F"
};
d_sm_medtrucktype = switch (d_enemy_side_short) do {
	case "E": {"rhsgref_cdf_gaz66_ap2"};
	case "W": {"rhsusf_M1085A1P2_B_D_Medical_fmtv_usarmy"};
	case "G": {"I_Truck_02_medical_F"};
};
d_sm_deliver_truck = switch (d_enemy_side_short) do {
	case "E": {["rhsusf_M977A4_REPAIR_usarmy_d", "rhsusf_M977A4_AMMO_usarmy_d", "rhsusf_M978A4_BKIT_usarmy_d", "rhsusf_M1085A1P2_B_D_Medical_fmtv_usarmy"]};
	case "W": {["RHS_Ural_Repair_VDV_01", "rhs_gaz66_ammo_vdv", "RHS_Ural_Fuel_VDV_01", "rhs_gaz66_ap2_vdv"]};
	case "G": {["I_Truck_03_repair_F", "I_Truck_03_ammo_F", "I_Truck_03_fuel_F", "I_Truck_03_medical_F"]};
};
d_sm_cache = switch (d_enemy_side_short) do {
	case "W": {["Box_Syndicate_Ammo_F", "Box_Syndicate_Wps_F", "Box_Syndicate_WpsLaunch_F"]};
	case "E": {["Box_Syndicate_Ammo_F", "Box_Syndicate_Wps_F", "Box_Syndicate_WpsLaunch_F"]};
	case "G": {["Box_Syndicate_Ammo_F", "Box_Syndicate_Wps_F", "Box_Syndicate_WpsLaunch_F"]};
};