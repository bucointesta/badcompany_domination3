// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_preinit.sqf"
#include "..\x_setup.sqf"
diag_log format ["############################# %1 #############################", missionName];
diag_log [diag_frameno, diag_ticktime, time, "Executing Dom fn_preinit.sqf"];

d_tt_ver = false;

d_tanoa = false;

d_tt_tanoa = false;

d_ifa3lite = false;
d_kbtel_chan = "SIDE";
d_cup = false;

d_HeliHEmpty = "Land_HelipadEmpty_F";

// BLUFOR, OPFOR or INDEPENDENT for own side, setup in x_setup.sqf
d_own_side = "WEST";
d_own_sides = ["WEST"];
d_own_sides_o = [blufor];
d_enemy_side = "EAST";
d_enemy_side_short = "E";

d_side_enemy = opfor;

d_side_player =	blufor;

d_version_string = "Blufor";

d_e_marker_color = "ColorOPFOR";

d_e_marker_color_alpha = 0.8;

#include "x_sm_bonus_vec_ar_altis.sqf"
#include "x_mt_bonus_vec_ar_altis.sqf"

d_sm_bonus_vehicle_array = d_sm_bonus_vehicle_array apply {toUpper _x};
d_mt_bonus_vehicle_array = d_mt_bonus_vehicle_array apply {toUpper _x};
// these vehicles can be lifted by the wreck lift chopper (previous chopper 4), but only, if they are completely destroyed
d_heli_wreck_lift_types = d_sm_bonus_vehicle_array + d_mt_bonus_vehicle_array;

//d_x_drop_array = [[], [localize "STR_DOM_MISSIONSTRING_22", ["B_MRAP_01_F", "B_T_LSV_01_unarmed_F"] select d_tanoa], [localize "STR_DOM_MISSIONSTRING_20", "Box_NATO_Ammo_F"]];
d_x_drop_array = [[], [localize "STR_DOM_MISSIONSTRING_22", "B_MRAP_01_F"], [localize "STR_DOM_MISSIONSTRING_20", "B_CargoNet_01_ammo_F"]];

// side of the pilot that will fly the drop air vehicle
d_drop_side = d_own_side;

// d_jumpflag_vec = empty ("") means normal jump flags for HALO jump get created
// if you add a vehicle typename to d_jumpflag_vec (d_jumpflag_vec = "B_Quadbike_01_F"; for example) only a vehicle gets created and no HALO jump is available
//d_jumpflag_vec = "B_Quadbike_01_F";
d_jumpflag_vec = "";

// please note, player string names are case sensitive! You have to use exactly the same case as in the editor here!
d_player_entities = ["d_rifleman_1","d_rifleman_2","d_rifleman_3","d_rifleman_4","d_rifleman_5","d_rifleman_6","d_grenadier_1","d_grenadier_2","d_grenadier_3","d_grenadier_4","d_grenadier_5","d_grenadier_6","d_autorifleman_1","d_autorifleman_2","d_autorifleman_3","d_autorifleman_4","d_autorifleman_5","d_autorifleman_6","d_missilesp_1","d_missilesp_2","d_missilesp_3","d_missilesp_4","d_missilesp_5","d_missilesp_6","d_marksman_1","d_marksman_2","d_marksman_3","d_marksman_4","d_marksman_5","d_marksman_6","d_spotter_1","d_spotter_2","d_spotter_3","d_spotter_4","d_spotter_5","d_spotter_6","d_engineer_1","d_engineer_2","d_engineer_3","d_engineer_4","d_engineer_5","d_engineer_6","d_saboteur_1","d_saboteur_2","d_saboteur_3","d_saboteur_4","d_saboteur_5","d_saboteur_6","d_medic_1","d_medic_2","d_medic_3","d_medic_4","d_medic_5","d_medic_6","d_leader_1","d_artop_1","d_apilot_1","d_apilot_2","d_tpilot_1","d_tpilot_2","d_tpilot_3","d_tpilot_4","d_badco_1","d_badco_2","d_badco_3","d_badco_4","d_badco_5","d_badco_6","d_badco_7","d_badco_8","d_badco_9","d_badco_10","d_admin"];

