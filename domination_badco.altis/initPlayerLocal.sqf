// by Xeno
//#define __DEBUG__
#define THIS_FILE "initPlayerLocal.sqf"
#include "x_setup.sqf"
diag_log [diag_frameno, diag_ticktime, time, "Executing MPF initPlayerLocal.sqf"];
__TRACE_1("","_this")

//if it is a player (no server, no HC) start ARMA Dynamic Groups system
if (hasInterface) then {
	["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;
};

//tasks.sqf is everything related to display the task on client interface
execVM "tasks.sqf";

call d_fnc_save_layoutgear;

[player] remoteExecCall ["d_fnc_initplserver",2];

if (str player in d_medics) then {player setUnitTrait ["Medic", true]};
if (str player in d_is_engineer) then {player setUnitTrait ["engineer", true]; player setUnitTrait ["explosiveSpecialist", true]};
if (str player in d_saboteurs) then {player setUnitTrait ["explosiveSpecialist", true]; player setUnitTrait ["audibleCoef ", 0.2]; player setUnitTrait ["camouflageCoef", 0.5]};
if (str player in d_spotters) then {player setUnitTrait ["audibleCoef ", 0.4]; player setUnitTrait ["camouflageCoef", 0.3]};
if (str player in d_snipers) then {player setUnitTrait ["audibleCoef ", 0.6]; player setUnitTrait ["camouflageCoef", 0.5]};
if (str player in d_badcompany) then {player remoteExecCall ["d_fnc_badco_uniform",-2];player setUnitTrait ["UAVHacker", true]; player setUnitTrait ["audibleCoef ", 0.8]; player setUnitTrait ["camouflageCoef", 0.5]};
player setUnitTrait ["loadCoef", 1];

diag_log [diag_frameno, diag_ticktime, time, "MPF initPlayerLocal.sqf processed"];