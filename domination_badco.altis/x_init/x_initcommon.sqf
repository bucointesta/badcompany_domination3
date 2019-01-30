// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_initcommon.sqf"
#include "..\x_setup.sqf"
diag_log [diag_frameno, diag_ticktime, time, "Executing Dom x_initcommon.sqf"];

if (isNil "paramsArray") then {
	if (isClass (getMissionConfig "Params")) then {
		private _conf = getMissionConfig "Params";
		for "_i" from 0 to (count _conf - 1) do {
			private _paramName = configName (_conf select _i);
			private _paramval = getNumber (_conf>>_paramName>>"default");
			if (_paramval != -99999) then {
				missionNamespace setVariable [_paramName, _paramval];
			};
		};
	};
} else {
	for "_i" from 0 to (count paramsArray - 1) do {
		private _paramval = paramsArray select _i;
		if (_paramval != -99999) then {
			missionNamespace setVariable [configName ((getMissionConfig "Params") select _i), _paramval];
		};
	};
};

d_with_ranked = d_with_ranked == 0;
d_with_ai = d_with_ai == 0;
d_no_ai = !d_with_ai && {d_with_ai_features == 1};

if (d_with_ace) then {
	d_WithRevive = 1;
	ace_medical_enableRevive = 1;
	ace_medical_maxReviveTime = 300;
};

if (d_sub_kill_points != 0) then {
	d_sub_kill_points = d_sub_kill_points * -1;
};

if (d_GrasAtStart == 1) then {setTerrainGrid 50};

if (isServer) then {skipTime d_TimeOfDay};

if (isServer || {!isDedicated && {!hasInterface}}) then {
	// first element (array. for example: [2,1]): number of vehicle groups that will get spawned, the first number is the max number that will get spawned,
	// the second one the minimum. So [2,0] means, there can be no vehicle groups at all or a maximum of 2 groups of this kind
	// second element: maximum number of vehicles in group; randomly chosen
	switch (d_WithLessArmor) do {
		case 0: {
			d_vec_numbers_guard = [
				[[1,0], 1], // tanks
				[[1,0], 1], // tracked apc
				[[1,1], 1], // wheeled apc
				[[1,1], 1], // jeep with mg
				[[1,0], 1] // jeep with gl
			];
			d_vec_numbers_guard_static = [
				[[1,1], 1], // tanks
				[[1,1], 1], // tracked apc
				[[1,1], 1] // aa
			];
			d_vec_numbers_patrol = [
				[[1,1], 1], // tanks
				[[1,1], 1], // tracked apc
				[[1,1], 1], // wheeled apc
				[[1,1], 1], // jeep with mg
				[[1,1], 1] // jeep with gl
			];

			// allmost the same like above
			// first element the max number of ai "foot" groups that will get spawned, second element minimum number (no number for vehicles in group necessary)
			d_footunits_guard = [
				[1,1], // basic groups
				[1,1] // specop groups
			];
			d_footunits_patrol = [
				[5,3], // basic groups
				[5,3] // specop groups
			];
			d_footunits_guard_static = [
				[1,1], // basic groups
				[1,0] // specop groups
			];
			d_footunits_attack = [
				[1,1], // basic groups
				[1,1] // specop groups
			];
			d_vec_numbers_attack = [
				[[1,1], 1], // tanks
				[[1,1], 1], // tracked apc
				[[1,1], 1], // wheeled apc
				[[1,1], 1], // jeep with mg
				[[1,1], 1], // jeep with gl
				[[1,1], 1] // aa
			];
		};
		case 1: {
			d_vec_numbers_guard = [
				[[1,0], 1], // tanks
				[[1,0], 1], // tracked apc
				[[1,0], 1], // wheeled apc
				[[1,1], 1], // jeep with mg
				[[1,1], 1] // jeep with gl
			];
			d_vec_numbers_guard_static = [
				[[1,0], 1], // tanks
				[[1,0], 1], // tracked apc
				[[1,0], 1] // aa
			];
			d_vec_numbers_patrol = [
				[[1,0], 1], // tanks
				[[1,0], 1], // tracked apc
				[[1,0], 1], // wheeled apc
				[[1,0], 1], // jeep with mg
				[[1,1], 1] // jeep with gl
			];

			// allmost the same like above
			// first element the max number of ai "foot" groups that will get spawned, second element minimum number (no number for vehicles in group necessary)
			d_footunits_guard = [
				[2,1], // basic groups
				[2,1] // specop groups
			];
			d_footunits_patrol = [
				[6,3], // basic groups
				[6,3] // specop groups
			];
			d_footunits_guard_static = [
				[3,1], // basic groups
				[2,1] // specop groups
			];
			d_footunits_attack = [
				[3,1], // basic groups
				[2,1] // specop groups
			];
			d_vec_numbers_attack = [
				[[1,0], 1], // tanks
				[[1,0], 1], // tracked apc
				[[1,0], 1], // wheeled apc
				[[1,1], 1], // jeep with mg
				[[1,1], 1], // jeep with gl
				[[1,0], 1] // aa
			];
		};
		case 2: {
			d_vec_numbers_guard = [
				[[0,0], 1], // tanks
				[[0,0], 1], // tracked apc
				[[0,0], 1], // wheeled apc
				[[2,1], 1], // jeep with mg
				[[2,1], 1] // jeep with gl
			];
			d_vec_numbers_guard_static = [
				[[0,0], 1], // tanks
				[[0,0], 1], // tracked apc
				[[0,0], 1] // aa
			];
			d_vec_numbers_patrol = [
				[[0,0], 1], // tanks
				[[0,0], 1], // tracked apc
				[[0,0], 1], // wheeled apc
				[[2,1], 1], // jeep with mg
				[[2,1], 1] // jeep with gl
			];

			// allmost the same like above
			// first element the max number of ai "foot" groups that will get spawned, second element minimum number (no number for vehicles in group necessary)
			d_footunits_guard = [
				[4,1], // basic groups
				[4,1] // specop groups
			];
			d_footunits_patrol = [
				[8,3], // basic groups
				[6,3] // specop groups
			];
			d_footunits_guard_static = [
				[4,1], // basic groups
				[3,1] // specop groups
			];
			d_footunits_attack = [
				[6,1], // basic groups
				[6,1] // specop groups
			];
			d_vec_numbers_attack = [
				[[0,0], 1], // tanks
				[[0,0], 1], // tracked apc
				[[0,0], 1], // wheeled apc
				[[2,1], 1], // jeep with mg
				[[2,1], 1], // jeep with gl
				[[1,0], 1] // aa
			];
		};
	};
	
	// enemy ai skill: [base skill, random value (random 0.3) that gets added to the base skill]
	d_skill_array = switch (d_EnemySkill) do {
		case 1: {[0.2,0.1]};
		case 2: {[0.4,0.2]};
		case 3: {[0.6,0.3]};
	};
};