d_servicepoint_building = "Land_Cargo_House_V2_F";

d_illum_tower = "Land_TTowerBig_2_F";
d_wcamp = "Land_Cargo_Patrol_V1_F";

d_mash = "Land_TentDome_F";
d_mash_flag = "Flag_RedCrystal_F";

d_dropped_box_marker = "mil_marker";

d_strongpointmarker = "mil_objective";

d_flag_str_blufor = "\a3\data_f\flags\flag_blue_co.paa";
d_flag_str_opfor = "\a3\data_f\flags\flag_red_co.paa";
d_flag_str_independent = "\a3\data_f\flags\flag_green_co.paa";

d_SlopeObject = "Logic" createVehicleLocal [0,0,0];

d_cargo_chute =	"B_Parachute_02_F";

d_flag_pole = "FlagPole_F";

d_vec_camo_net = "CamoNet_BLUFOR_big_F";

// internal
d_sm_winner = 0;
d_objectID1 = objNull;
d_objectID2 = objNull;

// no farps in A3 so we fake them
// first entry should always be a helipad because the trigger which is needed to make it work is spawned there
// second object is also needed, remove action gets added on the second object
d_farp_classes = ["Land_HelipadSquare_F", "Land_Cargo20_military_green_F","Land_RepairDepot_01_green_F"];

/*roles*/
d_badcompany = ["d_badco_1", "d_badco_2", "d_badco_3", "d_badco_4", "d_badco_5", "d_badco_6", "d_badco_7", "d_badco_8", "d_badco_9", "d_badco_10", "admin"];
d_attack_pilots = ["d_apilot_1", "d_apilot_2", "d_badco_2", "d_admin"];
d_transport_pilots = ["d_tpilot_1", "d_tpilot_2", "d_tpilot_3", "d_tpilot_4", "d_badco_2", "d_admin"];
d_riflemen = ["d_rifleman_1","d_rifleman_2", "d_rifleman_3", "d_rifleman_4", "d_rifleman_5", "d_rifleman_6", "d_badco_10", "d_admin"];
d_grenadiers = ["d_grenadier_1","d_grenadier_2", "d_grenadier_3", "d_grenadier_4", "d_grenadier_5", "d_grenadier_6", "d_badco_9", "d_admin"];
d_autoriflemen = ["d_autorifleman_1","d_autorifleman_2", "d_autorifleman_3", "d_autorifleman_4", "d_autorifleman_5", "d_autorifleman_6", "d_badco_6", "d_admin"];
d_snipers = ["d_marksman_1","d_marksman_2", "d_marksman_3", "d_marksman_4", "d_marksman_5", "d_marksman_6", "d_badco_5", "d_admin"];
d_spotters = ["d_spotter_1","d_spotter_2", "d_spotter_3", "d_spotter_4", "d_spotter_5", "d_spotter_6", "d_admin"];
d_missilesp = ["d_missilesp_1","d_missilesp_2", "d_missilesp_3", "d_missilesp_4", "d_missilesp_5", "d_missilesp_6", "d_badco_7", "d_badco_8", "d_admin"];
d_saboteurs = ["d_saboteur_1","d_saboteur_2", "d_saboteur_3", "d_saboteur_4", "d_saboteur_5", "d_saboteur_6", "d_admin"];
d_medics = ["d_medic_1","d_medic_2", "d_medic_3", "d_medic_4", "d_medic_5", "d_medic_6", "d_badco_3", "d_admin"];
d_leaders = ["d_leader_1","d_leader_2", "d_leader_3", "d_leader_4", "d_leader_5", "d_leader_6", "d_badco_1", "d_admin"];

// is engineer
d_is_engineer = ["d_engineer_1","d_engineer_2","d_engineer_3","d_engineer_4","d_engineer_5","d_engineer_6","d_badco_4","d_admin"];

// artillery operators
d_can_use_artillery = ["d_artop_1", "d_admin"]; // case has to be the same as in mission.sqm, d_artop_1 D_ARTOP_1 is not the same :)

