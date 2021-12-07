// by Xeno
//#define __DEBUG__
#define THIS_FILE "d_init.sqf"
#include "x_setup.sqf"

diag_log [diag_frameno, diag_ticktime, time, "Executing Dom d_init.sqf"];

if (!isServer) then {
	call compile preprocessFileLineNumbers "x_init\x_initcommon.sqf";
};

#ifdef __GROUPDEBUG__
call compile preprocessFileLineNumbers "x_shc\x_f\x_shcfunctions.sqf";
#endif

Hz_customUnitLoadouts = true;
AI_setupUnitCustomLoadout = compile preprocessFileLineNumbers "AI_setupUnitCustomLoadout.sqf";

if (hasInterface) then {
	// Hunter: set this to a default low value so people don't forget their setting at high and then complain about low FPS...
	//private _vd = profileNamespace getVariable ["dom_viewdistance", d_InitialViewDistance];
	private _vd = 2000;
	setTerrainGrid 50;
	if (_vd > d_MaxViewDistance) then {
		_vd = d_MaxViewDistance;
	};
	setViewDistance _vd;
	setObjectViewDistance (_vd + 100);
} else {
	setViewDistance d_InitialViewDistance;
	setObjectViewDistance (d_InitialViewDistance + 100);
	
	Hz_min_desired_server_VD = 2000;
	Hz_max_desired_server_VD = 5000;
	Hz_min_desired_server_FPS = 8;
	Hz_max_desired_server_FPS = 15;	
	
	//Server DVD
	[] spawn {		     
		
		while {true} do {
			
			uisleep 5;

			if(diag_fps < Hz_min_desired_server_FPS) then {if(viewdistance > (Hz_min_desired_server_VD + 200)) then {setviewdistance (viewdistance - 200);}else {setviewdistance Hz_min_desired_server_VD;};} else {
				if(diag_fps > Hz_max_desired_server_FPS) then {if(viewdistance < (Hz_max_desired_server_VD - 200)) then {setviewdistance (viewdistance + 200);}else {setviewdistance Hz_max_desired_server_VD;};};};

		};
		
	}; 
	
};

