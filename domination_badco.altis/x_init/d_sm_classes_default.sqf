d_sm_fortress = "Land_Cargo_House_V2_F";
d_functionary = "C_Nikos_aged";
d_government_member = "C_Man_formal_4_F";
d_fuel_station = "Land_FuelStation_Build_F";//Land_FuelStation_Shed_F
d_sm_cargo = switch (d_enemy_side_short) do {
	//case "E": {"O_Truck_02_box_F"};
	case "E": {"I_Truck_02_covered_F"};
	case "W": {"B_Truck_01_box_F"};
	case "G": {"I_Truck_02_box_F"};
};
//d_sm_hangar = "Land_TentHangar_V1_F"; // Land_TentHangar_V1_F creates 3 objects and adding a killed eh makes it useless as the correct object might never get destroyed
d_sm_hangar = "Land_Hangar_F";
d_sm_tent = "Land_TentA_F";

d_sm_land_tankbig = "Land_dp_bigTank_old_F";
d_sm_land_transformer = "Land_dp_transformer_F";
d_sm_barracks = "Land_i_Barracks_V1_F";
d_sm_land_tanksmall = "Land_dp_smallTank_old_F";
d_sm_land_factory = "Land_Factory_Main_F";
d_sm_small_radar = "Land_MobileRadar_01_radar_F";

d_soldier_officer = switch (d_enemy_side_short) do {
	//case "E": {"O_officer_F"};
	case "E": {"O_T_Officer_F"};
	case "W": {"B_officer_F"};
	case "G": {"I_officer_F"};
};
d_sniper = switch (d_enemy_side_short) do {
	//case "E": {"O_sniper_F"};
	case "E": {"I_ghillie_ard_F"};
	case "W": {"B_sniper_F"};
	case "G": {"I_sniper_F"};
};
d_sm_arty = switch (d_enemy_side_short) do {
	//case "E": {"O_MBT_02_arty_F"};
	case "E": {"I_E_Truck_02_MRL_F"};
	case "W": {"B_MBT_01_arty_F"};
	case "G": {"B_MBT_01_arty_F"}; // no independent arty in Alpha 3
};
d_sm_plane = switch (d_enemy_side_short) do {
	//case "E": {"O_Plane_CAS_02_F"};
	case "E": {"B_T_VTOL_01_armed_F"};
	case "W": {"B_Plane_CAS_01_F"};
	case "G": {"I_Plane_Fighter_03_CAS_F"};
};
d_sm_tank = switch (d_enemy_side_short) do {
	case "E": {"O_MBT_02_railgun_F"};
	case "W": {"B_MBT_01_cannon_F"};
	case "G": {"I_MBT_03_cannon_F"};
};
d_sm_HunterGMG = switch (d_enemy_side_short) do {
	//case "E": {"O_MRAP_02_gmg_F"};
	case "E": {"O_T_MRAP_02_gmg_ghex_F"};
	case "W": {"B_MRAP_01_gmg_F"};
	case "G": {"I_MRAP_03_hmg_F"};
};
d_sm_chopper = switch (d_enemy_side_short) do {
	//case "E": {"O_Heli_Transport_04_covered_F"};
	case "E": {"B_Heli_Transport_01_pylons_F"};
	case "W": {"B_Heli_Attack_01_F"};
	case "G": {"I_Heli_light_03_F"};
};
d_sm_pilottype = switch (d_enemy_side_short) do {
	case "E": {"B_Helipilot_F"};
	case "W": {"O_helipilot_F"};
	case "G": {"B_Helipilot_F"};
};
d_sm_wrecktype = switch (d_enemy_side_short) do {
	case "E": {"Land_Wreck_Heli_Attack_01_F"};
	case "W": {"Land_UWreck_Heli_Attack_02_F"};
	case "G": {"Land_Wreck_Heli_Attack_02_F"};
};
d_sm_ammotrucktype = switch (d_enemy_side_short) do {
	//case "E": {"O_Truck_02_Ammo_F"};
	case "E": {"I_E_Truck_02_Ammo_F"};
	case "W": {"B_Truck_01_ammo_F"};
	case "G": {"I_Truck_02_ammo_F"};
};
d_sm_cargotrucktype = switch (d_enemy_side_short) do {
	//case "E": {["O_Truck_03_covered_F","O_T_Truck_03_covered_ghex_F"] select (d_tanoa)};
	case "E": {"I_Truck_02_covered_F"};
	case "W": {"B_Truck_01_covered_F"};
	case "G": {"I_Truck_02_covered_F"};
};
d_sm_fueltrucktype = switch (d_enemy_side_short) do {
	//case "E": {["O_Truck_03_fuel_F", "O_T_Truck_03_fuel_ghex_F"] select (d_tanoa)};
	case "E": {"I_E_Truck_02_fuel_F"};
	case "W": {"B_Truck_01_fuel_F"};
	case "G": {"I_Truck_02_fuel_F"};
};
d_sm_camo_net = call {
   if (d_enemy_side_short == "W") exitWith {"CamoNet_BLUFOR_big_F"};
   if (d_enemy_side_short == "E") exitWith {"CamoNet_OPFOR_big_F"};
   "CamoNet_INDP_big_F"
};
d_sm_medtrucktype = switch (d_enemy_side_short) do {
	//case "E": {"O_Truck_02_medical_F"};
	case "E": {"I_E_Truck_02_Medical_F"};
	case "W": {"B_Truck_01_medical_F"};
	case "G": {"I_Truck_02_medical_F"};
};
d_sm_deliver_truck = switch (d_enemy_side_short) do {
	case "E": {["B_Truck_01_Repair_F", "B_Truck_01_ammo_F", "B_Truck_01_fuel_F", "B_Truck_01_medical_F"]};
	case "W": {["O_Truck_03_repair_F", "O_Truck_03_ammo_F", "O_Truck_03_fuel_F", "O_Truck_03_medical_F"]};
	case "G": {["I_Truck_03_repair_F", "I_Truck_03_ammo_F", "I_Truck_03_fuel_F", "I_Truck_03_medical_F"]};
};
d_sm_cache = switch (d_enemy_side_short) do {
	case "W": {["Box_Syndicate_Ammo_F", "Box_Syndicate_Wps_F", "Box_Syndicate_WpsLaunch_F"]};
	case "E": {["Box_Syndicate_Ammo_F", "Box_Syndicate_Wps_F", "Box_Syndicate_WpsLaunch_F"]};
	case "G": {["Box_Syndicate_Ammo_F", "Box_Syndicate_Wps_F", "Box_Syndicate_WpsLaunch_F"]};
};