// those units can mark artillery targets but can not call in artillery strikes (only d_can_use_artillery can call in artillery strikes and also mark arty targets)
d_can_mark_artillery = ["d_spotter_1", "d_spotter_2", "d_spotter_3", "d_spotter_4", "d_spotter_5", "d_spotter_6", "d_badco_1", "d_admin"];

d_can_call_cas = ["d_badco_1", "d_admin"];

d_arty_m_marker = "b_art";

d_color_m_marker = "ColorWEST";

d_cas_available_time = 600; // time till CAS is available again!

d_non_steer_para = "NonSteerable_Parachute_F";

private _isserv_or_hc = isServer || {!isDedicated && {!hasInterface}};

if (_isserv_or_hc) then {
	__TRACE_1("","_isserv_or_hc")
	d_player_store = d_HeliHEmpty createVehicleLocal [0, 0, 0];
	d_placed_objs_store = d_HeliHEmpty createVehicleLocal [0, 0, 0];
	d_placed_objs_store2 = d_HeliHEmpty createVehicleLocal [0, 0, 0];
	d_placed_objs_store3 = d_HeliHEmpty createVehicleLocal [0, 0, 0];
};

if (isServer) then {
	d_with_ace = isClass (configFile>>"CfgPatches">>"ace_main");
	publicVariable "d_with_ace";
	call compile preprocessFileLineNumbers "x_init\x_initcommon.sqf";
	
	d_house_objects = [];
	d_house_objects2 = [];
};

