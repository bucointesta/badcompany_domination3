// by Bucointesta
//#define __DEBUG__
#define THIS_FILE "fn_checkitem.sqf"
#include "..\..\x_setup.sqf"


private _unit = str (_this select 0);
private _item = _this select 1;

/*allow admin to any*/
if (_unit == "d_admin") exitWith {true};

if (!(_item in restrictions_allAllowedItems)) exitWith {

	hint "You cannot use this item with your chosen role.";
	
	false

};

/*

//prevent artillery operator to use weapons
if ((_unit == "d_artop_1") && {!(_item in d_defaultItems)}) exitWith {hint "Artillery operators can't use this item !"; false};

//admin_only objects
if (_item in ["hgun_Pistol_heavy_02_F", "U_C_HunterBody_grn", "H_Hat_Safari_sand_F", "V_Rangemaster_belt"]) exitWith {hint "Only admin can use this item !"; false};

//badcompany only objects
if ((_item in d_badco_items) && {!(_unit in d_badcompany)}) exitWith {hint "Only Bad Company members can use this item !"; false};

//pilots restriction allowed; pistols, submachineguns, flashlight, smokes, nightvisors, binocular, gps, parachute, first aid kit
if (((_unit in d_attack_pilots) || {_unit in d_transport_pilots}) && {!((_item in d_defaultItems) || {_item in d_pilot_uniforms})}) exitWith {hint "Pilots can't use this item !"; false};
if ((_item in d_pilot_only)  && {!((_unit in d_attack_pilots) || {_unit in d_transport_pilots})}) exitWith {hint "You can't wear pilot uniforms!"; false};

//medic items
if ((_item in d_medic_only) && {!(_unit in d_medics)}) exitWith {hint "Only medics can use this item !"; false};

//engineer items
if ((_item in d_engineer_only) && {_unit in d_is_engineer}) exitWith {hint "Only engineers can use this item !"; false};

//saboteur items
if ((_item in d_saboteur_only) && {!(_unit in d_saboteurs)}) exitWith {hint "Only saboteurs can use this item !"; false};

//snipers items
if (((_item in d_sniper_only) || {_item in d_sniper_optics}) && {!((_unit in d_snipers) || {_unit in d_spotters})}) exitWith {hint "Only marksmen or forward observers can use this item !"; false};
//sniper rifles
if ((_item in d_sniping_rifles) && {!(_unit in d_snipers)}) exitWith {hint "Only marksmen can use this item !"; false};

//grenadelaunchers
if ((_item in d_grenadelaunchers) && {!((_unit in d_grenadiers) || {_unit in d_leaders})}) exitWith {hint "Only grenadiers can use this item !"; false};

//machineguns
if ((_item in d_machineguns) && {!(_unit in d_autoriflemen)}) exitWith {hint "Only autoriflemen can use this item !"; false};

//nlaw restriction
if ((_item == "launch_NLAW_F") && {(_unit in d_medics) || {(_unit in d_snipers) || {_unit in d_spotters}}}) exitWith {hint "Medics, marksmen and forward observers can't use this item !"; false};
if (_item == "launch_NLAW_F") exitWith {true};

//launchers
if ((_item in d_launchers) && {!(_unit in d_missilesp)}) exitWith {hint "Only missile specialists can use this item !"; false};

//satchels
if ((_item == "SatchelCharge_Remote_Mag") && {!((_unit in d_is_engineer) || {(_unit in d_saboteurs) || {_unit in d_leaders}})}) exitWith {hint "Only teamleaders, engineers or saboteurs can use satchel charges !"; false};
if (_item == "SatchelCharge_Remote_Mag") exitWith {true};

//explosives
if ((_item in d_explosives) && {!((_unit in d_is_engineer) || {_unit in d_saboteurs})}) exitWith {hint "Only engineers and saboteurs can use explosives !"; false};

//large backpack
if ((_item in d_large_backpacks) && {!((_unit in d_missilesp) || {(_unit in d_grenadiers) || {_unit in d_is_engineer}})}) exitWith {hint "Only missile specialists, grenadiers or engineers can use large backpacks !"; false};

//medium backpack
if ((_item in d_medium_backpacks) && {!((_unit in d_missilesp) || {(_unit in d_grenadiers) || {(_unit in d_is_engineer) || {(_unit in d_riflemen) || {(_unit in d_autoriflemen) || {(_unit in d_medic) || {_unit in d_saboteurs}}}}}})}) exitWith {hint "Marksmen and forward observers can only use small backpacks !"; false};

//high-resistace armors
if ((_item in d_heavy_armors) && {!((_unit in d_missilesp) || {(_unit in d_grenadiers) || {_unit in d_is_engineer}})}) exitWith {hint "Only missile specialists, grenadiers or engineers can use this item !"; false};

//medium-resistance armors
if ((_item in d_medium_armors) && {(_unit in d_snipers) || {_unit in d_spotters}}) exitWith {hint "Marksmen and forward observers can't use this item !"; false};

//high-tech optics
if ((_item in d_hitech_optics) && {!((_unit in d_leaders) || {(_unit in d_is_engineer) || {_unit in d_saboteurs}})}) exitWith {hint "Only team leaders, engineers and saboteurs can use this item !"; false};

//better optics
if ((_item in d_better_optics) && {(_unit in d_riflemen) || {_unit in d_medics}}) exitWith {hint "Riflemen and medics can't use this item !"; false};

//rangefinder
if ((_item == "Rangefinder") && {(_unit in d_riflemen) || {_unit in d_medics}}) exitWith {hint "Simple riflemen and medics can't use rangefinder !"; false};

//laser designator
if ((_item == "Laserdesignator") && {!((_unit in d_spotters) || {_unit in d_leaders})}) exitWith {hint "Only team leaders and forward observers can use laser designator !"; false};

*/

true