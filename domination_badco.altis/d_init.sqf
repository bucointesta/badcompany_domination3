// by Xeno
//#define __DEBUG__
diag_log [diag_frameno, diag_ticktime, time, "Executing Dom d_init.sqf"];
#define THIS_FILE "d_init.sqf"
#include "x_setup.sqf"

//execute x_initcommon.sqf on clients
if (!isServer) then {
	call compile preprocessFileLineNumbers "x_init\x_initcommon.sqf";
};

call compile preprocessFileLineNumbers "x_init\x_timeinit.sqf";

#ifdef __GROUPDEBUG__
//if (!isMultiplayer) then {
	call compile preprocessFileLineNumbers "x_shc\x_f\x_shcfunctions.sqf";
//};
#endif

//set view distance
setViewDistance d_InitialViewDistance;

/*parse each d_target found in missionNamespace and create a table called d_target_names (array of array)
each entry represent a main target and is an array where 0 is the position (altitude always 0), 1 is the name and 2 is the city radius
if a city is not found on the target, looks for the nearest city
if a near city isn't found, dont create an entry but log that*/
d_last_target_idx = -1;
d_target_names = [];
for "_i" from 0 to 1000 do {
	private _dtar = missionNamespace getVariable format ["d_target_%1", _i];
	if (isNil "_dtar") exitWith {
		d_last_target_idx = _i - 1;
	};
	private _ar = [];
	_ar resize 3;
	private _name = _dtar getVariable "d_cityname";
	if (!isNil "_name") then {
		private _pos = getPosWorld _dtar;
		_pos set [2, 0];
		_ar set [0, _pos]; // position CityCenter by logic
		_ar set [1, _name]; // name village/city
		_ar set [2, _dtar getVariable ["d_cityradius", 300]];
		__TRACE_1("One target found","_ar")
		d_target_names pushBack _ar;
	} else {
		private _nlocs = nearestLocations [getPosWorld _dtar, ["NameCityCapital", "NameCity", "NameVillage"], 500];
		__TRACE_2("","_dtar","_nlocs")
		if !(_nlocs isEqualTo []) then {
			private _locposnl0 = locationPosition (_nlocs select 0);
			private _nl = nearestLocations [_locposnl0, ["CityCenter"], 300];
			__TRACE_2("","_locposnl0","_nl")
			private _pos = [_locposnl0, locationPosition (_nl select 0)] select !(_nl isEqualTo []);
			_pos set [2, 0];
			_ar set [0, _pos]; // position CityCenter
			if (isServer) then {
				_dtar setPos _pos;
			};
			_name = text (_nlocs select 0);
			_ar set [1, _name]; // name village/city
			_ar set [2, _dtar getVariable ["d_cityradius", 300]];
			_dtar setVariable ["d_cityname", _name];
			__TRACE_1("One target found","_ar")
			d_target_names pushBack _ar;
		} else {
			private _strx = "No city found near target location " + format ["d_target_%1", _i];
			hint _strx;
			diag_log _strx;
		};
	};
	if (isServer) then {
		_dtar enableSimulationGlobal false;
	};
};
__TRACE_1("All targets found","d_target_names")

/*array of static ammoboxes at base*/
d_static_ammoboxes = [[d_ammobox_0, "NATO equipment"], [d_ammobox_1,"Assault Rifles"], [d_ammobox_2,"Machine Guns"], [d_ammobox_3,"Sniper Rifles"], [d_ammobox_4,"Launchers"], [d_ammobox_5,"Grenades"], [d_ammobox_6,"Explosives"], [d_ammobox_7,"Special Purpose"], [d_ammobox_8,"Attachments"], [d_ammobox_9,"Uniforms"], [d_ammobox_10,"Backpacks"], [d_ammobox_11,"Light Armor"], [d_ammobox_12,"Medium Armor"], [d_ammobox_13,"Heavy Armor"], [d_ammobox_14,"Pistols and Submachineguns"], [d_ammobox_15,"Equipment"], [d_ammobox_16,"Assault Rifles"], [d_ammobox_17,"Machine Guns"], [d_ammobox_18,"Sniper Rifles"], [d_ammobox_19,"Special Purpose"], [d_ammobox_20,"Armor"], [d_ammobox_21,"Launchers"], [d_ammobox_22,"Explosives"], [d_ammobox_23,"Grenades"], [d_ammobox_24,"Static Weapons"], [d_ammobox_25,"Facewear"]];