if (hasInterface) then {
	if (d_with_ai) then {d_current_ai_num = 0};

	if (d_with_ranked) then {
		d_ranked_a = [
			20, // points that an engineer must have to repair/refuel a vehicle
			[3,2,1,0], // points engineers get for repairing an air vehicle, tank, car, other
			10, // points an artillery operator needs for a strike
			3, // points in the AI version for recruiting one soldier
			10, // points a player needs for an AAHALO parajump
			10, // points that get subtracted for creating a vehicle at a MHQ
			20, // points needed to create a vehicle at a MHQ
			3, // points a medic gets if someone heals at his Mash
			["Sergeant","Lieutenant","Captain","Major","Sergeant","Corporal"], // Ranks needed to drive different vehicles, starting with: kindof wheeled APC, kindof Tank, kindof Helicopter (except the inital 4 helis), Plane, Ships/Boats, StaticWeapon
			30, // points that get added if a player is xxx m in range of a main target when it gets cleared
			400, // range the player has to be in to get the main target extra points
			10, // points that get added if a player is xxx m in range of a sidemission when the sidemission is resolved
			200, // range the player has to be in to get the sidemission extra points
			20, // points needed for an egineer to rebuild the support buildings at base
			10, // not used anymore !!! Was points needed to build MG Nest before
			5, // points needed in AI Ranked to call in an airtaxi
			20, // points needed to call in an air drop
			4, // points a medic gets when he heals another unit
			1, // points that a player gets when transporting others
			20, // points needed for activating satellite view
			20, // points needed to build a FARP (engineer)
			2, // points a player gets for reviving another player
			10 // points a Squad Leader needs for a CAS
		];

		// distance a player has to transport others to get points
		d_transport_distance = 500;

		// rank needed to fly the wreck lift chopper
		d_wreck_lift_rank = "CAPTAIN";
	} else {
		d_ranked_a = [];
	};

	d_graslayer_index = if (d_GrasAtStart == 1) then {0} else {1};

	d_disable_viewdistance = d_ViewdistanceChange == 1;
};
// chopper varname, type (0 = lift chopper, 1 = wreck lift chopper, 2 = normal chopper), marker name, unique number (same as in d_init.sqf), marker type, marker color, marker text, chopper string name, if lifter then a list of liftables objects
d_choppers = [
	["D_HR1",0,"d_chopper1",3001,"n_air","ColorBlue","Hauler-1", localize "STR_DOM_MISSIONSTRING_7"],
	["D_HR2",2,"d_chopper2",3002,"n_air","ColorBlue","Raven-1",""],
	["D_HR3",2,"d_chopper3",3003,"n_air","ColorBlue","Raven-2",""],
	["D_HR4",0,"d_chopper4",3004,"n_air","ColorBlue","Hauler-2", localize "STR_DOM_MISSIONSTRING_10"],
	["D_HR5",1,"d_chopper5",3005,"n_air","ColorBlue","Bad Bird",""],
	["D_HR6",2,"d_chopper6",3006,"n_air","ColorBlue","Lilburd-1",""],
	["D_HR7",2,"d_chopper7",3007,"n_air","ColorBlue","Lilburd-2",""],
	["D_HR8",1,"d_chopper8",3008,"n_air","ColorBlue","Reaper",""],
	["D_HR9",1,"d_chopper9",3009,"n_air","ColorBlue","Blackwater-1",""],
	["D_HR10",0,"d_chopper10",3010,"n_air","ColorBlue","Blackwater-2",""],
	["D_HR11",0,"d_chopper11",3011,"n_air","ColorBlack","Nazgul",""]
];

