// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_ispilotcheck.sqf"
#include "..\..\x_setup.sqf"

private _enterer = param [0];
private _vec = param [1];
private _vecnum =  param [2];

if ((_vecnum == 3011) && {!(_enterer == "d_admin")}) exitWith {hintSilent "This is an admin reserved chopper";false};
if (((_vecnum == 3009) || {_vecnum == 3010}) && {!((_enterer == "d_admin") || {(_enterer == "d_badco_1") || {_enterer == "d_badco_2"}})}) exitWith {hintSilent "Only Bad Company members can fly this chopper";false};
if ((_vecnum == 3009) || {_vecnum == 3010}) exitWith {true};
if (((_vecnum == 806) || {(_vecnum == 807) || {_vecnum == 808}}) && {!((_enterer == "d_admin") || {_enterer in d_uid_reserved_slots})}) exitWith {hintSilent "Only Bad Company members can drive this car";false};
if (((_vecnum == 3008) || {_vecnum == 3101} || {_vecnum == 3102} || {_vecnum == 3005}) && {!(_enterer in d_attack_pilots)}) exitWith {hintSilent "You need to be an attack pilot to fly this vehicle";false};
if ((_vec isKindOf "Air") && {!((_enterer in d_attack_pilots) || {_enterer in d_transport_pilots})}) exitWith {hintSilent "You need to be a pilot to fly this vehicle";false};

true