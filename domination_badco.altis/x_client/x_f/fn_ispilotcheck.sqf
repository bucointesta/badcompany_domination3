// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_ispilotcheck.sqf"
#include "..\..\x_setup.sqf"

private _enterer = param [0];
private _vec = param [1];
private _vecnum =  param [2];

if (_enterer == "d_admin") exitWith {true};

if ((_vecnum >= 900) && {_vecnum < 1000} && {!(_enterer in d_crewmen)}) exitWith {
	hint "You need to be a crewman to use this vehicle.";
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
		if (_vec isKindOf "Air") then {
			hint "You are not authorized to fly this aircraft!";
			false		
		} else {
			true
		}
	}
};
if (_vecnum == 3012) exitWith {
	hint "Only MedEvac pilots can fly this chopper!";		
	false	
};

if (_vecnum == 3011) exitWith {hint "This is an admin reserved chopper";false};
if (((_vecnum == 3009) || {_vecnum == 3010}) && {!(_enterer in ["d_badco_2","d_badco_8"])}) exitWith {hint "Only Bad Company pilots can fly this chopper";false};
if ((_vecnum == 3009) || {_vecnum == 3010}) exitWith {true};
if (((_vecnum == 806) || {(_vecnum == 807) || {_vecnum == 808}}) && {!(_enterer in d_uid_reserved_slots)}) exitWith {hint "Only Bad Company members can drive this car";false};
//if (((_vecnum == 3008) || {_vecnum == 3101} || {_vecnum == 3102} || {_vecnum == 3005}) && {!(_enterer in d_attack_pilots)}) exitWith {hint "You need to be an attack pilot to fly this vehicle";false};
//if ((_vec isKindOf "Air") && {!((_enterer in d_attack_pilots) || {_enterer in _transPilots})}) exitWith {hint "You need to be a pilot to fly this vehicle";false};
if ((_vec isKindOf "Air") && {!(_enterer in _pilots)}) exitWith {hint "You need to be a pilot to fly this aircraft";false};

#ifndef __RHS__
	// Jet nerf
	if ((_vec iskindof "Plane_CAS_01_base_F") || {_vec iskindof "Plane_Fighter_01_Base_F"}) then {
		// seems there is no EH for this...
		_vec spawn {
			while {(alive player) && {(vehicle player) == _this}} do {
				uiSleep 0.1;
				if (cameraView == "GUNNER") then {
					hint "The targeting pod on jets is disabled on this server. Ask a ground team member to lase targets!";
					_this switchCamera "INTERNAL";
				};
			};
		};
	};
#endif

true