d_planes = [
	["D_PL1",3,"d_plane1",3101,"n_plane","ColorBlue","Hog", ""],
	["D_HR1",3,"d_plane2",3102,"n_plane","ColorBlue","Lightning", ""],
	["D_CJ1",3,"d_plane3",3103,"n_plane","ColorBlue","Runner", ""]
];

// vehicle varname, unique number (same as in d_init.sqf), marker name, marker type, marker color, marker text, vehicle string name
d_p_vecs = [
	["D_MRR1",0,"d_mobilerespawn1","b_hq","ColorBrown","MHQ-1",localize "STR_DOM_MISSIONSTRING_12"],["D_MRR2",1,"d_mobilerespawn2","b_hq","ColorBrown","MHQ-2",localize "STR_DOM_MISSIONSTRING_13"],
	["D_MEDVEC1",100,"d_medvec1","n_med","ColorRed","M1",""],["D_MEDVEC2",101,"d_medvec2","n_med","ColorRed","M2",""],
	["D_TR1",200,"d_truck1","n_maint","ColorGreen","R1",""],["D_TR6",203,"d_truck4","n_maint","ColorGreen","R2",""],
	["D_TR2",201,"d_truck2","n_support","ColorGreen","F1",""],["D_TR5",204,"d_truck5","n_support","ColorGreen","F2",""],
	["D_TR3",202,"d_truck3","n_support","ColorGreen","A1",""],["D_TR4",205,"d_truck6","n_support","ColorGreen","A2",""],
	["D_TR7",300,"d_truck7","n_service","ColorGreen","E1",""],["D_TR8",301,"d_truck8","n_service","ColorGreen","E2",""],
	["D_TR10",400,"d_truck10","n_motor_inf","ColorBlue","T1",""],["D_TR9",401,"d_truck9","n_motor_inf","ColorBlue","T2",""],
	["D_TR11",402,"d_truck11","n_motor_inf","ColorBlue","T3",""],["D_TR12",403,"d_truck12","n_motor_inf","ColorBlue","T4",""],
	
	["D_C01",801,"d_car1","n_motor_inf","ColorBlue","Roamer-1",""],["D_C02",802,"d_car2","n_motor_inf","ColorBlue","Roamer-2",""],
	["D_C03",803,"d_car3","n_motor_inf","ColorBlue","Roamer-3",""],	["D_C04",804,"d_car4","n_motor_inf","ColorBlue","Gecko-1",""],
	["D_C05",805,"d_car5","n_motor_inf","ColorBlue","Gecko-2",""],	["D_C06",806,"d_car6","n_motor_inf","ColorBlue","Cartel-1",""],
	["D_C07",807,"d_car7","n_motor_inf","ColorBlue","Cartel-2",""],	["D_C08",808,"d_car8","n_motor_inf","ColorBlue","Boss",""],
	["D_C09",809,"d_car9","n_motor_inf","ColorBlue","Gecko-3",""],	["D_C10",810,"d_car10","n_motor_inf","ColorBlue","Roamer-4",""],
	["D_C11",811,"d_car11","n_motor_inf","ColorBlue","Roamer-5",""],["D_C12",812,"d_car12","n_motor_inf","ColorBlue","Roamer-6",""],
	["D_C13",813,"d_car13","n_motor_inf","ColorBlue","Gecko-4",""],["D_C14",814,"d_car14","n_motor_inf","ColorBlue","Gecko-5",""],
	["D_C15",815,"d_car15","n_motor_inf","ColorBlue","Crossbow",""],
		
	["D_T01",900,"d_tank1","n_armor","ColorBlue","Grizzly",""],["D_T02",901,"d_tank2","n_mech_inf","ColorBlue","Lava-1",""],
	["D_T03",902,"d_tank3","n_mech_inf","ColorBlue","Lava-2",""],["D_T04",903,"d_tank4","n_mech_inf","ColorBlue","Lava-3",""],
	["D_T05",904,"d_tank5","n_mech_inf","ColorBlue","Boomer",""],["D_T06",905,"d_tank6","n_mech_inf","ColorBlue","Ram-1",""],
	["D_T07",906,"d_tank7","n_mech_inf","ColorBlue","Ram-2",""],["D_T08",907,"d_tank8","n_mech_inf","ColorBlue","Arrow",""]
];

