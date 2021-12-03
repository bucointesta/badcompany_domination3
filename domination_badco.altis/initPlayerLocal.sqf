// by Xeno
//#define __DEBUG__
#define THIS_FILE "initPlayerLocal.sqf"
#include "x_setup.sqf"
diag_log [diag_frameno, diag_ticktime, time, "Executing MPF initPlayerLocal.sqf"];
__TRACE_1("","_this")

if (hasInterface) then {
	if (str player == "d_zeus") then {
		[] spawn {
			waitUntil {!isNull findDisplay 312};
			disableUserInput true;
			waitUntil {sleep 0.1; !isNil "zeusDisableUserInput"};
			sleep 1;
			disableUserInput false;
		};
	};
	0 spawn {
		sleep (1 + random 1);
		private _np = player getVariable ["d_plname", ""];
		if (_np == "" || {_np == "Error: No unit"}) then {
			_np = profileName splitString """'" joinString "";
			if (_np isEqualTo "Error: No unit") then {
				_np = (name player) splitString """'" joinString "";
			};
			player setVariable ["d_plname", _np, true];
		};
		__TRACE_1("","_np")
		d_name_pl = _np;
	};
};

player enableAttack false;

execVM "tasks.sqf";

if (str player in d_medics) then {
	player setUnitTrait ["Medic", true];
	player setVariable ["d_playerRole"," (Medic)", true];
};
if (str player in d_is_engineer) then {
	player setUnitTrait ["engineer", true];
	player setUnitTrait ["explosiveSpecialist", true];
	player setVariable ["d_playerRole"," (Engineer)", true];
};
if (str player in d_saboteurs) then {
	player setUnitTrait ["explosiveSpecialist", true];
	//player setUnitTrait ["audibleCoef", 0.2];
	//player setUnitTrait ["camouflageCoef", 0.5];
	player setVariable ["d_playerRole"," (Saboteur)", true];
};
if (str player in d_spotters) then {
	//player setUnitTrait ["audibleCoef", 0.4];
	//player setUnitTrait ["camouflageCoef", 0.3];
	player setVariable ["d_playerRole"," (Spotter)", true];
};
if (str player in d_snipers) then {
	//player setUnitTrait ["audibleCoef", 0.6];
	//player setUnitTrait ["camouflageCoef", 0.5];
	player setVariable ["d_playerRole"," (Marksman)", true]
};
/*if (str player in d_badcompany) then {player setUnitTrait ["UAVHacker", true]; player setUnitTrait ["audibleCoef", 0.8]; player setUnitTrait ["camouflageCoef", 0.5]};*/
player setUnitTrait ["loadCoef", 1];
player setUnitTrait ["audibleCoef ", 2];
player setUnitTrait ["camouflageCoef", 1.5];

if (str player in d_attack_pilots) then {player setVariable ["d_playerRole"," (Pilot)", true];};
if (str player in d_transport_pilots) then {player setVariable ["d_playerRole"," (Pilot)", true];};
if (str player in d_riflemen) then {player setVariable ["d_playerRole"," (Rifleman)", true];};
if (str player in d_grenadiers) then {player setVariable ["d_playerRole"," (Grenadier)", true];};
if (str player in d_autoriflemen) then {player setVariable ["d_playerRole"," (Machine gunner)", true];};
if (str player in d_missilesp) then {player setVariable ["d_playerRole"," (AT/AA Specialist)", true];};
if (str player in d_crewmen) then {player setVariable ["d_playerRole"," (Crewman)", true];};
if (str player == "d_medpilot") then {player setVariable ["d_playerRole"," (MedEvac Pilot)", true];};
if (str player == "d_admin") then {player setVariable ["d_playerRole"," (Admin)", true];};
if (str player == "d_zeus") then {player setVariable ["d_playerRole"," (Zeus)", true];};

diag_log [diag_frameno, diag_ticktime, time, "MPF initPlayerLocal.sqf processed"];