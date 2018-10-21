// by Xeno
#define THIS_FILE "fn_createjumpflag.sqf"
#include "..\..\x_setup.sqf"

if (!isServer) exitWith {};

// create random position
private _posi = [d_old_target_pos, d_old_radius] call d_fnc_getranpointcircle;
while {_posi isEqualTo []} do {
	_posi = [d_old_target_pos, d_old_radius] call d_fnc_getranpointcircle;
	sleep 0.04;
};

if !(_posi isEqualTo []) then {
	private _flag = createVehicle [d_flag_pole, _posi, [], 0, "NONE"];
	_flag setFlagTexture
	d_flag_str_blufor;

	[format ["d_paraflag%1", count d_resolved_targets], _flag, "ICON", "ColorYellow", [0.5, 0.5], ["Vehicle", "Parajump"] select (d_jumpflag_vec == ""), 0, "mil_flag"] call d_fnc_CreateMarkerGlobal;
	
	if (d_WithJumpFlags == 1) then {
		_flag remoteExecCall ["d_fnc_newflagclient", [0, -2] select isDedicated];
	};
	private _nt = ["NewJumpVehFlag", "NewJumpFlag"] select (d_jumpflag_vec == "");
	d_kb_logic1 kbTell [d_kb_logic2, d_kb_topic_side, _nt, d_kbtel_chan];
	
	_flag setVariable ["d_is_jf", true, true];
};