if (hasInterface) then {
	d_mob_respawns = [];
	{
		if (_x select 1 < 100) then {
			d_mob_respawns pushBack [_x select 0, _x select 6];
		};
		false
	} count d_p_vecs;
};

/*define veichles that is possible to lift*/
private _d_helilift1_types = ["B_MRAP_01_F","B_Truck_01_transport_F","B_Truck_01_covered_F","B_Truck_01_ammo_F","B_Truck_01_fuel_F","B_Truck_01_Repair_F","B_Truck_01_medical_F",
	"B_APC_Wheeled_01_cannon_F","B_APC_Tracked_01_rcws_F","B_MBT_01_cannon_F","B_MBT_01_TUSK_F","B_UGV_01_F","B_UGV_01_rcws_F","B_MRAP_01_gmg_F","B_MRAP_01_hmg_F",
	"B_APC_Tracked_01_CRV_F","B_Truck_01_box_F","B_Truck_01_mover_F","C_Offroad_01_F","C_SUV_01_F","I_APC_tracked_03_cannon_F","I_MBT_03_cannon_F","I_MRAP_03_F ","I_MRAP_03_hmg_F",
	"I_MRAP_03_gmg_F","I_APC_Wheeled_03_cannon_F", "B_T_APC_Tracked_01_CRV_F","B_T_Truck_01_transport_F","B_T_Truck_01_covered_F","B_T_Truck_01_medical_F","B_T_Truck_01_Repair_F",
	"B_T_Truck_01_fuel_F","B_T_Truck_01_ammo_F"];

/*define opfor veichles that could be used/lifted if enabled by servers parametres*/
private _armor = if (d_LockArmored == 1) then {["O_MBT_02_arty_F","O_APC_Tracked_02_cannon_F","O_MBT_02_cannon_F","O_APC_Tracked_02_AA_F","O_APC_Wheeled_02_rcws_F"]} else {[]};
private _car = if (d_LockCars == 1) then {["O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","O_MRAP_02_F"]} else {[]};
if !(_armor isEqualTo []) then {_d_helilift1_types append _armor};
if !(_car isEqualTo []) then {_d_helilift1_types append _car};

/*push a list of liftable objects in the d_choppers array*/
_d_helilift1_types = _d_helilift1_types apply {toUpper _x};
{
	if (_x select 1 == 0) then {
		_x pushBack _d_helilift1_types;
		_x pushBack d_heli_wreck_lift_types;
	};
	false
} count d_choppers;

if (hasInterface && {d_with_ai}) then {
	// additional AI recruit buildings
	// these have to be placed in the editor, give them a var name in the editor
	// only client handling means, no damage handling done for those buildings (contrary to the standard AI hut)
	// example:
	// d_additional_recruit_buildings = [my_ai_building1, my_ai_building2];
	d_additional_recruit_buildings = [];
};

diag_log [diag_frameno, diag_ticktime, time, "Dom x_initcommon.sqf processed"];