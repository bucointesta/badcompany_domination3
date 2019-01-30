_cratePositionMarkers = ["arsenalMain","arsenalBadCo"];
_unit = str player;

d_arsenal_boxes = [];
item_check_isArsenal = false;
item_check_arsenalChecked = false;

{

	_box = "CargoNet_01_box_F" createVehicleLocal (markerPos _x);
	_box setposatl [(markerPos _x) select 0, (markerPos _x) select 1,2];
	
	clearWeaponCargo _box;
	clearItemCargo _box;
	clearBackpackCargo _box;
	clearMagazineCargo _box;

	if (_unit == "d_admin") then {
	
		[_box,["%ALL"]] call BIS_fnc_addVirtualWeaponCargo;
		[_box,["%ALL"]] call BIS_fnc_addVirtualBackpackCargo;
		[_box,["%ALL"]] call BIS_fnc_addVirtualItemCargo;
		[_box,["%ALL"]] call BIS_fnc_addVirtualMagazineCargo;
	
	} else {
	
		_defaultWeps = [];
		_defaultBackpacks = [];
		_defaultItems = [];
		_defaultMags = [];
	
		//clan member restrictions
		if (_unit in d_badcompany) then {
		
			_defaultWeps = d_defaultWeapons + d_whitelistWeapons - d_machineguns - d_sniping_rifles - d_launchers - d_grenadelaunchers - d_saboteur_only;
			_defaultBackpacks = d_defaultBackpacks + d_whitelistBackpacks - d_medium_backpacks - d_large_backpacks;
			_defaultItems = d_defaultItems + d_whitelistItems - d_medium_armors - d_heavy_armors - d_medic_only - d_engineer_only - d_sniper_only - d_saboteur_only;
			_defaultMags = d_defaultMagazines + d_whitelistMagazines;
		
		} else {
		
			_defaultWeps = d_defaultWeapons;
			_defaultBackpacks = d_defaultBackpacks;
			_defaultItems = d_defaultItems;
			_defaultMags = d_defaultMagazines;
		
		};
		
		
		//slot-based restrictions		
		switch (true) do {
			
			case (_unit == "d_artop_1") : {
			
				[_box,_defaultWeps] call BIS_fnc_addVirtualWeaponCargo;
				[_box,_defaultBackpacks] call BIS_fnc_addVirtualBackpackCargo;
				[_box,_defaultItems + d_medium_armors + ["Rangefinder"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems})] call BIS_fnc_addVirtualItemCargo;
				[_box,_defaultMags] call BIS_fnc_addVirtualMagazineCargo;
			
			};	
			
			case ((_unit in d_attack_pilots) || {_unit in d_transport_pilots}) : {
			
				[_box,d_pilotWeapons  - (if (_unit in d_badcompany) then {[]} else {d_whitelistWeapons})] call BIS_fnc_addVirtualWeaponCargo;
				[_box,["B_Parachute"]] call BIS_fnc_addVirtualBackpackCargo;
				[_box,d_pilot_uniforms + d_medium_armors + d_light_armors - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems})] call BIS_fnc_addVirtualItemCargo;
				[_box,_defaultMags] call BIS_fnc_addVirtualMagazineCargo;
			
			};	
			
			case (_unit in d_medics) : {
			
				[_box,_defaultWeps] call BIS_fnc_addVirtualWeaponCargo;
				[_box,_defaultBackpacks + d_medium_backpacks - (if (_unit in d_badcompany) then {[]} else {d_whitelistBackpacks})] call BIS_fnc_addVirtualBackpackCargo;
				[_box,_defaultItems + d_medic_only + d_medium_armors - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems})] call BIS_fnc_addVirtualItemCargo;
				[_box,_defaultMags] call BIS_fnc_addVirtualMagazineCargo;
			
			};	
			
			case (_unit in d_is_engineer) : {
			
				[_box,_defaultWeps + ["launch_NLAW_F"]] call BIS_fnc_addVirtualWeaponCargo;
				[_box,_defaultBackpacks + d_large_backpacks + d_medium_backpacks - (if (_unit in d_badcompany) then {[]} else {d_whitelistBackpacks})] call BIS_fnc_addVirtualBackpackCargo;
				[_box,_defaultItems + d_engineer_only + d_heavy_armors + d_medium_armors + ["Rangefinder"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems})] call BIS_fnc_addVirtualItemCargo;
				[_box,_defaultMags + ["SatchelCharge_Remote_Mag"] + d_explosives - (if (_unit in d_badcompany) then {[]} else {d_whitelistMagazines})] call BIS_fnc_addVirtualMagazineCargo;
			
			};
			
			case (_unit in d_saboteurs) : {
			
				[_box,_defaultWeps + d_saboteur_only + ["launch_NLAW_F"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistWeapons})] call BIS_fnc_addVirtualWeaponCargo;
				[_box,_defaultBackpacks + d_medium_backpacks - (if (_unit in d_badcompany) then {[]} else {d_whitelistBackpacks})] call BIS_fnc_addVirtualBackpackCargo;
				[_box,_defaultItems + d_saboteur_only + d_medium_armors + ["Rangefinder"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems})] call BIS_fnc_addVirtualItemCargo;
				[_box,_defaultMags + ["SatchelCharge_Remote_Mag"] + d_explosives - (if (_unit in d_badcompany) then {[]} else {d_whitelistMagazines})] call BIS_fnc_addVirtualMagazineCargo;
			
			};
			
			case ((_unit in d_snipers) || {_unit in d_spotters}) : {
			
				if (_unit in d_snipers) then {
					
					[_box,_defaultWeps + d_sniping_rifles - (if (_unit in d_badcompany) then {[]} else {d_whitelistWeapons})] call BIS_fnc_addVirtualWeaponCargo;	
					[_box,_defaultItems + d_sniper_optics + d_sniper_only + ["Rangefinder"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems})] call BIS_fnc_addVirtualItemCargo;
				
				} else {
				
					[_box,_defaultWeps] call BIS_fnc_addVirtualWeaponCargo;
					[_box,_defaultItems + d_sniper_optics + d_sniper_only + ["Rangefinder","Laserdesignator"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems})] call BIS_fnc_addVirtualItemCargo;
				
				};	
				
				[_box,_defaultBackpacks] call BIS_fnc_addVirtualBackpackCargo;
				[_box,_defaultMags] call BIS_fnc_addVirtualMagazineCargo;
			
			};
			
			case ((_unit in d_grenadiers) || {_unit in d_leaders}) : {
			
				[_box,_defaultWeps + d_grenadelaunchers + ["launch_NLAW_F"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistWeapons})] call BIS_fnc_addVirtualWeaponCargo;			
				
				if (_unit in d_leaders) then {
				
					[_box,_defaultMags + ["SatchelCharge_Remote_Mag"]] call BIS_fnc_addVirtualMagazineCargo;
					[_box,_defaultBackpacks] call BIS_fnc_addVirtualBackpackCargo;
					[_box,_defaultItems + d_medium_armors + ["Rangefinder","Laserdesignator"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems})] call BIS_fnc_addVirtualItemCargo;
				
				} else {
				
					[_box,_defaultMags] call BIS_fnc_addVirtualMagazineCargo;
					[_box,_defaultBackpacks + d_large_backpacks + d_medium_backpacks - (if (_unit in d_badcompany) then {[]} else {d_whitelistBackpacks})] call BIS_fnc_addVirtualBackpackCargo;
					[_box,_defaultItems + d_heavy_armors + d_medium_armors + ["Rangefinder"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems})] call BIS_fnc_addVirtualItemCargo;					
				
				};		
			
			};
			
			case (_unit in d_autoriflemen) : {
			
				[_box,_defaultWeps + d_machineguns + ["launch_NLAW_F"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistWeapons})] call BIS_fnc_addVirtualWeaponCargo;
				[_box,_defaultBackpacks + d_medium_backpacks - (if (_unit in d_badcompany) then {[]} else {d_whitelistBackpacks})] call BIS_fnc_addVirtualBackpackCargo;
				[_box,_defaultItems + d_medium_armors + ["Rangefinder","optic_tws_mg"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems})] call BIS_fnc_addVirtualItemCargo;
				[_box,_defaultMags] call BIS_fnc_addVirtualMagazineCargo;
			
			};
			
			case (_unit in d_missilesp) : {
			
				[_box,_defaultWeps + d_launchers + ["launch_NLAW_F"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistWeapons})] call BIS_fnc_addVirtualWeaponCargo;
				[_box,_defaultBackpacks + d_large_backpacks + d_medium_backpacks - (if (_unit in d_badcompany) then {[]} else {d_whitelistBackpacks})] call BIS_fnc_addVirtualBackpackCargo;
				[_box,_defaultItems + d_heavy_armors + d_medium_armors + ["Rangefinder"] - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems})] call BIS_fnc_addVirtualItemCargo;
				[_box,_defaultMags] call BIS_fnc_addVirtualMagazineCargo;
			
			};

			//rifleman
			default {
			
				[_box,_defaultWeps + ["launch_NLAW_F"]] call BIS_fnc_addVirtualWeaponCargo;
				[_box,_defaultBackpacks + d_medium_backpacks - (if (_unit in d_badcompany) then {[]} else {d_whitelistBackpacks})] call BIS_fnc_addVirtualBackpackCargo;
				[_box,_defaultItems + d_medium_armors - (if (_unit in d_badcompany) then {[]} else {d_whitelistItems})] call BIS_fnc_addVirtualItemCargo;
				[_box,_defaultMags] call BIS_fnc_addVirtualMagazineCargo;
			
			};
		
		};
	
	};
	
	if (isNil "bis_fnc_arsenal_boxes") then {bis_fnc_arsenal_boxes = [];};
	bis_fnc_arsenal_boxes pushBack _box;
	d_arsenal_boxes pushBack _box;

} foreach _cratePositionMarkers;