d_target_names = [];
{
	private _dtar = _x;
	
	private _ar = [];
	_ar resize 4;
	private _name = _dtar getVariable "d_cityname";
	if (!isNil "_name") then {
		private _pos = getPosWorld _dtar;
		_pos set [2, 0];
		_ar set [0, _pos]; // position CityCenter by logic
		_ar set [1, _name]; // name village/city
		_ar set [2, _dtar getVariable ["d_cityradius", 400]];
		_ar set [3, _forEachIndex];
		__TRACE_1("One target found","_ar")
		d_target_names pushBack _ar;
	} else {
		private _nlocs = nearestLocations [getPosWorld _dtar, ["NameCityCapital", "NameCity", "NameVillage"], 500];
		__TRACE_2("","_dtar","_nlocs")
		if !(_nlocs isEqualTo []) then {
			private _locposnl0 = locationPosition (_nlocs # 0);
			private _nl = nearestLocations [_locposnl0, ["CityCenter"], 300];
			__TRACE_2("","_locposnl0","_nl")
			private _pos = [_locposnl0, locationPosition (_nl # 0)] select !(_nl isEqualTo []);
			_pos set [2, 0];
			_ar set [0, _pos]; // position CityCenter
			if (isServer) then {
				_dtar setPos _pos;
			};
			_name = text (_nlocs # 0);
			_ar set [1, _name]; // name village/city
			_ar set [2, _dtar getVariable ["d_cityradius", 400]];
			_ar set [3, _forEachIndex];
			_dtar setVariable ["d_cityname", _name];
			__TRACE_1("One target found","_ar")
			d_target_names pushBack _ar;
		} else {
			private _strx = format ["No city found near target location %1", str _dtar];
			hint _strx;
			diag_log _strx;
		};
	};
	if (isServer) then {
		_dtar enableSimulationGlobal false;
	};
	false
} forEach ((allMissionObjects "LocationCityCapital_F") select {str _x select [0, 9] == "d_target_"});
__TRACE_1("All targets found","d_target_names")

d_the_box = switch (d_own_side) do {
	case "GUER": {"Box_IND_Wps_F"};
	case "EAST": {"Box_East_Wps_F"};
	case "WEST": {
	#ifndef __RHS__		
		"B_CargoNet_01_ammo_F"
	#else
		"rhsusf_weapon_crate"
	#endif
	};
};

/*array of static ammoboxes at base*/
d_static_ammoboxes = [[d_ammobox_0,"Grenade Launchers"],[d_ammobox_1,"Assault Rifles"], [d_ammobox_2,"Machine Guns"], [d_ammobox_3,"Sniper Rifles"], [d_ammobox_4,"Launchers"], [d_ammobox_5,"Grenades"], [d_ammobox_6,"Explosives"], [d_ammobox_7,"Special Purpose"], [d_ammobox_8,"Attachments"], [d_ammobox_9,"Uniforms"], [d_ammobox_10,"Backpacks"], [d_ammobox_11,"Light Armor"], [d_ammobox_12,"Medium Armor"], [d_ammobox_13,"Heavy Armor"], [d_ammobox_14,"Pistols and Submachineguns"], [d_ammobox_15,"Equipment"], [d_ammobox_16,"Assault Rifles"], [d_ammobox_17,"Machine Guns"], [d_ammobox_18,"Sniper Rifles"], [d_ammobox_19,"Special Purpose"], [d_ammobox_20,"Armor"], [d_ammobox_21,"Launchers"], [d_ammobox_22,"Explosives"], [d_ammobox_23,"Grenades"], [d_ammobox_24,"Static Weapons"], [d_ammobox_25,"Facewear"]];

// positions of service buildings
// first jet service, second chopper service, third wreck repair

d_service_buildings = [[], [], []];
#ifndef __TT__
if (!d_ifa3lite) then {
	if !(markerPos "d_base_jet_sb" isEqualTo [0,0,0]) then {
		d_service_buildings set [0, [markerPos "d_base_jet_sb", markerDir "d_base_jet_sb"]];
	};
	if !(markerPos "d_base_chopper_sb" isEqualTo [0,0,0]) then {
		d_service_buildings set [1, [markerPos "d_base_chopper_sb", markerDir "d_base_chopper_sb"]];
	};
	if !(markerPos "d_base_wreck_sb" isEqualTo [0,0,0]) then {
		d_service_buildings set [2, [markerPos "d_base_wreck_sb", markerDir "d_base_wreck_sb"]];
	};
};
d_FLAG_BASE allowDamage false;
if (isServer) then {
	if (!d_ifa3lite) then {
		deleteMarker "d_base_jet_sb";
		deleteMarker "d_base_chopper_sb";
	};
	deleteMarker "d_base_wreck_sb";
	
	//Hunter: delete unnecessary markers
	if (d_bonus_vec_type == 3) then {

		{

			deletemarker _x;

		} foreach ["d_wreck_service"];

	};
	
	d_FLAG_BASE enableSimulationGlobal false;
};

// position base, side a and b length, direction and circle (false)/rectangle(true), like trigger; for the enemy at base area and marker
"d_base_marker" setMarkerAlphaLocal 0;
private _msize = markerSize "d_base_marker";
d_base_array = [[markerPos "d_base_marker" # 0, markerPos "d_base_marker" # 1, 1.9], _msize # 0, _msize # 1, markerDir "d_base_marker", true];
#else
d_EFLAG_BASE allowDamage false;
d_WFLAG_BASE allowDamage false;
if (isServer) then {
	d_EFLAG_BASE enableSimulationGlobal false;
	d_WFLAG_BASE enableSimulationGlobal false;
};

"d_base_marker_w" setMarkerAlphaLocal 0;
"d_base_marker_e" setMarkerAlphaLocal 0;
private _msize = markerSize "d_base_marker_w";
private _msize2 = markerSize "d_base_marker_e";
d_base_array = [
	[[markerPos "d_base_marker_w" # 0, markerPos "d_base_marker_w" # 1, 1.9], _msize # 0, _msize # 1, markerDir "d_base_marker_w", true], // blufor
	[[markerPos "d_base_marker_e" # 0, markerPos "d_base_marker_e" # 1, 1.9], _msize2 # 0, _msize2 # 1, markerDir "d_base_marker_e", true] // opfor
];
#endif

"d_isledefense_marker" setMarkerAlphaLocal 0;

if (isServer) then {
#include "i_server.sqf"
};

if (d_with_dynsim == 0) then {
	enableDynamicSimulationSystem true;
	"Group" setDynamicSimulationDistance 1000;
	"Vehicle" setDynamicSimulationDistance 3000;
	"EmptyVehicle" setDynamicSimulationDistance 1000;
	"Prop" setDynamicSimulationDistance 1000;
	"IsMoving" setDynamicSimulationDistanceCoef 2;
} else {
	enableDynamicSimulationSystem false;
};

if (hasInterface) then {
	// marker position of the player ammobox at base and other player ammoboxes (marker always needs to start with d_player_ammobox_pos)
	// note, in the TT version add the side to the array too
	private _allMapMarkers = allMapMarkers select {_x select [0, 20] == "d_player_ammobox_pos"};
#ifndef __TT__
	d_player_ammobox_pos = [];
	//Hunter: Don't create any default "ammoboxes"
	/*
	{
		d_player_ammobox_pos pushBack [markerPos _x, markerDir _x];
		deleteMarkerLocal _x;
	} forEach _allMapMarkers;
	*/
#else
	d_player_ammobox_pos = [[], []];
	
	private _tempar = d_player_ammobox_pos # 1;
	private _rem = _allMapMarkers select {_x select [0, 22] == "d_player_ammobox_pos_e"};
	{
		_tempar pushBack [markerPos _x, markerDir _x, east];
		deleteMarkerLocal _x;
	} forEach _rem;
	_allMapMarkers = _allMapMarkers - _rem;
	_tempar = d_player_ammobox_pos # 0;
	{
		_tempar pushBack [markerPos _x, markerDir _x, west];
		deleteMarkerLocal _x;
	} forEach _allMapMarkers;
#endif

};

if (isDedicated && {d_WithRevive == 0}) then {
	call compile preprocessFileLineNumbers "x_revive.sqf";
};

#include "x_missions\x_missionssetup.sqf"

#ifndef __TT__
{_x allowDamage false} forEach (nearestTerrainObjects [d_FLAG_BASE, ["House"], 70, false, true]);
#else
{_x allowDamage false} forEach (nearestTerrainObjects [d_EFLAG_BASE, ["House"], 70, false, true]);
{_x allowDamage false} forEach (nearestTerrainObjects [d_WFLAG_BASE, ["House"], 70, false, true]);
#endif

if (isNil "d_target_clear") then {
	d_target_clear = false;
};
if (isNil "d_all_sm_res") then {
	d_all_sm_res = false;
};
if (isNil "d_the_end") then {
	d_the_end = false;
};
#ifndef __TT__
if (isNil "d_ari_available") then {
	d_ari_available = true;
};
#else
if (isNil "d_ari_available_w") then {
	d_ari_available_w = true;
};
if (isNil "d_ari_available_e") then {
	d_ari_available_e = true;
};
#endif
if (isNil "d_current_target_index") then {
	d_current_target_index = -1;
};
if (isNil "d_cur_sm_idx") then {
	d_cur_sm_idx = -1;
};
if (isNil "d_num_ammo_boxes") then {
	d_num_ammo_boxes = 0;
};
if (isNil "d_sec_kind") then {
	d_sec_kind = 0;
};
if (isNil "d_resolved_targets") then {
	d_resolved_targets = [];
};
if (isNil "d_ammo_boxes") then {
	d_ammo_boxes = [];
};
if (isNil "d_para_available") then {
	d_para_available = true;
};
if (isNil "d_searchbody") then {
	d_searchbody = objNull;
};
if (isNil "d_searchintel") then {
	d_searchintel = [0,0,0,0,0,0,0];
};
#ifndef __TT__
if (isNil "d_ari_blocked") then {
	d_ari_blocked = false;
};
if (isNil "d_arty_firing") then {
	d_arty_firing = false;
};
#else
if (isNil "d_ari_blocked_w") then {
	d_ari_blocked_w = false;
};
if (isNil "d_ari_blocked_e") then {
	d_ari_blocked_e = false;
};
if (isNil "d_arty_firing_w") then {
	d_arty_firing_w = false;
};
if (isNil "d_arty_firing_e") then {
	d_arty_firing_e = false;
};
#endif
if (!d_no_ai && {isNil "d_drop_blocked"}) then {
	d_drop_blocked = false;
};
if (isNil "d_numcamps") then {
	d_numcamps = 0;
};
#ifndef __TT__
if (isNil "d_campscaptured") then {
	d_campscaptured = 0;
};
#else
if (isNil "d_campscaptured_w") then {
	d_campscaptured_w = 0;
};
if (isNil "d_campscaptured_e") then {
	d_campscaptured_e = 0;
};
#endif

if (isNil "d_currentcamps") then {
	d_currentcamps = [];
};

if (isNil "d_farps") then {
	d_farps = [];
};
if (isNil "d_mashes") then {
	d_mashes = [];
};
if (isNil "d_cur_tgt_pos") then {
	d_cur_tgt_pos = [];
};
if (isNil "d_cur_tgt_name") then {
	d_cur_tgt_name = "";
};
if (isNil "d_cur_target_radius") then {
	d_cur_target_radius = -1;
};
if (isNil "d_mttarget_radius_patrol") then {
	d_mttarget_radius_patrol = -1;
};
#ifndef __TT__
if (isNil "d_heli_taxi_available") then {
	d_heli_taxi_available = true;
};
if (isNil "d_cas_available") then {
	d_cas_available = true;
};
#else
if (isNil "d_cas_available_w") then {
	d_cas_available_w = true;
};
if (isNil "d_cas_available_e") then {
	d_cas_available_e = true;
};
#endif
if (isNil "d_winterw") then {
	d_winterw = 0;
};

if (isServer) then {
	execVM "x_bikb\kbinit.sqf";
	
	call compile preprocessFileLineNumbers "x_shc\x_shcinit.sqf";
	
	call compile preprocessFileLineNumbers "\DOMI_MEMBERS\members.sqf";

#ifndef __TT__
	0 spawn {
		scriptName "spawn_x_initx_createbase";
		waitUntil {time > 0};
		sleep 2;

		private _mmm = markerPos "d_base_sb_ammoload";
		__TRACE_1("","_mmm")
		
		if !(_mmm isEqualTo [0,0,0]) then {
			private _stype = [d_servicepoint_building] call BIS_fnc_simpleObjectData;
			_mmm set [2, 3.3];
			private _fac = createSimpleObject [_stype # 1, _mmm];
			_fac setDir (markerDir "d_base_sb_ammoload");
			_fac setPos _mmm;
		};

		if (d_base_aa_vec == "") exitWith {};
		
		if (isNil "d_HC_CLIENT_OBJ_OWNER") then {
			[d_own_side, d_base_aa_vec] call d_fnc_cgraa;
		} else {
			[d_own_side, d_base_aa_vec] remoteExecCall ["d_fnc_cgraa", d_HC_CLIENT_OBJ_OWNER];
		};
	};
#endif
	
	if (d_weather == 0) then {execFSM "fsms\fn_WeatherServer.fsm"};
	if (d_MainTargets_num > count d_target_names) then {
		d_MainTargets_num = count d_target_names;
	};
	
	if (d_MainTargets_num == -1) then {
		d_maintargets_list = [floor (random 3)] call d_fnc_create_route;
		d_MainTargets_num = count d_target_names;
	} else {
		// create random list of targets
		d_maintargets_list = call d_fnc_createrandomtargets;
	};
	//d_maintargets_list = [0,1,2,3];
	__TRACE_1("","d_maintargets_list")
	d_MainTargets = count d_maintargets_list;
	publicVariable "d_MainTargets";
	
	// create random list of side missions
	d_side_missions_random = d_sm_array call d_fnc_RandomArray;
	__TRACE_1("","d_side_missions_random")
	
	d_current_mission_counter = 0;

#ifndef __TT__
	// editor varname, unique number, true = respawn only when the chopper is completely destroyed, false = respawn after some time when no crew is in the chopper or chopper is destroyed
	// unique number must be between 3000 and 3999
	if (!d_ifa3lite) then {
		[
		[d_chopper_1,3001,true,1200],[d_chopper_2,3002,true,900],[d_chopper_3,3003,true,900],
		[d_chopper_4,3004,true,1200],[d_chopper_5,3005,true,1200],[d_chopper_13,3013,true,1200],
		[d_chopper_6,3006,true,900],[d_chopper_7,3007,true,900],[d_chopper_8,3008,true,1200],
		[d_chopper_9,3009,true,1200],[d_chopper_10,3010,true,900],[d_chopper_11,3011,true,1200],
		[d_chopper_12,3012,true,1200],
		
		[d_attack_1,3101,true,1800],		
		[d_attack_2,3102,true,1800],
		[d_plane_1,3103,true,900]	
		
		] call compile preprocessFileLineNumbers "x_server\x_inithelirespawn2.sqf";
	};
	// editor varname, unique number
	//0-99 = MHQ, 100-199 = Medic vehicles, 200-299 = Fuel, Repair, Reammo trucks, 300-399 = Engineer Salvage trucks, 400-499 = Transport trucks	
	private _var = [
		[d_vec_mhq_1,0,-1],[d_vec_mhq_2,1,-1],[d_vec_mhq_3,2,-1],
		[d_vec_med_1,100,-1],[d_vec_med_2,101,-1],[d_vec_rep_1,200,-1],[d_vec_fuel_1,201,-1],[d_vec_ammo_1,202,-1],
		[d_vec_rep_2,203,-1],[d_vec_fuel_2,204,-1], [d_vec_ammo_2,205,-1],[d_vec_eng_1,300,-1],[d_vec_eng_2,301,-1],
		[d_vec_trans_1,400,-1],[d_vec_trans_2,401,-1],[d_vec_trans_3,402,-1],[d_vec_trans_4,403,-1],
		
		[d_vec_bike_1,701,-1],[d_vec_bike_2,702,-1],[d_vec_bike_3,703,-1],[d_vec_bike_4,704,-1],[d_vec_bike_5,705,-1],
		[d_vec_bike_6,706,-1],[d_vec_bike_7,707,-1],[d_vec_bike_8,708,-1],[d_vec_bike_9,709,-1],[d_vec_bike_10,710,-1],
		[d_vec_bike_11,711,-1],[d_vec_bike_12,712,-1],[d_vec_bike_13,713,-1],[d_vec_bike_14,714,-1],[d_vec_bike_15,715,-1],
		[d_vec_bike_16,716,-1],[d_vec_bike_17,717,-1],[d_vec_bike_18,718,-1],[d_vec_bike_19,719,-1],[d_vec_bike_20,720,-1],
		[d_vec_bike_21,721,-1],[d_vec_bike_22,722,-1],[d_vec_bike_23,723,-1],[d_vec_bike_24,724,-1],[d_vec_bike_25,725,-1],
		[d_vec_bike_26,726,-1],[d_vec_bike_27,727,-1],[d_vec_bike_50,750,-1],[d_vec_bike_51,751,-1],[d_vec_bike_52,752,-1],
		[d_vec_bike_53,753,-1],[d_vec_bike_54,754,-1],[d_vec_bike_55,755,-1],	
		
		[d_vec_car_1,801,-1], [d_vec_car_2,802,-1], [d_vec_car_3,803,-1],[d_vec_car_4,804,-1],
		[d_vec_car_5,805,-1], [d_vec_car_6,806,-1], [d_vec_car_7,807,-1], [d_vec_car_8,808,-1],[d_vec_car_9,809,-1],
		[d_vec_car_10,810,-1],[d_vec_car_11,811,-1],[d_vec_car_12,812,-1],[d_vec_car_13,813,-1],[d_vec_car_14,814,-1],
		[d_vec_car_15,815,-1],[d_vec_car_16,816,-1],[d_vec_car_17,817,-1],[d_vec_car_18,818,-1],
		[d_boat_1,851,-1],[d_boat_2,852,-1],[d_boat_3,853,-1],[d_boat_4,854,-1],[d_boat_5,855,-1],[d_boat_6,856,-1],
		[d_boat_7,857,-1],
		
		[d_vec_tank_1,900,-1],[d_vec_tank_2,901,-1],[d_vec_tank_3,902,-1],[d_vec_tank_4,903,-1],
		[d_vec_tank_5,904,-1],[d_vec_tank_6,905,-1],[d_vec_tank_7,906,-1],[d_vec_tank_8,907,-1],[d_vec_tank_9,908,-1]
		
		];
		
	if (d_ifa3lite) then {
		_var pushBack [d_vec_wreck_1, 500];
	};
	_var call compile preprocessFileLineNumbers "x_server\x_initvrespawn2.sqf";
	//Hunter: disable this and handle boats as ground vics instead
	/*
	if (!isNil "d_boat_1") then {
		execFSM "fsms\fn_Boatrespawn.fsm";
	};
	*/
#else
	[[d_chopper_1,3001,true],[d_chopper_2,3002,true],[d_chopper_3,3003,false,1500],[d_chopper_4,3004,false,1500],[d_chopper_5,3005,false,600],[d_chopper_6,3006,false,600],
	[d_choppero_1,4001,true],[d_choppero_2,4002,true],[d_choppero_3,4003,false,1500],[d_choppero_4,4004,false,1500],[d_choppero_5,4005,false,600],[d_choppero_6,4006,false,600]] call compile preprocessFileLineNumbers "x_server\x_inithelirespawn2.sqf";
	
	[
		[d_vec_mhq_1,0,localize "STR_DOM_MISSIONSTRING_12"],[d_vec_mhq_2,1,localize "STR_DOM_MISSIONSTRING_13"],[d_vec_med_1,100],[d_vec_rep_1,200],[d_vec_fuel_1,201],[d_vec_ammo_1,202], [d_vec_rep_2,203],
		[d_vec_fuel_2,204], [d_vec_ammo_2,205], [d_vec_eng_1,300], [d_vec_eng_2,301], [d_vec_trans_1,400], [d_vec_trans_2,401],
		[d_vec_mhqo_1,1000,localize "STR_DOM_MISSIONSTRING_12"],[d_vec_mhqo_2,1001,localize "STR_DOM_MISSIONSTRING_13"],[d_vec_medo_1,1100],[d_vec_repo_1,1200],[d_vec_fuelo_1,1201],[d_vec_ammoo_1,1202], [d_vec_repo_2,1203],
		[d_vec_fuelo_2,1204], [d_vec_ammoo_2,1205], [d_vec_engo_1,1300], [d_vec_engo_2,1301], [d_vec_transo_1,1400], [d_vec_transo_2,1401]
	] call compile preprocessFileLineNumbers "x_server\x_initvrespawn2.sqf";
#endif
	[d_wreck_rep,localize "STR_DOM_MISSIONSTRING_0",d_heli_wreck_lift_types] execFSM "fsms\fn_RepWreck.fsm";
#ifdef __TT__
	[d_wreck_rep2, localize "STR_DOM_MISSIONSTRING_0", d_heli_wreck_lift_types] execFSM "fsms\fn_RepWreck.fsm";
	d_public_points = true;
#endif

	call compile preprocessFileLineNumbers "x_server\x_setupserver.sqf";
	if (d_MissionType != 2) then {0 spawn d_fnc_createnexttarget};
	
#ifdef __TT__
	d_points_blufor = 0;
	d_points_opfor = 0;
	d_kill_points_blufor = 0;
	d_kill_points_opfor = 0;
	d_points_array = [0,0,0,0];
	publicVariable "d_points_array";
#endif
	
	addMissionEventHandler ["PlayerDisconnected", {_this call d_fnc_playerdisconnected}];
	
	addMissionEventHandler ["HandleDisconnect", {_this call d_fnc_handledisconnect}];
	
	addMissionEventhandler ["BuildingChanged", {_this call d_fnc_buildingchanged}];
	
	
	/*association between prison's slot (index), respawn position and disponibility*/
	d_prison = [[[],false]];
	//grab the loadout and delete unnecessary units...
	d_prisonerLoadout = getUnitLoadout d_prisoner_1;
	publicVariable "d_prisonerLoadout";
	{d_prison pushback [getPosATL(_x), false]; deletevehicle _x;} foreach units d_prisoners;	
	
};

if (!hasInterface) then {
	call compile preprocessFileLineNumbers "x_shc\x_shcinit.sqf";
} else {
#ifndef __TT__
	["d_wreck_service", d_wreck_rep,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_0",0,"n_service"] call d_fnc_CreateMarkerLocal;
	["d_aircraft_service", d_jet_trigger,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_2",0,"n_service"] call d_fnc_CreateMarkerLocal;
	if (!d_ifa3lite) then {
		["d_chopper_service", d_chopper_trigger,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_3",0,"n_service"] call d_fnc_CreateMarkerLocal;
	};
	["d_vec_service", d_vecre_trigger,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_4",0,"n_service"] call d_fnc_CreateMarkerLocal;
	["d_Ammobox_Reload", d_AMMOLOAD,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_5",0,"hd_dot"] call d_fnc_CreateMarkerLocal;
	["d_teleporter", d_FLAG_BASE,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_6",0,"mil_flag"] call d_fnc_CreateMarkerLocal;
	if (d_carrier) then {
		["d_Ammobox_Reload_C", d_AMMOLOAD_C,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_5",0,"hd_dot"] call d_fnc_CreateMarkerLocal;
		["d_service_point", d_serviceall_trigger,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_1761",0,"hd_dot"] call d_fnc_CreateMarkerLocal;
	};
#else
	["d_wreck_service", d_wreck_rep,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_0",0,"n_service"] call d_fnc_CreateMarkerLocal;
	["d_aircraft_service", d_jet_trigger,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_2",0,"n_service"] call d_fnc_CreateMarkerLocal;
	if (!d_ifa3lite) then {
		["d_chopper_service", d_chopper_trigger,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_3",0,"n_service"] call d_fnc_CreateMarkerLocal;
	};
	["d_vec_service", d_vecre_trigger,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_4",0,"n_service"] call d_fnc_CreateMarkerLocal;
	["d_Ammobox_Reload", d_AMMOLOAD,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_5",0,"hd_dot"] call d_fnc_CreateMarkerLocal;
	["d_teleporter", d_WFLAG_BASE,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_6",0,"mil_flag"] call d_fnc_CreateMarkerLocal;
	
	["d_wreck_serviceR", d_wreck_rep2,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_0",0,"n_service"] call d_fnc_CreateMarkerLocal;
	["d_aircraft_serviceR", d_jet_trigger2,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_2",0,"n_service"] call d_fnc_CreateMarkerLocal;
	["d_chopper_serviceR", d_chopper_triggerR,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_3",0,"n_service"] call d_fnc_CreateMarkerLocal;
	["d_vehicle_serviceR", d_vecre_trigger2,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_4",0,"n_service"] call d_fnc_CreateMarkerLocal;
	["d_Ammobox ReloadR", d_AMMOLOAD2,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_5",0,"hd_dot"] call d_fnc_CreateMarkerLocal;
	["d_teleporter_1", d_EFLAG_BASE,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_6",0,"mil_flag"] call d_fnc_CreateMarkerLocal;
	{
		_x setMarkerAlphaLocal 0;
	} forEach ["d_chopper_service","d_wreck_service","d_teleporter","d_aircraft_service","bonus_air","bonus_vehicles","d_Ammobox_Reload","d_vec_service",
		"Start","d_chopper_serviceR","d_wreck_serviceR","d_teleporter_1","d_aircraft_serviceR","bonus_airR","bonus_vehiclesR","d_Ammobox ReloadR","Start_opfor","d_vehicle_serviceR", "d_runwaymarker_o", "d_runwaymarker"];
#endif

	private _icounter_o = 0;
	private _icounter_b = 0;
	private _icounter_i = 0;
	private _allmissobjs = allMissionObjects "FlagCarrier";
	{
		private _side = _x getVariable ["d_flagside", blufor];
		private _name = _x getVariable "d_name";
		if (isNil "_name") then {
			private _icounter = call {
				if (_side == blufor) exitWith {
					_icounter_b = _icounter_b + 1;
					_icounter_b;
				};
				if (_side == opfor) exitWith {
					_icounter_o = _icounter_o + 1;
					_icounter_o
				};
				_icounter_i = _icounter_i + 1;
				_icounter_i
			};
			_name = format ["%1 %2", localize "STR_DOM_MISSIONSTRING_1762", _icounter];
		};
		d_additional_respawn_points pushBack [format ["d_add_farp_%1", _x], str _x, _name, _side, d_vec_at_farp == 0, getPosASL _x];
	} forEach (_allmissobjs select {(str _x) select [0, 9] == "d_flag_bb"});
	_icounter_o = 0;
	_icounter_b = 0;
	_icounter_i = 0;
	{
		private _side = _x getVariable ["d_flagside", blufor];
		private _name = _x getVariable "d_name";
		if (isNil "_name") then {
			private _icounter = call {
				if (_side == blufor) exitWith {
					_icounter_b = _icounter_b + 1;
					_icounter_b;
				};
				if (_side == opfor) exitWith {
					_icounter_o = _icounter_o + 1;
					_icounter_o
				};
				_icounter_i = _icounter_i + 1;
				_icounter_i
			};
			_name = format ["%1 %2", localize "STR_DOM_MISSIONSTRING_1826", _icounter];
		};
		d_additional_respawn_points pushBack [format ["d_add_farp_%1", _x], str _x, _name, _side, true, getPosASL _x];
	} forEach (_allmissobjs select {(str _x) select [0, 9] == "d_respawn_point"});

	if (d_with_ranked) then {
		if (d_rhs) then {
			call compile preprocessFileLineNumbers "i_weapons_rhs.sqf";
		} else {
			if (d_cup) then {
				call compile preprocessFileLineNumbers "i_weapons_CUP.sqf";
			} else {
				if (d_ifa3lite) then {
					call compile preprocessFileLineNumbers "i_weapons_IFA3.sqf";
				} else {
					call compile preprocessFileLineNumbers "i_weapons_default.sqf";
				};
			};
		};
	};
	
	call compile preprocessFileLineNumbers "i_restrictions.sqf";
	call compile preprocessFileLineNumbers "i_arsenal.sqf";	
};

d_init_processed = true;

diag_log [diag_frameno, diag_ticktime, time, "Dom d_init.sqf processed"];