// positions of service buildings
// first jet service, second chopper service, third wreck repair

d_service_buildings = [[], [], []];

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
	deleteMarker "d_base_jet_sb";
	deleteMarker "d_base_chopper_sb";
	deleteMarker "d_base_wreck_sb";
	d_FLAG_BASE enableSimulationGlobal false;
};

// position base, side a and b length, direction and circle (false)/rectangle(true), like trigger; for the enemy at base area and marker
"d_base_marker" setMarkerAlphaLocal 0;
private _msize = markerSize "d_base_marker";
d_base_array = [[markerPos "d_base_marker" select 0, markerPos "d_base_marker" select 1, 1.9], _msize select 0, _msize select 1, markerDir "d_base_marker", true];

// position of anti air at own base
d_base_anti_air1 = markerPos "d_base_anti_air1";
d_base_anti_air2 = markerPos "d_base_anti_air2";


"d_isledefense_marker" setMarkerAlphaLocal 0;

if (isServer) then {
#include "i_server.sqf"
};

if (d_with_dynsim == 0) then {
	enableDynamicSimulationSystem true;
	"Group" setDynamicSimulationDistance 2500;
	"Vehicle" setDynamicSimulationDistance 5000;
	"EmptyVehicle" setDynamicSimulationDistance 2500;
	"Prop" setDynamicSimulationDistance 2500;
	"IsMoving" setDynamicSimulationDistanceCoef 2;
} else {
	enableDynamicSimulationSystem false;
};

if (hasInterface) then {
	// position of the player ammobox at base
	d_player_ammobox_pos = [markerPos "d_player_ammobox_pos", markerDir "d_player_ammobox_pos"];
};

deleteMarkerLocal "d_player_ammobox_pos";

if (isDedicated && {d_WithRevive == 0}) then {
	call compile preprocessFileLineNumbers "x_revive.sqf";
};

#include "x_missions\x_missionssetup.sqf"

{if (_x inArea "d_base_marker") then {_x allowDamage false};false} count (nearestTerrainObjects [[14882.2,16702.7,0.00143814], ["House"], 1500, false, true]);
{if (_x inArea "d_base_marker") then {_x enableSimulation false};false} count (nearestObjects [[14882.2,16702.7,0.00143814], ["Land_Hangar_F", "Land_MetalShelter_01_F", "Land_Shed_Big_F", "Land_Shed_Small_F",  "Land_Cargo_Patrol_V1_F", "Land_Cargo_Patrol_V2_F", "Land_Cargo_Patrol_V3_F", "Land_CncWall4_F", "Land_HBarrier_1_F", "Land_HBarrier_3_F", "Land_HBarrier_5_F"], 1500]);

