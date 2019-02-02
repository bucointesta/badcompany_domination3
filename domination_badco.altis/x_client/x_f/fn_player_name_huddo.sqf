// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_player_name_huddo.sqf"
#include "..\..\x_setup.sqf"

disableSerialization;

#define __d_textsize_dr3d  0.03333

if (d_show_pname_hud && {!visibleMap && {isNil "d_is_sat_on"}}) then {
	if (alive player && {!(player getVariable ["xr_pluncon", false]) && {!(player getVariable ["ace_isunconscious", false])}}) then {
		private _grpp = group player;
		private _cam2world = positionCameraToWorld [0,0,0];
		private ["_distu", "_vu", "_targetPos", "_dodraw", "_tex", "_rtex"];
		private _d_pn_hud = d_dist_pname_hud;
		private _s_p_namesx = d_show_player_namesx;
		private _pnhoc = d_pnhudothercolor;
		private _pnhgc = d_pnhudgroupcolor;
		private _fnc_gpn = d_fnc_getplayername;
		private _fnc_ghpn = d_fnc_gethpname;
		private _fnc_isp = d_fnc_isplayer;
		private _nfc_grp = d_fnc_getrankpic;
		{
			_distu = _cam2world distance _x;
			if (_distu <= _d_pn_hud) then {
				_vu = vehicle _x;
				_targetPos = _vu modelToWorldVisual (_x selectionPosition "Head");
				if !(_targetPos isEqualTo []) then {
					_dodraw = if (isNull objectParent _x) then {
						true
					} else {
						if (crew _vu isEqualTo 1) exitWith {true};
						if (_x == commander _vu) exitWith {true};
						if (_x == gunner _vu && {!((commander _vu) call _fnc_isp)}) exitWith {true};
						if (_x == driver _vu && {!((commander _vu) call _fnc_isp) && {!((gunner _vu) call _fnc_isp)}}) exitWith {true};
						false
					};
					if (_dodraw) then {
						_tex = "";
						_rtex = "";
						if (_distu <= 200) then {
							_tex = if (_s_p_namesx == 1) then {
								[_x] call _fnc_ghpn
							} else {
								if (_s_p_namesx == 2) then {
									str(9 - round(9 * damage _x))
								} else {
									""
								};
							};
							if (isNil "_tex") then {_tex = _x call _fnc_gpn};
							_rtex = _x call _nfc_grp;
						} else {
							_tex = "*";
							_rtex = "#(argb,8,8,3)color(0,0,0,0)";
						};
						drawIcon3D [_rtex, [_pnhoc, _pnhgc] select (group _x == _grpp), _targetPos vectorAdd [0, 0, 0.4 + (_distu / 15) / 1.5], 0.4, 0.4, 0, _tex, 1, __d_textsize_dr3d, "RobotoCondensed"]; //PuristaSemibold PuristaMedium
					};
				};
			};
		} forEach (d_allplayers select {alive _x && {_x != player && {!(_x getVariable ["xr_pluncon", false]) && {isNil {_x getVariable "xr_plno3dd"} && {!(_x getVariable ["ace_isunconscious", false])}}}}});
	};
} else {
	if (!d_show_pname_hud) then {
		removeMissionEventHandler ["Draw3D", d_phudraw3d];
		d_phudraw3d = -1;
	};
};