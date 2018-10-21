// by Xeno
#define THIS_FILE "fn_bike.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

(param [3]) params ["_create_bike", "_b_mode"];

private _exitit = false;
if (d_with_ranked) then {
	private _dosearch = true;
	if (count d_create_bike > 1) then {
		private _index = d_create_bike find _create_bike;
		if (_index != -1) then {
			_dosearch = false;
			private _parray = [d_points_needed select 1, d_points_needed select 2, d_points_needed select 3, d_points_needed select 4, d_points_needed select 5, d_points_needed select 5];
			if (_index < count _parray && {score player < (_parray select _index)}) then {
				private _rank = switch (_parray select _index) do {
					case (d_points_needed select 1): {"Sergeant"};
					case (d_points_needed select 2): {"Lieutenant"};
					case (d_points_needed select 3): {"Captain"};
					case (d_points_needed select 4): {"Major"};
					case (d_points_needed select 5): {"Colonel"};
				};
				systemChat format [localize "STR_DOM_MISSIONSTRING_156", _rank, _create_bike];
				_exitit = true;
			};
		};
	};
	if (_dosearch && {score player < d_ranked_a select 6}) then {
		_exitit = true;
		systemChat format[localize "STR_DOM_MISSIONSTRING_156", (d_ranked_a select 6) call d_fnc_GetRankFromScore, _create_bike];
	};
};
if (_exitit) exitWith {};

private _disp_name = [_create_bike, "CfgVehicles"] call d_fnc_GetDisplayName;

if (!isNull objectParent player) exitWith {
	systemChat format [localize "STR_DOM_MISSIONSTRING_158", _disp_name];
};

if (time > d_vec_end_time && {!isNull d_flag_vec}) then {
	d_flag_vec spawn {
		private _vec = _this;
		while {{alive _x} count (crew _vec) != 0} do {
			sleep 1;
		};
		deleteVehicle _vec;
	};
	d_flag_vec = objNull;
	d_vec_end_time = -1;
};
if (_b_mode == 0 && {alive d_flag_vec}) exitWith {
	systemChat format [localize "STR_DOM_MISSIONSTRING_160", 0 max round((d_vec_end_time - time) / 60)];
};

if (d_with_ranked) then {
	[player, (d_ranked_a select 5) * -1] remoteExecCall ["addScore", 2];
};

systemChat format [localize "STR_DOM_MISSIONSTRING_161", _disp_name];
sleep 3.123;
player setVariable ["d_bike_b_mode", _b_mode];
private _vet = if (_b_mode == 1) then {-1} else {
	d_vec_end_time = time + 30;
	d_vec_end_time
};
[player, _create_bike, _b_mode, _vet] remoteExecCall ["d_fnc_createPlayerBike", 2];
