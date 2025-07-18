#include "x_setup.sqf"

d_arsenal_boxes = [];

[] spawn {

	waitUntil {sleep 1; ((str player) find "d_") != -1};
	
	if (isMultiplayer) then {
	
		if (isnil "d_still_in_intro") then {d_still_in_intro = true};
		
		waitUntil {sleep 1; !d_still_in_intro};
	
	};
	
	_cratePositionMarkers = ["arsenalMain","arsenalBadCo"];
	#ifdef __CARRIER__
		_cratePositionMarkers pushBack "arsenalCarrier";
	#endif
	_unit = str player;
	item_check_isArsenal = false;
	item_check_arsenalChecked = false;
		
	//slot-based restrictions
	_defaultWeps = [];
	_defaultBackpacks = [];
	_defaultItems = [];
	_defaultMags = [];

	//clan member restrictions
	if (call d_fnc_isbadco) then {
	
		_defaultWeps = d_defaultWeapons + d_whitelistWeapons - d_machineguns - d_sniping_rifles - d_launchers - d_grenadelaunchers - d_saboteur_only;
		_defaultBackpacks = d_defaultBackpacks + d_whitelistBackpacks - d_medium_backpacks - d_large_backpacks - d_engineer_backpacks;
		_defaultItems = d_defaultItems + d_whitelistItems - d_medium_armors - d_heavy_armors - d_medic_only - d_engineer_only - d_sniper_only - d_saboteur_only - d_pilot_only - d_crewman_only;
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
			restrictions_allowedItems = _defaultItems + d_medium_armors + d_rangefindersanddesignators;
			restrictions_allowedMagazines = _defaultMags;
							
		};	
		
		case ((_unit in d_attack_pilots) || {_unit in d_transport_pilots} || {_unit in d_crewmen}) : {
		
			restrictions_allowedWeapons = d_pilotWeapons;
			restrictions_allowedBackpacks = [];
			restrictions_allowedItems = d_pilot_only + d_standardItems;
			restrictions_allowedMagazines = _defaultMags;
			
			if (_unit == "d_medpilot") then {
			
				restrictions_allowedItems = restrictions_allowedItems + d_medic_only;
			
			};
			
			if (_unit in d_crewmen) then {
			
				restrictions_allowedItems = _defaultItems + d_crewman_only;
			
			};
		
		};	
		
		case (_unit in d_medics) : {
		
			restrictions_allowedWeapons = _defaultWeps;
			restrictions_allowedBackpacks = _defaultBackpacks + d_medium_backpacks;
			restrictions_allowedItems = _defaultItems + d_medic_only + d_heavy_armors + d_medium_armors + d_rangefindersanddesignators;
			restrictions_allowedMagazines = _defaultMags;
		
		};	
		
		case (_unit in d_is_engineer) : {
		
			restrictions_allowedWeapons = _defaultWeps;
			restrictions_allowedBackpacks = _defaultBackpacks + d_medium_backpacks + d_engineer_backpacks;
			restrictions_allowedItems = _defaultItems + d_engineer_only  + d_medium_armors + d_rangefindersanddesignators;
			restrictions_allowedMagazines = _defaultMags + d_explosives;
		
		};
		
		// removed
		case (_unit in d_saboteurs) : {
			
			restrictions_allowedWeapons = _defaultWeps + d_saboteur_only;
			restrictions_allowedBackpacks = _defaultBackpacks + d_medium_backpacks;
			restrictions_allowedItems = _defaultItems + d_saboteur_only + d_medium_armors + d_rangefindersanddesignators;
			restrictions_allowedMagazines = _defaultMags + d_explosives;
		
		};
		
		case ((_unit in d_snipers) || {_unit in d_spotters}) : {
		
			//these are now marksmen
			if (_unit in d_snipers) then {
			
					restrictions_allowedWeapons = _defaultWeps + d_sniping_rifles;
					restrictions_allowedItems = _defaultItems + d_medium_armors + d_heavy_armors + d_sniper_optics + d_sniper_only + d_rangefindersanddesignators;
			
			// spotters are removed
			} else {
			
				restrictions_allowedWeapons = _defaultWeps;
				restrictions_allowedItems = _defaultItems + d_sniper_optics + d_sniper_only + d_rangefindersanddesignators;
			
			};	
						
			restrictions_allowedBackpacks = _defaultBackpacks + d_medium_backpacks;
			restrictions_allowedMagazines = _defaultMags;
		
		};
		
		case (_unit in d_grenadiers) : {
		
			restrictions_allowedWeapons = _defaultWeps + d_grenadelaunchers;
			restrictions_allowedBackpacks = _defaultBackpacks + d_medium_backpacks;
			restrictions_allowedItems = _defaultItems + d_heavy_armors + d_medium_armors + d_rangefindersanddesignators;
			#ifdef __RHS__
				+ ["rhsusf_acc_M2A1"];
			#endif;
			restrictions_allowedMagazines = _defaultMags;		
				
		
		};
		
		case (_unit in d_autoriflemen) : {
		
			restrictions_allowedWeapons = _defaultWeps + d_machineguns;
			restrictions_allowedBackpacks = _defaultBackpacks;
			restrictions_allowedItems = _defaultItems + d_heavy_armors + d_medium_armors + d_rangefindersanddesignators
			#ifdef __RHS__
				+ ["rhsusf_acc_ACOG_MDO" + "rhsusf_acc_ELCAN_ard" + "rhsusf_acc_ELCAN"] // "ELCAN"s are M145 MG sights...
			#endif
			;
			restrictions_allowedMagazines = _defaultMags + d_machinegunnermags;
		
		};
		
		case (_unit in d_missilesp) : {
		
			restrictions_allowedWeapons = _defaultWeps + d_launchers
			#ifdef __RHS__
				+ ["rhs_weap_m72a7","rhs_weap_M136", "rhs_weap_panzerfaust60_used"];
			#else
				+ ["launch_NLAW_F"];
			#endif;
			restrictions_allowedBackpacks = _defaultBackpacks;
			restrictions_allowedItems = _defaultItems + d_heavy_armors + d_medium_armors + d_rangefindersanddesignators;
			restrictions_allowedMagazines = _defaultMags;
		
		};

		//rifleman
		default {
		
			restrictions_allowedWeapons = _defaultWeps 
			#ifdef __RHS__
				+ ["rhs_weap_m72a7","rhs_weap_M136", "rhs_weap_panzerfaust60", "rhs_weap_rpg75", "rhs_weap_panzerfaust60_used"]
			#else
				+ ["launch_NLAW_F"]
			#endif
			;
			restrictions_allowedBackpacks = ["B_UAV_06_backpack_F","B_UAV_01_backpack_F"] + _defaultBackpacks + d_medium_backpacks + d_large_backpacks;
			restrictions_allowedItems = _defaultItems + d_medium_armors + d_heavy_armors + ["B_UavTerminal"] + d_rangefindersanddesignators;
			restrictions_allowedMagazines = _defaultMags;
		
		};
	
	};
	
	//fix disposables
	#ifdef __RHS__
		{	
			restrictions_allowedMagazines pushback _x;		
		} foreach ["rhs_m136_mag","rhs_m72a7_mag","rhs_m136_hp_mag","rhs_m136_hedp_mag","rhs_rpg26_mag","rhs_rshg2_mag", "rhs_rpg18_mag", "rhs_fgm148_magazine_AT_empty", "rhs_panzerfaust60_mag", "rhs_rpg75_mag"];
		{	
			restrictions_allowedWeapons pushback _x;		
		} foreach ["rhs_weap_M136_used","rhs_weap_m72a7_used","rhs_weap_rpg26_used","rhs_weap_rshg2_used","rhs_weap_M136_hedp_used","rhs_weap_M136_hp_used", "rhs_weap_rpg18_used", "rhs_weap_rpg75_used"];
	#else
		{	
			restrictions_allowedMagazines pushback _x;		
		} foreach ["NLAW_F"];
	#endif
	
	//parachutes for everyone!!
	restrictions_allowedBackpacks pushBack "B_Parachute";
	
	//vanilla weps will load vanilla stanag so need to unrestrict that too... 
	restrictions_allowedMagazines pushBackUnique "30Rnd_556x45_Stanag";
	
	if (!(call d_fnc_isbadco)) then {
	
		restrictions_allowedMagazines = restrictions_allowedMagazines - d_whitelistMagazines;
		restrictions_allowedWeapons = restrictions_allowedWeapons - d_whitelistWeapons;
		restrictions_allowedBackpacks = restrictions_allowedBackpacks - d_whitelistBackpacks;
		restrictions_allowedItems = restrictions_allowedItems - d_whitelistItems;
	
	};
	
	restrictions_allAllowedItems = restrictions_allowedWeapons + restrictions_allowedBackpacks +
																	restrictions_allowedItems +	restrictions_allowedMagazines;	
	
	if (isNil "bis_fnc_arsenal_boxes") then {bis_fnc_arsenal_boxes = [];};

	{

		_box = "CargoNet_01_box_F" createVehicleLocal (markerPos _x);
		#ifdef __CARRIER__
			if (surfaceIsWater markerpos _x) then {
				_box setposasl [(markerPos _x) select 0, (markerPos _x) select 1, ((getPosASL D_FLAG_BASE) select 2) + 2];
			} else {
				_box setposatl [(markerPos _x) select 0, (markerPos _x) select 1,2];
			};
		#else
			_box setposatl [(markerPos _x) select 0, (markerPos _x) select 1,2];
		#endif
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
		
		_box setVariable ["d_no_lift", true];
		_box enableRopeAttach false;
		
		// experimental
		_box spawn {
			sleep 10;
			_this enableSimulation false;
		};

	} foreach _cratePositionMarkers;

	"AmmoboxLocal" call BIS_fnc_arsenal;
	
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
		/*
		if ((str player) in d_badcompany) then {
			player remoteExecCall ["d_fnc_badco_uniform",-2,false];		
		};
		*/
		
		item_check_isArsenal = true;
		item_check_isInArsenal = false;
		item_check_arsenalChecked = false;
		
		//remove default magazines that might have been automatically added if not allowed
		_mags = primaryWeaponMagazine player;
		if ((count _mags) > 0) then {
			_item = _mags select 0;
			if (!(_item in restrictions_allowedMagazines)) then {
				item_check_arsenalChecked = true;
				player removePrimaryWeaponItem _item;
				player removeMagazines _item;
			};
		};
		_mags = secondaryWeaponMagazine player;
			if ((count _mags) > 0) then {
			_item = _mags select 0;
			if (!(_item in restrictions_allowedMagazines)) then {
				item_check_arsenalChecked = true;
				player removeSecondaryWeaponItem _item;
				player removeMagazines _item;
			};
		};
		_mags = handgunMagazine player;
			if ((count _mags) > 0) then {
			_item = _mags select 0;
			if (!(_item in restrictions_allowedMagazines)) then {
				item_check_arsenalChecked = true;
				player removeHandgunItem _item;
				player removeMagazines _item;
			};
		};

		//check whole gear to remove any disallowed items acquired from loading a saved loadout
		if (((uniform player) != "") && {!((uniform player) in restrictions_allowedItems)}) then {
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
		if (((vest player) != "") && {!((vest player) in restrictions_allowedItems)}) then {
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
		if (((backpack player) != "") && {!((backpack player) in restrictions_allowedBackpacks)}) then {
			item_check_arsenalChecked = true;
			removeBackpack player; //otherwise old backpack gets dropped on ground
			if (item_check_fallbackBackpack != "") then {
				_items = backpackItems player;
				player addBackpack item_check_fallbackBackpack;
				_container = backpackContainer player;
				{
					_container addItemCargoGlobal [_x, 1]; 
				} foreach _items;
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
				player removeMagazines _x;
			};
		} foreach (((magazines player) + (items player)  + (assigneditems player) + [goggles player] + [headgear player] + (primaryWeaponItems player) + (secondaryWeaponItems player) + (handgunItems player)) - [""]);

		_weapons = (weapons player) - (assigneditems player);
		{
			if (!(_x in restrictions_allowedWeapons)) then {
				item_check_arsenalChecked = true;
				player removeWeapon (_weapons select _foreachIndex);
			};
		} foreach (_weapons apply {[_x] call BIS_fnc_baseWeapon});
		
		// disable remote connecting to base AA
		{
			player disableUAVConnectability [_x, true];
		} foreach d_baseAAremotevics;
		
		if (item_check_arsenalChecked) then {
		
			hint parseText
				"<t color='#FF0000' shadow='1' shadowColor='#000000' size='3.0'>WARNING!</t><br/><br/>
				<t color='#FF0000' shadow='1' shadowColor='#000000' size='1.5'>Your loadout contains items that are restricted depending on the role you have chosen.</t><br/><br/>
				<t color='#00AAFF' shadow='1' shadowColor='#000000' size='1.5'>You can only use items that you see in the Arsenal. To change your role, exit back to the server lobby and pick a different slot.</t><br/><br/>
				<t color='#FFFFFF' shadow='1' shadowColor='#000000' size='1.5'>Items have been removed or replaced with defaults.<br/><br/>Note that some items might also be restricted to members only.</t>";
		};
		
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