if (_isserv_or_hc) then {
	if (isServer) then {
		if (d_weather == 0) then {
			0 setOvercast (random 0.5);
			if (d_enable_fog == 0) then {
				private _fog = if (random 100 > 90) then {
					[random 0.1, 0.1, 20 + (random 40)]
				} else {
					[0,0,0]
				};
				__TRACE_1("","_fog")
				0 setFog _fog;
			} else {
				0 setFog [0, 0, 0];
				0 spawn {
					sleep 100;
					0 setFog [0, 0, 0];
				};
			};
			forceWeatherChange;
			if (d_WithWinterWeather == 0) then {
				d_winterw = [0, [2, 1] select (rain <= 0.3)] select (overcast > 0.5);
				publicVariable "d_winterw";
			};
		} else {
			0 setFog [0, 0, 0];
			0 setOvercast 0;
			0 spawn {
				while {true} do {
					sleep 100;
					0 setOvercast 0;
					0 setFog [0, 0, 0];
				};
			};
		};
		
/*		if (d_timemultiplier > 1) then {
			setTimeMultiplier d_timemultiplier;
		};*/
		
		d_fifo_ar = [];
	};	
	
	// _E = Opfor
	// _W = Blufor
	// _G = Independent
	// this is what gets spawned
	d_allmen_E = [
		#include "d_allmen_O_default.sqf"
	];
	d_allmen_W = [
		#include "d_allmen_B_default.sqf"
	];
	d_allmen_G = [
		#include "d_allmen_G_default.sqf"
	];
	d_specops_E = [
		#include "d_specops_O_default.sqf"
	];
	
	d_specops_W = [["West","BLU_F","Infantry","BUS_ReconTeam"] call d_fnc_GetConfigGroup];
	d_specops_G = [["I_G_Soldier_exp_F", "I_Soldier_exp_F", "I_G_Soldier_GL_F", "I_G_medic_F"]];

	d_veh_a_E = [
		#include "d_veh_a_O_default.sqf"
	];

	d_veh_a_W = [
		#include "d_veh_a_B_default.sqf"
	];
		
	d_veh_a_G = [
		#include "d_veh_a_G_default.sqf"
	];

	d_arti_observer_E = [["O_recon_JTAC_F"]];
	d_arti_observer_W = [["B_recon_JTAC_F"]];
	d_arti_observer_G = [["I_Soldier_TL_F"]];
	
	d_number_attack_planes = 1;
	d_number_attack_choppers = 1;
	
	// Type of aircraft, that will air drop stuff
	d_drop_aircraft =
		"B_Heli_Transport_03_unarmed_F";
	//	"B_Heli_Transport_01_camo_F";

	if (isServer && {!d_no_ai}) then {
		d_taxi_aircraft =
			"B_Heli_Transport_01_camo_F";
	};
	
	d_cas_plane = "B_Plane_CAS_01_F";

	// max men for main target clear
	d_man_count_for_target_clear = 6;
	// max tanks for main target clear
	d_tank_count_for_target_clear = 1;
	// max cars for main target clear
	d_car_count_for_target_clear = 1;
		
	// time (in sec) between attack planes and choppers over main target will respawn once they were shot down (a random value between 0 and 240 will be added)
	d_airai_respawntime = 1200;

	d_side_missions_random = [];
	d_player_created = [];

	// don't remove d_recapture_indices even if you set d_WithRecapture to 1
	d_recapture_indices = [];

	// max number of cities that the enemy will recapture at once
	// if set to -1 no check is done
	d_max_recaptures = 2;

	d_time_until_next_sidemission = [
		[10,300], // if player number <= 10, it'll take 300 seconds until the next sidemission
		[20,400], // if player number <= 20, it'll take 400 seconds until the next sidemission
		[30,500], // if player number <= 30, it'll take 500 seconds until the next sidemission
		[40,600] // if player number <= 40, it'll take 600 seconds until the next sidemission
	];

	d_civilians_t = ["C_man_1","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F"];
	
	d_base_aa_vec =
	"B_APC_Tracked_01_AA_F";
	
	d_wreck_cur_ar = [];
	
#include "d_sm_classes_default.sqf"
	
	d_intel_unit = objNull;

	d_ArtyShellsBlufor = [
		"Sh_120mm_HE", // HE
		"Smoke_120mm_AMOS_White", // Smoke
		"G_40mm_HE" // dpicm
	];

	d_ArtyShellsOpfor = [
		"Sh_120mm_HE", // HE
		"Smoke_120mm_AMOS_White", // Smoke
		"G_40mm_HE" // dpicm
	];

	d_all_simulation_stoped = false;

	d_hd_sim_types = ["SHOTPIPEBOMB", "SHOTTIMEBOMB", "SHOTDIRECTIONALBOMB", "SHOTMINE"];
	d_hd_sim_types apply {toUpper _x};

	d_isle_defense_marker = "n_mech_inf";

	d_air_radar = "Land_Radar_Small_F";

	d_enemy_hq = "Land_Cargo_HQ_V1_F";

	// type of enemy plane that will fly over the main target
	d_airai_attack_plane = ["O_Plane_CAS_02_F", "O_Plane_Fighter_02_F", "I_Plane_Fighter_03_AA_F"];

	// type of enemy chopper that will fly over the main target
	d_airai_attack_chopper = ["O_Heli_Attack_02_F"];

	// enemy parachute troops transport chopper
	d_transport_chopper = ["O_T_VTOL_02_infantry_grey_F", "I_Heli_Transport_02_F"];

	// light attack chopper (for example I_Heli_light_03_F with MG)
	d_light_attack_chopper = ["O_Heli_Attack_02_black_F", "I_Heli_light_03_F"];
	
};