"AmmoboxLocal" call BIS_fnc_arsenal;


addMissionEventHandler ["Draw3D", {

	_pos_cam = positionCameraToWorld [0,0,0];
		
	if (_pos_cam inArea "d_base_marker") then {
	
		{
			_box = _x;
			if (!isNull _box) then {
				_distp = _pos_cam distance _box;				
				if (_distp < 20) then {
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


// disable unneeded functions that can override restrictions...
// save loadout for restriction handling in case of saved loadout use
[missionNamespace, "arsenalOpened", {
		disableSerialization;
		params ["_display"];
		item_check_arsenalSavedLoadout = getUnitLoadout player;
		_display displayRemoveAllEventHandlers "keydown";
		_display displayAddEventHandler ["keydown", "_this select 3"];
		{(_display displayCtrl _x) ctrlShow false} forEach [/*44151,*/44150,/*44146,44147,*/44148, 44149, 44346];
}] call BIS_fnc_addScriptedEventHandler;

//apply badco uniform
//check for restricted gear in case of saved loadout used
[missionNamespace, "arsenalClosed", {

	if ((str player) in d_badcompany) then {

		player remoteExecCall ["d_fnc_badco_uniform",-2];
	
	};
	
	item_check_isArsenal = true;
	item_check_arsenalChecked = false;
	
	{
	
		[player,objnull,_x] call d_fnc_ptakeweapon;
	
	} foreach ((weapons player) + (magazines player) + (items player) + [uniform player] + [backpack player] + [vest player] + (assigneditems player) + [goggles player] + [headgear player]);
	
	if (item_check_arsenalChecked) then {hint "Your loadout contains items that are restricted depending on your current role.\n\nYou can only use items that you see in the Arsenal."};
	
	item_check_isArsenal = false;
	item_check_arsenalChecked = false;

}] call BIS_fnc_addScriptedEventHandler;