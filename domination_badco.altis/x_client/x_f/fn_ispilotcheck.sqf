// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_ispilotcheck.sqf"
#include "..\..\x_setup.sqf"

private _enterer = param [0];
private _vec = param [1];
private _vecnum =  param [2];

if (_enterer == "d_admin") exitWith {true};

if ((_vecnum >= 900) && {_vecnum < 1000} && {!(_enterer in d_crewmen)}) exitWith {
	hintSilent "You need to be a crewman to use this vehicle.";
	false
};

//so medevac pilots can't fly other choppers
//_transPilots = d_transport_pilots - ["d_medpilot"];

//have common pilot slot instead...
_pilots = d_transport_pilots + d_attack_pilots - ["d_medpilot"];

if (_enterer == "d_medpilot") exitWith {
	if (_vecnum == 3012) then {
		true
	} else {
		hintSilent "You are not authorized to fly this aircraft!";
		false
	}
};
if (_vecnum == 3012) exitWith {
	hintSilent "Only MedEvac pilots can fly this chopper!";		
	false	
};

if (_vecnum == 3011) exitWith {hintSilent "This is an admin reserved chopper";false};
if (((_vecnum == 3009) || {_vecnum == 3010}) && {_enterer != "d_badco_2"}) exitWith {hintSilent "Only Bad Company pilots can fly this chopper";false};
if ((_vecnum == 3009) || {_vecnum == 3010}) exitWith {true};
if (((_vecnum == 806) || {(_vecnum == 807) || {_vecnum == 808}}) && {!(_enterer in d_uid_reserved_slots)}) exitWith {hintSilent "Only Bad Company members can drive this car";false};
//if (((_vecnum == 3008) || {_vecnum == 3101} || {_vecnum == 3102} || {_vecnum == 3005}) && {!(_enterer in d_attack_pilots)}) exitWith {hintSilent "You need to be an attack pilot to fly this vehicle";false};
//if ((_vec isKindOf "Air") && {!((_enterer in d_attack_pilots) || {_enterer in _transPilots})}) exitWith {hintSilent "You need to be a pilot to fly this vehicle";false};
if ((_vec isKindOf "Air") && {!(_enterer in _pilots)}) exitWith {hintSilent "You need to be a pilot to fly this aircraft";false};

true