if (hasInterface) then {
	__TRACE("preInit hasInterface")
	// d_reserved_slot gives you the ability to add a reserved slot for admins
	// if you don't log in when you've chosen the slot, you'll get kicked after ~20 once the intro ended
	// default is no check, example: d_reserved_slot = "d_artop_1";
	d_reserved_slot = "d_admin";

	// d_uid_reserved_slots and d_uids_for_reserved_slots gives you the possibility to limit a slot
	// you have to add the var names of the units to d_uid_reserved_slots and in d_uids_for_reserved_slots the UIDs of valid players
	// d_uid_reserved_slots = ["d_alpha_1", "d_bravo_3"];
	// d_uids_for_reserved_slots = ["1234567", "7654321"];
	d_uid_reserved_slots = ["d_badco_1","d_badco_2","d_badco_3","d_badco_4","d_badco_5","d_badco_6","d_badco_7","d_badco_8","d_badco_9","d_badco_10"];
	//	d_uids_for_reserved_slots = [];
	
	// this vehicle will be created if you use the "Create XXX" at a mobile respawn (old "Create Motorcycle") or at a jump flag
	// IMPORTANT !!!! for ranked version !!!!
	// if there is more than one vehicle defined in the array the vehicle will be selected by player rank
	// one vehicle only, vehicle is only available when the player is at least lieutenant
	d_create_bike = ["B_Quadbike_01_F", "B_LSV_01_unarmed_F"];

	if (d_weather == 1) then {
		0 setOvercast 0;
	};
	
	d_UAV_Small = "B_UAV_01_F";
	d_UAV_Terminal = "B_UavTerminal";
	
	d_still_in_intro = true;

	d_cur_sm_txt = "";
	d_current_mission_resolved_text = "";

	// ammobox handling (default, loading and dropping boxes) it means the time diff in seconds before a box can be loaded or dropped again in a vehicle
	d_drop_ammobox_time = 10;
	d_current_truck_cargo_array = [];
	// d_check_ammo_load_vecs
	// the only vehicles that can load an ammo box are the transport choppers and MHQs__
	d_check_ammo_load_vecs =
	["C_Van_01_box_F", "B_Truck_01_box_F", "B_Truck_01_ammo_F", "B_Truck_01_covered_F", "B_MRAP_01_F", "B_APC_Tracked_01_CRV_F", "B_T_APC_Tracked_01_CRV_F", "B_Boat_Armed_01_minigun_F", "B_Heli_Transport_01_F", "B_Heli_Transport_01_camo_F", "B_Heli_Transport_03_F", "B_Heli_Transport_03_unarmed_F", "B_Heli_Transport_03_black_F", "B_LSV_01_unarmed_F", "O_Heli_Light_02_unarmed_F", "O_Heli_Light_02_dynamicLoadout_F"];
	
	d_check_ammo_load_vecs = d_check_ammo_load_vecs apply {toUpper _x};

	d_weapon_respawn = true;

	// points needed to get a specific rank
	// gets even used in the unranked versions, though it's just cosmetic there
	d_points_needed = [
		20, // Corporal
		50, // Sergeant
		90, // Lieutenant
		140, // Captain
		200, // Major
		270 // Colonel
	];
	
	d_points_needed_db = [
		3000, // Corporal
		8000, // Sergeant
		15000, // Lieutenant
		30000, // Captain
		70000, // Major
		140000 // Colonel
	];

	d_marker_vecs = [];
	d_mhq_3ddraw = [];


	// can call in air drop
	d_can_call_drop_ar = ["d_leader_1","d_leader_2","d_leader_3","d_leader_4","d_leader_5","d_leader_6","d_badco_1","d_admin"];

	d_chophud_on = true;

	d_jump_helo = "B_Heli_Transport_01_F";
	
	d_headbug_vehicle = "B_Quadbike_01_F";
	
	d_drop_max_dist = 500;

	// if the array is empty, anybody with a pilot uniform and headgear can fly (if the latter is enabled)
	// if you add the string name of playable units (var name in the editor) only those players get a pilot uniform and headgear
	// makes only sense when only pilots can fly is enabled
	// for example: ["pilot_1","pilot_2"];, case sensitiv
	// PLEASE DO NOT CHANGE THIS FOR THE TT VERSION, IT SHOULD BE AN EMPTY ARRAY!!!!
	d_only_pilots_can_fly = [];
	
//	d_the_box = "Box_NATO_Wps_F";
	d_the_box = "B_CargoNet_01_ammo_F";
	
	d_the_base_box = "B_supplyCrate_F";//Box_NATO_WpsSpecial_F
	
	d_rev_respawn_vec_types = [d_the_box, "B_MRAP_01_F", "O_MRAP_02_F", "I_MRAP_03_F", "B_APC_Tracked_01_CRV_F","LIB_US6_Tent"];

	// internal variables
	d_flag_vec = objNull;
	d_rscspect_on = false;
	d_player_can_call_drop = 0;
	d_player_can_call_arti = 0;
	d_player_can_call_cas = 0;
	d_eng_can_repfuel = false;
	d_there_are_enemies_atbase = false;
	d_enemies_near_base = false;
	d_player_is_medic = false;
	d_vec_end_time = -1;
	d_rscCrewTextShownTimeEnd = -1;
	d_commandingMenuIniting = false;
	d_DomCommandingMenuBlocked = false;
	d_playerInMHQ = false;
	d_player_in_vec = false;
	d_clientScriptsAr = [false, false];
	d_areArtyVecsAvailable = false;
	d_ao_arty_vecs = [];
	d_misc_store = d_HeliHEmpty createVehicleLocal [0,0,0];
	
	d_virtual_entities = ["d_virt_man_1", "d_virt_man_2", "d_virt_man_3", "d_virt_man_4", "d_virt_man_5"];
	
	// If you want to add additional non MHQ respawn points like additional bases for example
	// Usage: Each point array needs a unique name, position or marker name, description and a side (side is only valid for the TT version)
	// please note, markerPos "somemarker" does not work in prenit, it always returns [0,0,0] as position, so only use the marker name
	// Example:
	//d_additional_respawn_points = [
	//	["D_UNIQUE_NAME_1", [1023, 5000, 4000], "My Cool Base", blufor],
	//	["D_UNIQUE_NAME_2", "myevencoolerbase", "My Even Cooler Base", blufor],
	//	["D_UNIQUE_NAME_3", "opforbase", "The Opfor Base", opfor],
	//	["D_UNIQUE_NAME_2", "myevencoolerbase", "My Even Cooler Base", blufor]
	//];
	d_additional_respawn_points = [];
	
	d_last_beam_target = "";
	
	d_add_resp_points_uni = [];
	{
		d_add_resp_points_uni pushBack (_x select 0);
		false
	} count d_additional_respawn_points;
	
	d_earplugs_fitted = false;
	
	d_phud_loc883 = localize "STR_DOM_MISSIONSTRING_883"; //Uncon
	d_phud_loc884 = localize "STR_DOM_MISSIONSTRING_884"; //Medic
	d_phud_loc886 = localize "STR_DOM_MISSIONSTRING_906"; //Error: No Unit
	d_phud_loc493 = localize "STR_DOM_MISSIONSTRING_493"; //Dead
	
	if (isMultiplayer) then {
		// does work but not in EDEN preinit!!!
		// In 1.60 not working EachFrame in EDEN preinit is fixed.... PreloadFinished still doesn't work...
		d_prl_fin_id = addMissionEventHandler ["PreloadFinished", {
			d_preloaddone = true;
			diag_log [diag_frameno, diag_ticktime, time, "Preload finished"];
			removeMissionEventHandler ["PreloadFinished", d_prl_fin_id];
			d_prl_fin_id = nil;
		}];
	} else {
		d_prl_fin_id = ["DOM_PRL_ID", "onPreloadFinished", {
			d_preloaddone = true;
			diag_log [diag_frameno, diag_ticktime, time, "Preload finished"];
			[d_prl_fin_id, "onPreloadFinished"] call bis_fnc_removeStackedEventHandler;
			d_prl_fin_id = nil;
		}] call bis_fnc_addStackedEventHandler;
	};
	
	d_client_check_init = addMissionEventhandler ["EachFrame", {
		if (!isNull player) then {
			if (isMultiplayer && {isNil "xr_phd_invulnerable"}) then {
				xr_phd_invulnerable = true;
				player setVariable ["d_p_ev_hd_last", time];
			};
			if (!isNil "d_init_processed" && {time > 0 && {!isNil "d_preloaddone" && {!isNull (findDisplay 46)}}}) then {
				diag_log [diag_frameno, diag_tickTime, time, "Executing Dom local player pre start"];
				call compile preprocessFileLineNumbers "x_client\x_prestart.sqf";
				removeMissionEventHandler ["EachFrame", d_client_check_init];
				d_client_check_init = nil;
			};
		};
	}];
};

diag_log [diag_frameno, diag_ticktime, time, "Dom fn_preinit.sqf processed"];