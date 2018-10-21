// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_createsecondary.sqf"
#include "..\..\x_setup.sqf"

#define __getPos \
private _poss = [_posarx, _mtradius] call d_fnc_GetRanPointCircleBig;\
if (!(_poss isEqualTo []) && {isOnRoad _poss}) then {_poss = []};\
while {_poss isEqualTo []} do {\
	_poss = [_posarx, _mtradius] call d_fnc_GetRanPointCircleBig;\
	if (!(_poss isEqualTo []) && {isOnRoad _poss}) then {_poss = []};\
}

if !(call d_fnc_checkSHC) exitWith {};

params ["_wp_array", "_mtradius", "_trg_center"];

sleep 3.120;

private _mtmhandle = _wp_array spawn d_fnc_getmtmission;

waitUntil {sleep 0.321; scriptDone _mtmhandle};

sleep 3.0123;

private _posarx = _trg_center;
__getPos;
private _vec = createVehicle [d_illum_tower, _poss, [], 0, "NONE"];
_vec setPos _poss;
_vec setVectorUp [0,0,1];
[_vec] call d_fnc_CheckMTHardTarget;
d_mt_radio_down = false;
[missionNamespace, ["d_mt_radio_down", false]] remoteExecCall ["setVariable", 2];
["d_main_target_radiotower", _poss,"ICON","ColorBlack",[0.5,0.5],localize "STR_DOM_MISSIONSTRING_521",0,"mil_dot"] remoteExecCall ["d_fnc_CreateMarkerGlobal", 2];

[9] remoteExecCall ["d_fnc_DoKBMsg", 2];
sleep 1.0112;

private _newgroup = [d_side_enemy] call d_fnc_creategroup;
[_poss, ["specops", d_enemy_side_short] call d_fnc_getunitlistm, _newgroup] spawn d_fnc_makemgroup;
_newgroup deleteGroupWhenEmpty true;
sleep 1.0112;
_newgroup allowFleeing 0;
_newgroup setVariable ["d_defend", true];
[_newgroup, _poss] spawn d_fnc_taskDefend;

sleep 3.234;
if (d_with_dynsim == 0) then {
	_newgroup enableDynamicSimulation true;
};

d_mt_spotted = false;
d_create_new_paras = false;
d_f_check_triggers = [];
{
	d_f_check_triggers pushBack ([d_cur_tgt_pos, [d_cur_target_radius + 300, d_cur_target_radius + 300, 0, false], [_x, d_enemy_side + " D", false], ["this", "0 = 0 spawn {if (!d_create_new_paras) then {d_create_new_paras = true;0 execFSM 'fsms\fn_Parahandler.fsm'};d_mt_spotted = true;[12] remoteExecCall ['d_fnc_DoKBMsg', 2];sleep 5;{deleteVehicle _x;false} count d_f_check_triggers}", ""]] call d_fnc_createtriggerlocal);
	false
} count d_own_sides;

sleep 3.234;
private _d_currentcamps = [];
private _nrcamps = (ceil random 5) max 3;
private _ctype = d_wcamp;

d_sum_camps = _nrcamps;
if (!isServer) then {
	[missionNamespace, ["d_sum_camps", _nrcamps]] remoteExecCall ["setVariable", 2];
};

for "_i" from 1 to _nrcamps do {
	__getPos;
	private _wf = createVehicle [_ctype, _poss, [], 0, "NONE"];
	_wf setDir floor random 360;
	private _svec = sizeOf _ctype;
	__TRACE_1("","_svec")
	private _xcountx = 0;
	private _nnpos = getPosASL _wf;
	_nnpos set [2, 0];
	private _doexit = false;
	while {_xcountx < 99} do {
		if !(_d_currentcamps isEqualTo []) then {
			private _wfokc = 0;
			{
				if (_nnpos distance2D _x > 130) then {_wfokc = _wfokc + 1};
				false
			} count _d_currentcamps;
			__TRACE_2("","_wfokc","count _d_currentcamps")
			if (_wfokc != count _d_currentcamps) then {
				_nnpos = [_nnpos, _mtradius] call d_fnc_GetRanPointCircleBig;
			} else {
				if (_vec distance2D _nnpos > 130) then {
					_poss = _nnpos;
					_doexit = true;
				} else {
					_nnpos = [_nnpos, _mtradius] call d_fnc_GetRanPointCircleBig;
				};
			};
		};
		if (_doexit) exitWith {};
		_xcountx = _xcountx + 1;
	};
	__TRACE_1("","_poss")
	_poss set [2, 0];
	_wf setPos _poss;
	_d_currentcamps pushBack _wf;
	_wf setVariable ["d_SIDE", d_enemy_side, true];
	_wf setVariable ["d_INDEX", _i, true];
	_wf setVariable ["d_CAPTIME", 40 + (floor random 10), true];
	_wf setVariable ["d_CURCAPTIME", 0, true];
	_wf setVariable ["d_CURCAPTURER", d_own_side];
	_wf setVariable ["d_STALL", false, true];
	_wf setVariable ["d_TARGET_MID_POS", _trg_center];
	_fwfpos = getPosATL _wf;
	_fwfpos set [2, 4.3];
	private _flagPole = createVehicle [d_flag_pole, _fwfpos, [], 0, "NONE"];
	_flagPole setPos _fwfpos;
	_wf setVariable ["d_FLAG", _flagPole, true];
	_maname = format["d_camp%1",_i];
	[_maname, _poss,"ICON","ColorBlack",[0.5,0.5],"",0,d_strongpointmarker] remoteExecCall ["d_fnc_CreateMarkerGlobal", 2];
	_flagPole setFlagTexture (call d_fnc_getenemyflagtex);
	
	_wf addEventHandler ["HandleDamage", {0}];
	//[_wf, _flagPole] call d_fnc_HandleCamps2;
	[_wf, _flagPole] execFSM "fsms\fn_HandleCamps2.fsm";
	sleep 0.5;
	
	private _newgroup = [d_side_enemy] call d_fnc_creategroup;
	[_poss, ["specops", d_enemy_side_short] call d_fnc_getunitlistm, _newgroup] spawn d_fnc_makemgroup;
	_newgroup deleteGroupWhenEmpty true;
	sleep 1.0112;
	_newgroup allowFleeing 0;
	_newgroup setVariable ["d_defend", true];
	[_newgroup, _poss] spawn d_fnc_taskDefend;
	if (d_with_dynsim == 0) then {
		_newgroup spawn {
			sleep 5;
			_this enableDynamicSimulation true;
		};
	};
};

[missionNamespace, ["d_currentcamps", _d_currentcamps]] remoteExecCall ["setVariable", 2];
d_numcamps = count _d_currentcamps; publicVariable "d_numcamps";
d_campscaptured = 0; publicVariable "d_campscaptured";

[15, _nrcamps] remoteExecCall ["d_fnc_DoKBMsg", 2];

if (random 100 > 70) then {
	[_mtradius, _trg_center] call d_fnc_minefield;
};

sleep 5.213;
d_main_target_ready = true;
if (!isServer) then {
	[missionNamespace, ["d_main_target_ready", true]] remoteExecCall ["setVariable", 2];
};
