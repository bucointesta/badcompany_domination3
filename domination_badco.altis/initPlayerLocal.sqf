// by Xeno
//#define __DEBUG__
#define THIS_FILE "initPlayerLocal.sqf"
#include "x_setup.sqf"
diag_log [diag_frameno, diag_ticktime, time, "Executing MPF initPlayerLocal.sqf"];
__TRACE_1("","_this")

if (hasInterface) then {
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
/*
if (str player in d_medics) then {player setUnitTrait ["Medic", true]};
if (str player in d_is_engineer) then {player setUnitTrait ["engineer", true]; player setUnitTrait ["explosiveSpecialist", true]};
if (str player in d_saboteurs) then {player setUnitTrait ["explosiveSpecialist", true]; player setUnitTrait ["audibleCoef ", 0.2]; player setUnitTrait ["camouflageCoef", 0.5]};
if (str player in d_spotters) then {player setUnitTrait ["audibleCoef ", 0.4]; player setUnitTrait ["camouflageCoef", 0.3]};
if (str player in d_snipers) then {player setUnitTrait ["audibleCoef ", 0.6]; player setUnitTrait ["camouflageCoef", 0.5]};
if (str player in d_badcompany) then {player remoteExecCall ["d_fnc_badco_uniform",-2];player setUnitTrait ["UAVHacker", true]; player setUnitTrait ["audibleCoef ", 0.8]; player setUnitTrait ["camouflageCoef", 0.5]};
player setUnitTrait ["loadCoef", 1];
*/
diag_log [diag_frameno, diag_ticktime, time, "MPF initPlayerLocal.sqf processed"];