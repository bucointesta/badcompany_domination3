// by Xeno
#define THIS_FILE "fn_dodelrspgrps.sqf"
#include "..\..\x_setup.sqf"

if !(d_respawn_ai_groups isEqualTo []) then {
	0 spawn {
		scriptName "spawn_respawn_ai_groups";
		__TRACE_1("","d_respawn_ai_groups")
		
		// Hunter: prevent immediate spontaneous vehicle combustion at AO when clear... wait for players to clear area first
		_objToKill = [];
		_pos = +d_old_target_pos;
		
		{
			_x params ["_rgrp"];
			__TRACE_1("","_rgrp")
			if (!isNil "_rgrp" && {_rgrp isEqualType grpNull && {!isNull _rgrp}}) then {
				{
					if !(isNull objectParent _x)  then {
						private _v = vehicle _x;
						__TRACE_1("","_v")
						//if (alive _v) then {_v setDamage 1};
						_objToKill pushBack _v;
					};
					//if (alive _x) then {_x setDamage 1};
					_objToKill pushBack _x;
				} forEach ((units _rgrp) select {!isNil "_x" && {!isNull _x}});
			};
		} forEach (d_respawn_ai_groups select {_x isEqualType []});
		
		sleep 240;
		waitUntil {
			sleep 60;
			({(_x distance _pos) < 2000} count playableUnits) == 0
		};
		{
			if (alive _x) then {
				_x setDamage 1;
			};
		} foreach _objToKill;
	};
};