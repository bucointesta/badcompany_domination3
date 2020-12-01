/*private _mine = createMine ["APERSBoundingMine", position player,["apers1"], 1];*/

//{systemChat str _x} forEach diag_activeSQFScripts;

/*
{diag_log format ["cassa 1: %1", _x]; sleep 2} forEach [(getWeaponCargo d_ammobox_1) select 0, (getMagazineCargo d_ammobox_1) select 0, (getBackpackCargo d_ammobox_1) select 0, (getItemCargo d_ammobox_1) select 0];
{diag_log format ["cassa 2: %1", _x]; sleep 2} forEach [(getWeaponCargo d_ammobox_2) select 0, (getMagazineCargo d_ammobox_2) select 0, (getBackpackCargo d_ammobox_2) select 0, (getItemCargo d_ammobox_2) select 0];
{diag_log format ["cassa 3: %1", _x]; sleep 2} forEach [(getWeaponCargo d_ammobox_3) select 0, (getMagazineCargo d_ammobox_3) select 0, (getBackpackCargo d_ammobox_3) select 0, (getItemCargo d_ammobox_3) select 0];
{diag_log format ["cassa 4: %1", _x]; sleep 2} forEach [(getWeaponCargo d_ammobox_4) select 0, (getMagazineCargo d_ammobox_4) select 0, (getBackpackCargo d_ammobox_4) select 0, (getItemCargo d_ammobox_4) select 0];
{diag_log format ["cassa 5: %1", _x]; sleep 2} forEach [(getWeaponCargo d_ammobox_5) select 0, (getMagazineCargo d_ammobox_5) select 0, (getBackpackCargo d_ammobox_5) select 0, (getItemCargo d_ammobox_5) select 0];
{diag_log format ["cassa 6: %1", _x]; sleep 2} forEach ((getItemCargo d_ammobox_4) select 0);
{diag_log format ["cassa 7: %1", _x]; sleep 2} forEach [(getWeaponCargo d_ammobox_7) select 0, (getMagazineCargo d_ammobox_7) select 0, (getBackpackCargo d_ammobox_7) select 0, (getItemCargo d_ammobox_7) select 0];
{diag_log format ["cassa 8: %1", _x]; sleep 2} forEach [(getWeaponCargo d_ammobox_8) select 0, (getMagazineCargo d_ammobox_8) select 0, (getBackpackCargo d_ammobox_8) select 0, (getItemCargo d_ammobox_8) select 0];
{diag_log format ["cassa 9: %1", _x]; sleep 2} forEach [(getWeaponCargo d_ammobox_9) select 0, (getMagazineCargo d_ammobox_9) select 0, (getBackpackCargo d_ammobox_9) select 0, (getItemCargo d_ammobox_9) select 0];
{diag_log format ["cassa 10: %1", _x]; sleep 2} forEach [(getWeaponCargo d_ammobox_10) select 0, (getMagazineCargo d_ammobox_10) select 0, (getBackpackCargo d_ammobox_10) select 0, (getItemCargo d_ammobox_10) select 0];
{diag_log format ["cassa 11: %1", _x]; sleep 2} forEach [(getWeaponCargo d_ammobox_11) select 0, (getMagazineCargo d_ammobox_11) select 0, (getBackpackCargo d_ammobox_11) select 0, (getItemCargo d_ammobox_11) select 0];
*/

//player addEventHandler ["InventoryClosed", {(_this select 1) remoteExecCall ["d_fnc_replenishbox", 2]; player removeEventHandler ["InventoryClosed", 0]}];

/*
{diag_log format ["BADCO %1", _x];} ForEach d_badco_items;
{diag_log format ["PUBLIC %1", _x];} ForEach d_public_items;
{diag_log format ["RIFLE %1", _x];} ForEach d_combat_rifles;
{diag_log format ["SNIPER %1", _x];} ForEach d_sniping_rifles;
{diag_log format ["MACHINEGUN %1", _x];} ForEach d_machineguns;
{diag_log format ["LAUNCHER %1", _x];} ForEach d_launchers;
{diag_log format ["EXPLOSIVE %1", _x];} ForEach d_explosives;
{diag_log format ["LAUNCHER %1", _x];} ForEach d_grenadelaunchers;
{diag_log format ["MEDIC %1", _x];} ForEach d_medic_only;
{diag_log format ["ENGINEER %1", _x];} ForEach d_engineer_only;
{diag_log format ["PILOT %1", _x];} ForEach d_pilot_uniform;
*/

[] spawn {
	while {true} do {
		uisleep 10;
		diag_log format ["### Hz_diag: %1, %2, %3, %4, %5, %6",diag_fps,viewDistance, count diag_activeSQFScripts, {local _x} count allunits, {local _x} count vehicles, {local agent _x} count agents];
	};
};