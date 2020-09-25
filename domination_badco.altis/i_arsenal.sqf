#include "x_setup.sqf"

[] spawn {

	waitUntil {sleep 1; ((str player) find "d_") != -1};
	
	if (isMultiplayer) then {
	
		if (isnil "d_still_in_intro") then {d_still_in_intro = true};
		
		waitUntil {sleep 1; !d_still_in_intro};
	
	};
	
	_cratePositionMarkers = ["arsenalMain","arsenalBadCo"];
	_unit = str player;

	d_arsenal_boxes = [];
	item_check_isArsenal = false;
	item_check_arsenalChecked = false;
		
	//slot-based restrictions		
	_defaultWeps = [];
	_defaultBackpacks = [];
	_defaultItems = [];
	_defaultMags = [];

	//clan member restrictions
	if (_unit in d_badcompany) then {
	
		_defaultWeps = d_defaultWeapons + d_whitelistWeapons - d_machineguns - d_sniping_rifles - d_launchers - d_grenadelaunchers - d_saboteur_only;
		_defaultBackpacks = d_defaultBackpacks + d_whitelistBackpacks - d_medium_backpacks - d_large_backpacks - d_engineer_backpacks;
		_defaultItems = d_defaultItems + d_whitelistItems - d_medium_armors - d_heavy_armors - d_medic_only - d_engineer_only - d_sniper_only - d_saboteur_only;
		_defaultMags = d_defaultMagazines + d_whitelistMagazines - d_engineer_only - d_machinegunnermags;
	
	} else {
	
		_defaultWeps = d_defaultWeapons;
		_defaultBackpacks = d_defaultBackpacks;
		_defaultItems = d_defaultItems;
		_defaultMags = d_defaultMagazines;
	
	};
	
	restrictions_allowedWeapons = [];
	restrictions_allowedBackpacks = [];
	restrictions_allowedItems = [];
	restrictions_allowedMagazines = [];	
	
	switch (true) do {
		
		case (_unit == "d_artop_1") : {
		
			restrictions_allowedWeapons = _defaultWeps;
			restrictions_allowedBackpacks = _defaultBackpacks;
			restrictions_allowedItems = _defaultItems + d_medium_armors + ["Rangefinder","Laserdesignator","Laserdesignator_03","Laserdesignator_01_khk_F","Laserdesignator_02","Laserdesignator_02_ghex_F"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems});
			restrictions_allowedMagazines = _defaultMags;
							
		};	
		
		case ((_unit in d_attack_pilots) || {_unit in d_transport_pilots} || {_unit in d_crewmen}) : {
		
			restrictions_allowedWeapons = d_pilotWeapons  - (if (_unit in d_badcompany) then {[]} else {d_whitelistWeapons});
			restrictions_allowedBackpacks = [];
			restrictions_allowedItems = d_pilot_only + ["ItemMap","ItemCompass","ItemWatch","ItemRadio","ItemGPS","NVGoggles","NVGoggles_tna_F","NVGoggles_INDEP",
			#ifdef __RHS__
				"rhsusf_ANPVS_14","rhsusf_ANPVS_15","rhsusf_Rhino",
			#endif
			"FirstAidKit"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems});
			restrictions_allowedMagazines = _defaultMags;
			
			if (_unit == "d_medpilot") then {
			
				restrictions_allowedItems = restrictions_allowedItems + d_medic_only - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems});
			
			};
			
			if (_unit in d_crewmen) then {
			
				restrictions_allowedItems = _defaultItems + ["Rangefinder"] + d_crewman_only - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems});
			
			};
		
		};	
		
		case (_unit in d_medics) : {
		
			restrictions_allowedWeapons = _defaultWeps;
			restrictions_allowedBackpacks = _defaultBackpacks + d_medium_backpacks - (if (_unit in d_badcompany) then {[]} else {d_whitelistBackpacks});
			restrictions_allowedItems = _defaultItems + d_medic_only + d_heavy_armors + d_medium_armors + ["Rangefinder","Laserdesignator","Laserdesignator_03","Laserdesignator_01_khk_F","Laserdesignator_02","Laserdesignator_02_ghex_F"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems});
			restrictions_allowedMagazines = _defaultMags;
		
		};	
		
		case (_unit in d_is_engineer) : {
		
			restrictions_allowedWeapons = _defaultWeps;
			restrictions_allowedBackpacks = _defaultBackpacks + d_large_backpacks + d_medium_backpacks + d_engineer_backpacks - (if (_unit in d_badcompany) then {[]} else {d_whitelistBackpacks});
			restrictions_allowedItems = _defaultItems + d_engineer_only  + d_medium_armors + ["Rangefinder","Laserdesignator","Laserdesignator_03","Laserdesignator_01_khk_F","Laserdesignator_02","Laserdesignator_02_ghex_F"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems});
			restrictions_allowedMagazines = _defaultMags + d_explosives - (if (_unit in d_badcompany) then {[]} else {d_whitelistMagazines});
		
		};
		
		case (_unit in d_saboteurs) : {
			
			restrictions_allowedWeapons = _defaultWeps + d_saboteur_only - (if (_unit in d_badcompany) then {[]} else {d_whitelistWeapons});
			restrictions_allowedBackpacks = _defaultBackpacks + d_medium_backpacks - (if (_unit in d_badcompany) then {[]} else {d_whitelistBackpacks});
			restrictions_allowedItems = _defaultItems + d_saboteur_only + d_medium_armors + ["Rangefinder","Laserdesignator","Laserdesignator_03","Laserdesignator_01_khk_F","Laserdesignator_02","Laserdesignator_02_ghex_F"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems});
			restrictions_allowedMagazines = _defaultMags + d_explosives - (if (_unit in d_badcompany) then {[]} else {d_whitelistMagazines});
		
		};
		
		case ((_unit in d_snipers) || {_unit in d_spotters}) : {
		
			//these are now marksmen
			if (_unit in d_snipers) then {
			
					restrictions_allowedWeapons = _defaultWeps + d_sniping_rifles - (if (_unit in d_badcompany) then {[]} else {d_whitelistWeapons});
					restrictions_allowedItems = _defaultItems + d_medium_armors + d_heavy_armors + d_sniper_optics + d_sniper_only + ["Rangefinder","Laserdesignator","Laserdesignator_03","Laserdesignator_01_khk_F","Laserdesignator_02","Laserdesignator_02_ghex_F"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems});					
			
			} else {
			
				restrictions_allowedWeapons = _defaultWeps;
				restrictions_allowedItems = _defaultItems + d_sniper_optics + d_sniper_only + ["Rangefinder","Laserdesignator","Laserdesignator_03","Laserdesignator_01_khk_F","Laserdesignator_02","Laserdesignator_02_ghex_F"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems});
			
			};	
						
			restrictions_allowedBackpacks = _defaultBackpacks;
			restrictions_allowedMagazines = _defaultMags;
		
		};
		
		case (_unit in d_grenadiers) : {
		
			restrictions_allowedWeapons = _defaultWeps + d_grenadelaunchers - (if (_unit in d_badcompany) then {[]} else {d_whitelistWeapons});
			restrictions_allowedBackpacks = _defaultBackpacks + d_large_backpacks + d_medium_backpacks - (if (_unit in d_badcompany) then {[]} else {d_whitelistBackpacks});
			restrictions_allowedItems = _defaultItems + d_heavy_armors + d_medium_armors + ["Rangefinder","Laserdesignator","Laserdesignator_03","Laserdesignator_01_khk_F","Laserdesignator_02","Laserdesignator_02_ghex_F"]
			#ifdef __RHS__
				+ ["rhsusf_acc_M2A1"]
			#endif
			- (if (_unit in d_badcompany) then {[]} else {d_whitelistItems});
			restrictions_allowedMagazines = _defaultMags;		
				
		
		};
		
		case (_unit in d_autoriflemen) : {
		
			restrictions_allowedWeapons = _defaultWeps + d_machineguns - (if (_unit in d_badcompany) then {[]} else {d_whitelistWeapons});
			restrictions_allowedBackpacks = _defaultBackpacks + d_medium_backpacks - (if (_unit in d_badcompany) then {[]} else {d_whitelistBackpacks});
			restrictions_allowedItems = _defaultItems + d_heavy_armors + d_medium_armors + ["Rangefinder","Laserdesignator","Laserdesignator_03","Laserdesignator_01_khk_F","Laserdesignator_02","Laserdesignator_02_ghex_F"]
			#ifdef __RHS__
				+ ["rhsusf_acc_ACOG_MDO" + "rhsusf_acc_ELCAN_ard" + "rhsusf_acc_ELCAN"] // "ELCAN"s are M145 MG sights...
			#endif
			- (if (_unit in d_badcompany) then {[]} else {d_whitelistItems});
			restrictions_allowedMagazines = _defaultMags + d_machinegunnermags - (if (_unit in d_badcompany) then {[]} else {d_whitelistMagazines});;
		
		};
		
		case (_unit in d_missilesp) : {
		
			restrictions_allowedWeapons = _defaultWeps + d_launchers
			#ifdef __RHS__
				+ ["rhs_weap_m72a7","rhs_weap_M136"]
			#else
				+ ["launch_NLAW_F"]
			#endif
			- (if (_unit in d_badcompany) then {[]} else {d_whitelistWeapons});
			restrictions_allowedBackpacks = _defaultBackpacks + d_large_backpacks + d_medium_backpacks - (if (_unit in d_badcompany) then {[]} else {d_whitelistBackpacks});
			restrictions_allowedItems = _defaultItems + d_heavy_armors + d_medium_armors + ["Rangefinder","Laserdesignator","Laserdesignator_03","Laserdesignator_01_khk_F","Laserdesignator_02","Laserdesignator_02_ghex_F"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems});
			restrictions_allowedMagazines = _defaultMags;
		
		};

		//rifleman
		default {
		
			restrictions_allowedWeapons = _defaultWeps 
			#ifdef __RHS__
				+ ["rhs_weap_m72a7","rhs_weap_M136"]
			#else
				+ ["launch_NLAW_F"]
			#endif
			;
			restrictions_allowedBackpacks = ["B_UAV_06_backpack_F","B_UAV_01_backpack_F"] + _defaultBackpacks + d_medium_backpacks - (if (_unit in d_badcompany) then {[]} else {d_whitelistBackpacks});
			restrictions_allowedItems = _defaultItems + d_medium_armors + d_heavy_armors + ["B_UavTerminal","Rangefinder","Laserdesignator","Laserdesignator_03","Laserdesignator_01_khk_F","Laserdesignator_02","Laserdesignator_02_ghex_F"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems});
			restrictions_allowedMagazines = _defaultMags;
		
		};
	
	};
	
	//fix disposables
	#ifdef __RHS__
		{	
			restrictions_allowedMagazines pushback _x;		
		} foreach ["rhs_m136_mag","rhs_m72a7_mag","rhs_m136_hp_mag","rhs_m136_hedp_mag","rhs_rpg26_mag","rhs_rshg2_mag"];
		{	
			restrictions_allowedWeapons pushback _x;		
		} foreach ["rhs_weap_M136_used","rhs_weap_m72a7_used","rhs_weap_rpg26_used","rhs_weap_rshg2_used","rhs_weap_M136_hedp_used","rhs_weap_M136_hp_used"];
	#else
		{	
			restrictions_allowedMagazines pushback _x;		
		} foreach ["NLAW_F"];
	#endif
	
	//parachutes for everyone!!
	restrictions_allowedBackpacks pushBack "B_Parachute";
	
	//dafuq is wrong with the ADR?!!	
	restrictions_allowedWeapons pushBackUnique "50Rnd_570x28_SMG_03";
	//vanilla weps will load vanilla stanag so need to unrestrict that too... 
	restrictions_allowedWeapons pushBackUnique "30Rnd_556x45_Stanag";
	
	restrictions_allAllowedItems = restrictions_allowedWeapons + restrictions_allowedBackpacks +
																	restrictions_allowedItems +	restrictions_allowedMagazines;	
	
	if (isNil "bis_fnc_arsenal_boxes") then {bis_fnc_arsenal_boxes = [];};

	{

		_box = "CargoNet_01_box_F" createVehicleLocal (markerPos _x);
		_box setposatl [(markerPos _x) select 0, (markerPos _x) select 1,2];
		player reveal _box;
		
		clearWeaponCargo _box;
		clearItemCargo _box;
		clearBackpackCargo _box;
		clearMagazineCargo _box;

		if (_unit == "d_admin") then {
		
			[_box,["%ALL"],false,false] call BIS_fnc_addVirtualWeaponCargo;
			[_box,["%ALL"],false,false] call BIS_fnc_addVirtualBackpackCargo;
			[_box,["%ALL"],false,false] call BIS_fnc_addVirtualItemCargo;
			[_box,["%ALL"],false,false] call BIS_fnc_addVirtualMagazineCargo;
		
		} else {			
			
			[_box,restrictions_allowedWeapons,false,false] call BIS_fnc_addVirtualWeaponCargo;
			[_box,restrictions_allowedBackpacks,false,false] call BIS_fnc_addVirtualBackpackCargo;
			[_box,restrictions_allowedItems,false,false] call BIS_fnc_addVirtualItemCargo;
			[_box,restrictions_allowedMagazines,false,false] call BIS_fnc_addVirtualMagazineCargo;
		
		};
		
		bis_fnc_arsenal_boxes pushBackUnique _box;
		d_arsenal_boxes pushBack _box;	

		//Workaround arsenal action not appearing sometimes...
		sleep 0.1;
		_box addaction [
			"<t color='#e01414'>Arsenal</t>",
			{
			_box = _this select 0;
			_unit = _this select 1;
			["Open",[nil,_box,_unit]] spawn bis_fnc_arsenal;
			},
			[],
			99,
			true,
			false,
			"",
			"alive _target && {vehicle _this == _this}",
			5
		];
		
		

	} foreach _cratePositionMarkers;

	"AmmoboxLocal" call BIS_fnc_arsenal;


	addMissionEventHandler ["Draw3D", {

		_pos_cam = positionCameraToWorld [0,0,0];
			
		if (_pos_cam inArea "d_base_marker") then {
		
			{
				_box = _x;
				if (!isNull _box) then {
					_distp = _pos_cam distance _box;				
					if (_distp < 50) then {
						_pos = getPosATL _box;
						_scale = 0.033 - (_distp / 9000);
						_pos set [2, 1.5 + (_distp * 0.05)];
						_alpha = 1 - (_distp / 200);
						drawIcon3D ["#(argb,8,8,3)color(0,0,0,0)", [0,1,0.2,_alpha], _pos, 1, 1, 0, "Virtual Arsenal", 1, _scale, "RobotoCondensed"];
					};
				};			
			} foreach d_arsenal_boxes;
		
		};

	}];
	
	//to override RHS script error causing game freeze when opening arsenal with no weapon...
	[missionNamespace, "arsenalOpened"] call BIS_fnc_removeAllScriptedEventHandlers; 

	// disable unneeded functions that can override restrictions...
	// save loadout for restriction handling in case of saved loadout use
	item_check_isInArsenal = false;
	[missionNamespace, "arsenalOpened", {
			item_check_isInArsenal = true;
			disableSerialization;
			params ["_display"];
			item_check_arsenalSavedLoadout = getUnitLoadout player;
			_display displayRemoveAllEventHandlers "keydown";
			_display displayAddEventHandler ["keydown", "_this select 3"];
			{(_display displayCtrl _x) ctrlShow false} forEach [/*44151,*/44150,/*44146,44147,*/44148, 44149, 44346];
	}] call BIS_fnc_addScriptedEventHandler;

	
	item_check_fallbackBackpack = "";
	item_check_fallbackUniform = uniform player;
	item_check_fallbackVest = "";
	if ("V_Chestrig_rgr" in restrictions_allowedItems) then {
		item_check_fallbackVest = "V_Chestrig_rgr";
	};
	if ("B_AssaultPack_dgtl" in restrictions_allowedBackpacks) then {
		item_check_fallbackBackpack = "B_AssaultPack_dgtl";
	};
	
	//check for restricted gear in case of saved loadout used
	[missionNamespace, "arsenalClosed", {
	
		//apply badco uniform
		if ((str player) in d_badcompany) then {

			player remoteExecCall ["d_fnc_badco_uniform",-2,false];
		
		};
		
		item_check_isArsenal = true;
		item_check_isInArsenal = false;
		item_check_arsenalChecked = false;
		
		//remove default magazines that might have been automatically added if not allowed
		_item = (primaryWeaponMagazine player) select 0;
		if (!(_item in restrictions_allAllowedItems)) then {
			player removePrimaryWeaponItem _item;
			player removeMagazines _item;
		};
		_item = (secondaryWeaponMagazine player) select 0;
		if (!(_item in restrictions_allAllowedItems)) then {
			player removeSecondaryWeaponItem _item;
			player removeMagazines _item;
		};
		_item = (handgunMagazine player) select 0;
		if (!(_item in restrictions_allAllowedItems)) then {
			player removeHandgunItem _item;
			player removeMagazines _item;
		};
		
		// check all items and remove any disallowed ones since most people will attempt to load their preset loadouts.
		/*
		{		
			[player,objnull,_x] call d_fnc_ptakeweapon;		
		} foreach (((weapons player) + (magazines player) + (items player) + [uniform player] + [backpack player] + [vest player] + (assigneditems player) + [goggles player] + [headgear player]) - [""]);
		*/
		if (!((uniform player) in restrictions_allowedItems)) then {
			item_check_arsenalChecked = true;
			if (item_check_fallbackUniform != "") then {
				_items = uniformItems player;
				player forceAddUniform item_check_fallbackUniform;
				_container = uniformContainer player;
				{
					_container addItemCargoGlobal [_x, 1]; 
				} foreach _items;
			} else {
				removeUniform player;
			};
		};
		if (!((vest player) in restrictions_allowedItems)) then {
			item_check_arsenalChecked = true;
			if (item_check_fallbackVest != "") then {
				_items = vestItems player;
				player addVest item_check_fallbackVest;
				_container = vestContainer player;
				{
					_container addItemCargoGlobal [_x, 1]; 
				} foreach _items;
			} else {
				removeVest player;
			};
		};
		if (!((backpack player) in restrictions_allowedBackpacks)) then {
			item_check_arsenalChecked = true;
			if (item_check_fallbackBackpack != "") then {
				_items = backpackItems player;
				player addBackpack item_check_fallbackBackpack;
				_container = backpackContainer player;
				{
					_container addItemCargoGlobal [_x, 1]; 
				} foreach _items;
			} else {
				removeBackpack player;
			};
		};
		{		
			if (!(_x in restrictions_allAllowedItems)) then {
				item_check_arsenalChecked = true;
				player removeitems _x;
				player removePrimaryWeaponItem _x;
				player removeSecondaryWeaponItem _x;
				player removeHandgunItem _x;
				player unlinkItem _x;
				player removeWeapon _x;
				player removeMagazines _x;
			};
		} foreach (((weapons player) + (magazines player) + (items player)  + (assigneditems player) + [goggles player] + [headgear player] + (primaryWeaponItems player) + (secondaryWeaponItems player) + (handgunItems player)) - [""]);
		if (item_check_arsenalChecked) then {hint "Your loadout contains items that are restricted depending on the role you have chosen.\n\nYou can only use items that you see in the Arsenal. To change your role, exit back to the server lobby and pick a different slot.\n\nItems have been removed or replaced with defaults.\n\nNote that some items might also be restricted to members only.";};
		
		// for some reason loading saved PCML loadout doesn't come with a rocket loaded... needs checking for RHS too
		if (((secondaryWeapon player) == "launch_NLAW_F") && {(count (secondaryWeaponMagazine player)) == 0}) then {
			player addSecondaryWeaponItem "NLAW_F";
		};
		
		item_check_isArsenal = false;
		item_check_arsenalChecked = false;

	}] call BIS_fnc_addScriptedEventHandler;


	{
		(_x select 0) hideObject true;
		(_x select 0) enableSimulation false;
	} foreach d_static_ammoboxes;

};