if (isNil "d_target_clear") then {
	d_target_clear = false;
};
if (isNil "d_all_sm_res") then {
	d_all_sm_res = false;
};
if (isNil "d_the_end") then {
	d_the_end = false;
};
if (isNil "d_ari_available") then {
	d_ari_available = true;
};
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
	d_searchintel = [0,0,0,0,0,0];
};
if (isNil "d_ari_blocked") then {
	d_ari_blocked = false;
};
if (!d_no_ai && {isNil "d_drop_blocked"}) then {
	d_drop_blocked = false;
};
if (isNil "d_numcamps") then {
	d_numcamps = 0;
};
if (isNil "d_campscaptured") then {
	d_campscaptured = 0;
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
if (isNil "d_cas_available") then {
	d_cas_available = true;
};
if (isNil "d_winterw") then {
	d_winterw = 0;
};



if (isServer) then {
	execVM "x_bikb\kbinit.sqf";
	
	call compile preprocessFileLineNumbers "x_server\x_initx.sqf";
	
	call compile preprocessFileLineNumbers "\DOMI_MEMBERS\members.sqf";
	
	if (d_weather == 0) then {execFSM "fsms\fn_WeatherServer.fsm"};

	if (d_MainTargets_num < 200) then {
		d_MainTargets = d_MainTargets_num;
		// create random list of targets
		d_maintargets_list = call d_fnc_createrandomtargets;
		//d_maintargets_list = [0,1,2,3];
		__TRACE_1("","d_maintargets_list")
	} else {
		switch (d_MainTargets_num) do {
			case 200: {d_maintargets_list = [3,16,17,18,20,19,9,8,7,5,10,15]};
			case 210: {d_maintargets_list = [0,32,13,14,12,11]};
			case 220: {d_maintargets_list = [2,27,29,28,30,31]};
			case 230: {d_maintargets_list = [6,26,1,25,24,21,22,23]};
			case 240: {d_maintargets_list = [3,16,17,20,18,19,9,8,7,5,6,10,15,4,14,11,12,13,0,32,2,33,26,1,23,22,21,24,25,28,29,30,31]};
		};
		d_MainTargets = count d_maintargets_list;
	};
	publicVariable "d_MainTargets";
	
	// create random list of side missions
	d_side_missions_random = d_sm_array call d_fnc_RandomArray;
	__TRACE_1("","d_side_missions_random")
	
	d_current_mission_counter = 0;

	// editor varname, unique number, true = respawn only when the chopper is completely destroyed, false = respawn after some time when no crew is in the chopper or chopper is destroyed
	// unique number must be between 3000 and 3999
		[
		[d_chopper_1,3001,true,1200],[d_chopper_2,3002,true,900],[d_chopper_3,3003,true,900],
		[d_chopper_4,3004,true,1200],[d_chopper_5,3005,true,1200],[d_chopper_6,3006,true,900],
		[d_chopper_7,3007,true,900],[d_chopper_8,3008,true,1200],[d_chopper_9,3009,true,1200],
		[d_chopper_10,3010,true,900],[d_chopper_11,3011,true,1200],[d_attack_1,3101,true,1800],
		[d_attack_2,3102,true,1800]
		] call compile preprocessFileLineNumbers "x_server\x_inithelirespawn2.sqf";

	// editor varname, unique number
	//0-99 = MHQ, 100-199 = Medic vehicles, 200-299 = Fuel, Repair, Reammo trucks, 300-399 = Engineer Salvage trucks, 400-499 = Transport trucks
	// new in 3.70  third parameter for MHQ means a message will be displayed for a MHQ if it gets destroyed
	private _var = [
		[d_vec_mhq_1,0,localize "STR_DOM_MISSIONSTRING_12"],[d_vec_mhq_2,1, localize "STR_DOM_MISSIONSTRING_13"],
		[d_vec_med_1,100,-1],[d_vec_med_2,101,-1],[d_vec_rep_1,200,-1],[d_vec_fuel_1,201,-1],[d_vec_ammo_1,202,-1],
		[d_vec_rep_2,203,-1],[d_vec_fuel_2,204,-1], [d_vec_ammo_2,205,-1],[d_vec_eng_1,300,-1],[d_vec_eng_2,301,-1],
		[d_vec_trans_1,400,-1],[d_vec_trans_2,401,-1],[d_vec_trans_3,402,-1],[d_vec_trans_4,403,-1],[d_vec_bike_1,701,-1],
		[d_vec_bike_2,702,-1],[d_vec_bike_3,703,-1],[d_vec_bike_4,704,-1],[d_vec_bike_5,705,-1],[d_vec_bike_6,706,-1],
		[d_vec_bike_7,707,-1],[d_vec_bike_8,708,-1],[d_vec_bike_9,709,-1],[d_vec_bike_10,710,-1],[d_vec_bike_11,711,-1],
		[d_vec_bike_12,712,-1],[d_vec_bike_13,713,-1],[d_vec_bike_14,714,-1],[d_vec_bike_15,715,-1],[d_vec_bike_16,716,-1],
		[d_vec_bike_17,717,-1],[d_vec_bike_18,718,-1],[d_vec_bike_19,719,-1],[d_vec_bike_20,720,-1],[d_vec_bike_21,721,-1],
		[d_vec_bike_22,722,-1],[d_vec_bike_23,723,-1],[d_vec_bike_24,724,-1],[d_vec_bike_25,725,-1],[d_vec_bike_26,726,-1],
		[d_vec_bike_27,727,-1], [d_vec_car_1,801,-1], [d_vec_car_2,802,-1], [d_vec_car_3,803,-1],[d_vec_car_4,804,-1],
		[d_vec_car_5,805,-1], [d_vec_car_6,806,-1], [d_vec_car_7,807,-1], [d_vec_car_8,808,-1],[d_vec_car_9,809,-1],
		[d_vec_car_10,810,-1],[d_vec_car_11,811,-1],[d_vec_car_12,812,-1],[d_vec_car_13,813,-1],[d_vec_car_14,814,-1],
		[d_vec_car_15,815,-1],[d_vec_tank_1,900,-1],[d_vec_tank_2,901,-1],[d_vec_tank_3,902,-1],[d_vec_tank_4,903,-1],
		[d_vec_tank_5,904,-1],[d_vec_tank_6,905,-1],[d_vec_tank_7,906,-1],[d_vec_tank_8,907,-1]
	];
	_var call compile preprocessFileLineNumbers "x_server\x_initvrespawn2.sqf";
	if (!isNil "d_boat_1") then {
		//call d_fnc_Boatrespawn;
		execFSM "fsms\fn_Boatrespawn.fsm";
	};
	//[d_wreck_rep,localize "STR_DOM_MISSIONSTRING_0",d_heli_wreck_lift_types] call d_fnc_RepWreck;
	[d_wreck_rep,localize "STR_DOM_MISSIONSTRING_0",d_heli_wreck_lift_types] execFSM "fsms\fn_RepWreck.fsm";

	call compile preprocessFileLineNumbers "x_server\x_setupserver.sqf";
	if (d_MissionType != 2) then {0 spawn d_fnc_createnexttarget};
	
	if (d_with_ai) then {
		d_player_groups = [];
		d_player_groups_lead = [];
	};
		
	addMissionEventHandler ["PlayerDisconnected", {_this call d_fnc_playerdisconnected}];
	
	addMissionEventHandler ["HandleDisconnect", {_this call d_fnc_handledisconnect}];
	
	addMissionEventhandler ["BuildingChanged", {_this call d_fnc_buildingchanged}];
	
	
	/*association between trigger, object and door/gate to animate*/
	d_entrances = [
		[d_triggate_1,d_gate_1,"1"],
		[d_triggate_2,d_gate_2,"1"],
		[d_triggate_3,d_gate_3,"1"],
		[d_triggate_4,d_gate_4,"1"],
		[d_triggate_5,d_gate_5,"1"],
		[d_triggate_6,d_gate_6,"1"],
		[d_trigdome_1_2,d_dome_1,"2"],
		[d_trigdome_1_3,d_dome_1,"3"]
	];

	/*association between prison's slot (index), respawn position and disponibility*/
	d_prison = [[[],false]];
	{d_prison pushback [getPosATL(_x),true]; false} count units d_prisoners;

	/*add to base defense infantry auto revive function*/
	{
		_x setVariable ["gun", vehicle _x]; 
		removeAllWeapons _x; 
		_x addEventHandler ["killed", {[param [0], param [1], param[2]] remoteExecCall ["d_fnc_plcheckkill", 2]; private _gun = (param [0]) getVariable "gun";  _gun spawn { sleep 300; _this call d_fnc_revive_baseinf;}}];
	} forEach units d_baseinf;
};



if (hasInterface) then {
	["d_wreck_service", d_wreck_rep,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_1",0,"n_service"] call d_fnc_CreateMarkerLocal;
	["d_aircraft_service", d_jet_trigger,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_2",0,"n_service"] call d_fnc_CreateMarkerLocal;
	if (!d_ifa3lite) then {
		["d_chopper_service", d_chopper_trigger,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_3",0,"n_service"] call d_fnc_CreateMarkerLocal;
	};
	["d_vec_service", d_vecre_trigger,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_4",0,"n_service"] call d_fnc_CreateMarkerLocal;
	["d_Ammobox_Reload", d_AMMOLOAD,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_5",0,"hd_dot"] call d_fnc_CreateMarkerLocal;
	["d_teleporter", d_FLAG_BASE,"ICON","ColorYellow",[1,1],"HQ",0,"mil_flag"] call d_fnc_CreateMarkerLocal;
	["d_armory_loc", d_armory,"ICON","ColorYellow",[1,1],"Armory",0,"mil_pickup"] call d_fnc_CreateMarkerLocal;
	call compile preprocessFileLineNumbers "i_weapons.sqf";
	call compile preprocessFileLineNumbers "i_items.sqf";
};

if (d_bonus_vec_type == 3) then {deletemarker "d_wreck_service"};

d_init_processed = true;

diag_log [diag_frameno, diag_ticktime, time, "Dom d_init.sqf processed"];