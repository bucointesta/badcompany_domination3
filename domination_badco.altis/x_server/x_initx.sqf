// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_initx.sqf"
#include "..\x_setup.sqf"
if (!isServer) exitWith{};

call compile preprocessFileLineNumbers "x_shc\x_shcinit.sqf";

0 spawn {
	scriptName "spawn_x_initx_createbase";
	waitUntil {time > 0};
	sleep 2;

	private _mmm = markerPos "d_base_sb_ammoload";
	__TRACE_1("","_mmm")
	
	if !(_mmm isEqualTo [0,0,0]) then {
		private _stype = [d_servicepoint_building] call BIS_fnc_simpleObjectData;
		_mmm set [2, 3.3];
		private _fac = createSimpleObject [_stype select 1, _mmm];
		_fac setDir (markerDir "d_base_sb_ammoload");
		_fac setPos _mmm;
	};

	if (d_base_aa_vec == "") exitWith {};
	
	if (isNil "d_HC_CLIENT_OBJ_OWNER") then {
		[d_own_side, d_base_aa_vec] call d_fnc_cgraa;
	} else {
		[d_own_side, d_base_aa_vec] remoteExecCall ["d_fnc_cgraa", d_HC_CLIENT_OBJ_OWNER];
	};
};
