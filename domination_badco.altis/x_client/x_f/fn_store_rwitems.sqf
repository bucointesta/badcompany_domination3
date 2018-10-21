// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_store_rwitems.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

private _headgear = headgear player;
if (_headgear != player getVariable "d_pheadgear") then {
	player setVariable ["d_pheadgear", _headgear];
};
private _goggles = goggles player;
if (_goggles != player getVariable "d_pgoggles") then {
	player setVariable ["d_pgoggles", _goggles];
};
private _uniform = uniform player;
if (_uniform != player getVariable "d_puniform") then {
	player setVariable ["d_puniform", _uniform];
};
private _vest = vest player;
if (_vest != player getVariable "d_pvest") then {
	player setVariable ["d_pvest", _vest];
};
private _backpack = backpack player;
if (_backpack != player getVariable "d_pbackpack") then {
	player setVariable ["d_pbackpack", _backpack];
};
private _uniformitems = uniformItems player;
if !(_uniformitems isEqualTo (player getVariable "d_puniformitems")) then {
	player setVariable ["d_puniformitems", _uniformitems];
};
private _vestitems = vestItems player;
if !(_vestitems isEqualTo (player getVariable "d_pvestitems")) then {
	player setVariable ["d_pvestitems", _vestitems];
};
private _backpackitems = backpackItems player;
if !(_backpackitems isEqualTo (player getVariable "d_pbackpackitems")) then {
	player setVariable ["d_pbackpackitems", _backpackitems];
};
private _primary = primaryWeapon player;
if (_primary != player getVariable "d_pprimweap") then {
	player setVariable ["d_pprimweap", _primary];
};
private _secondary = secondaryWeapon player;
if (_secondary != player getVariable "d_psecweap") then {
	player setVariable ["d_psecweap", _secondary];
};
private _handgun = handgunWeapon player;
if (_handgun != player getVariable "d_phandgweap") then {
	player setVariable ["d_phandgweap", _handgun];
};
private _primaryitems = primaryWeaponItems player;
if !(_primaryitems isEqualTo (player getVariable "d_pprimweapitems")) then {
	player setVariable ["d_pprimweapitems", _primaryitems];
};
private _secondaryitems = secondaryWeaponItems player;
if !(_secondaryitems isEqualTo (player getVariable "d_psecweapitems")) then {
	player setVariable ["d_psecweapitems", _secondaryitems];
};
private _handgunitems = handgunItems player;
if !(_handgunitems isEqualTo (player getVariable "d_phandgweapitems")) then {
	player setVariable ["d_phandgweapitems", _handgunitems];
};
private _weapons = weapons player;
if !(_weapons isEqualTo (player getVariable "d_pweapons")) then {
	player setVariable ["d_pweapons", _weapons];
};

__TRACE_3("","_primaryitems","_secondaryitems","_handgunitems")

