// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_spect_oneframe.sqf"
#include "..\..\x_macros.sqf"

#define __dspctrl(ctrlid) ((uiNamespace getVariable "xr_SpectDlg") displayCtrl ctrlid)
#define __spectdlg1006e ((uiNamespace getVariable "xr_SpectDlg") displayCtrl 1006)

//__TRACE("start one frame")
xr_mouseDeltaPos set [0, xr_mouseLastX - (getMousePosition select 0)];
xr_mouseDeltaPos set [1, xr_mouseLastY - (getMousePosition select 1)];
xr_mouseLastX = getMousePosition select 0;
xr_mouseLastY = getMousePosition select 1;
if (xr_MouseScroll != 0) then {
	xr_sdistance = xr_sdistance - (xr_MouseScroll * 0.11);
	xr_MouseScroll = xr_MouseScroll * 0.75;
	if (xr_sdistance > xr_maxDistance) then {
		xr_sdistance = xr_maxDistance;
	} else {
		if (xr_sdistance < -xr_maxDistance) then {
			xr_sdistance = -xr_maxDistance;
		};
	};
	if (xr_sdistance < -0.6) then {xr_sdistance = -0.6};
};

if (xr_MouseButtons select 0) then {
	if (isNull xr_spectcamtarget) exitWith {xr_cur_world_obj = objNull};
	private _cursObj = objNull;
	private _intsecs = [getMousePosition select 0, getMousePosition select 1, xr_spectcamtarget, vehicle xr_spectcamtarget] call BIS_fnc_getIntersectionsUnderCursor;
	
	if !(_intsecs isEqualTo []) then {
		_cursObj = (_intsecs select 0) select 3;
	};
	if (!isNull _cursObj && {!(_cursObj isKindOf "CAManBase")}) then {
		if !(crew _cursObj isEqualTo []) then {
			{
				if (isPlayer _x) exitWith {
					_cursObj = _x;
				};
				false
			} count crew _cursObj;
		} else {
			_cursObj = objNull;
		};
	};
	if (!isNull _cursObj && {side (group _cursObj) != xr_side_pl}) then {
		_cursObj = objNull;
	};
	xr_cur_world_obj = _cursObj;
};

private _helperls = [];
if (time > xr_spect_timer) then {
	__TRACE_1("","xr_spect_timer")
	if (!xr_pl_no_lifes) then {
		if (xr_x_withresp) then {
			private _pic = getText (configFile >>"CfgVehicles">>typeOf player>>"icon");
			if (_pic != "") then {
				_pic = getText (configFile >>"CfgVehicleIcons">>_pic);
			};
			_helperls pushBack [-100, xr_name_player, xr_strpl, [_pic, "#(argb,8,8,3)color(1,1,1,0)"] select (_pic == ""), d_pnhudgroupcolor];
		};
		
		private _vecp = vehicle player;
		private _grppl = group player;
		{
			private _u = missionNamespace getVariable _x;
			//if (!isNil "_u" && {alive _u} && {side (group _u) == xr_side_pl} && {_u != player} && {!(_u getVariable ["xr_pluncon", false])}) then {
			if (!isNil "_u" && {!isNull _u && {_u != player}}) then {
				private _dist = (vehicle _u) distance2D _vecp;
				private _pic = getText (configFile >>"CfgVehicles">>typeOf _u>>"icon");
				if (_pic != "") then {
					_pic = getText (configFile >>"CfgVehicleIcons">>_pic);
				};
				_helperls pushBack [_dist, format [name _u + " (%1 m) %2", round _dist, ["", " (Uncon)"] select (_u getVariable ["xr_pluncon", false])], str _u, [_pic, "#(argb,8,8,3)color(1,1,1,0)"] select (_pic == ""), [d_pnhudothercolor, d_pnhudgroupcolor] select (group _u == _grppl)];
			};
			false
		} count d_player_entities;
	} else {
		private _sfm = markerPos "xr_playerparkmarker";
		{
			private _u = missionNamespace getVariable _x;
			//if (!isNil "_u" && {alive _u} && {side (group _u) == xr_side_pl} && {_u != player}) then {
			if (!isNil "_u" && {!isNull _u && {_u != player}}) then {
				private _distup = _u distance2D _sfm;
				if (_distup > 100) then {
					private _pic = getText (configFile >>"CfgVehicles">>typeOf _u>>"icon");
					if (_pic != "") then {
						_pic = getText (configFile >>"CfgVehicleIcons">>_pic);
					};
					_helperls pushBack [_distup, name _u, str _u, [_pic, "#(argb,8,8,3)color(1,1,1,0)"] select (_pic == ""), d_pnhudothercolor];
				};
			};
			false
		} count d_player_entities;
	};
	xr_x_updatelb = true;
	xr_spect_timer = time + 10;
};

//if (xr_x_updatelb && {!isNil {(uiNamespace getVariable "xr_SpectDlg")}} && {ctrlShown ((uiNamespace getVariable "xr_SpectDlg") displayCtrl 1000)}) then {
if (xr_x_updatelb && {!isNil {uiNamespace getVariable "xr_SpectDlg"}}) then {
	__TRACE_1("","xr_x_updatelb")
	xr_x_updatelb = false;
	private _lbctr = (uiNamespace getVariable "xr_SpectDlg") displayCtrl 1000;
	lbClear _lbctr;
	{
		private _idx = _lbctr lbAdd (_x select 1);
		_lbctr lbSetData [_idx, _x select 2];
		_lbctr lbSetValue [_idx, _x select 0];
		_lbctr lbSetPicture [_idx, _x select 3];
		_lbctr lbSetColor [_idx, _x select 4];
		false
	} count _helperls;
	__TRACE_1("","_helperls")
	private _setidx = -1;
	if !(_helperls isEqualTo []) then {
		lbSortByValue _lbctr;
		_setidx = 0;
		for "_i" from 0 to (lbSize _lbctr) -1 do {
			if (xr_spectcamtargetstr == _lbctr lbData _i) exitWith {
				_setidx = _i;
			};
		};
	};
	__TRACE_1("","_setidx")
	if (_setidx != -1) then {_lbctr lbSetCurSel _setidx};
};
_helperls = nil;

if (!isNull xr_cur_world_obj && {xr_MouseButtons select 0 && {xr_cur_world_obj != xr_spectcamtarget}}) then {
	private _lbctr = (uiNamespace getVariable "xr_SpectDlg") displayCtrl 1000;
	private _str = str xr_cur_world_obj;
	for "_i" from 0 to (lbSize _lbctr) - 1 do {
		if (_str == _lbctr lbData _i) exitWith {
			[_lbctr, _i] call xr_fnc_targetsslbchange;
		};
	};
};

// user pressed ESC
private _spectdisp = uiNamespace getVariable "xr_SpectDlg";
if ((isNil "_spectdisp" || {!ctrlShown (_spectdisp displayCtrl 1002)}) && {!xr_stopspect && {player getVariable "xr_pluncon"}}) then {
	__TRACE("ctrl not shown anymore, black out")
	"xr_revtxt" cutText ["","BLACK OUT", 1];
	__TRACE("creating new dialog")
	createDialog "xr_SpectDlg";
	private _disp = uiNamespace getVariable "xr_SpectDlg";
	__dspctrl(1000) ctrlShow false;
	__dspctrl(3000) ctrlShow false;
	if (!xr_x_withresp) then {
		__dspctrl(1020) ctrlShow false;
		__dspctrl(1021) ctrlShow false;
		__dspctrl(1005) ctrlShow false;
		__dspctrl(1006) ctrlShow false;
	} else {
		if (xr_respawn_available) then {
			__spectdlg1006e ctrlSetText xr_x_loc_922;
			__spectdlg1006e ctrlSetTextColor [1,1,0,1];
			__spectdlg1006e ctrlCommit 0;
		};
	};
	if (!xr_pl_no_lifes) then {
		xr_spectcamtarget = player;
		xr_spectcamtargetstr = xr_strpl;
		xr_spectcam cameraEffect ["INTERNAL", "Back"];
		xr_spectcam camCommit 0;
		cameraEffectEnableHUD true;
		__dspctrl(1010) ctrlSetText xr_name_player;
	} else {
		private _sfm = markerPos "xr_playerparkmarker";
		private _visobj = objNull;
		{
			private _u = missionNamespace getVariable _x;
			//if (!isNil "_u" && {alive _u} && {side (group _u) == xr_side_pl} && {_u != player} && {_u distance2D _sfm > 100}) exitWith {
			if (!isNil "_u" && {!isNull _u && {_u != player && {_u distance2D _sfm > 100}}}) exitWith {
					_visobj = _u;
			};
			false
		} count d_player_entities;
		if (isNull _visobj) then {_visobj = player};
		private _nposvis = ASLToATL (visiblePositionASL (vehicle _visobj));
		private _campos = [(_nposvis select 0) - 1 + random 2, (_nposvis select 1) - 1 + random 2, 2];
		xr_spectcam = "camera" camCreate _campos;
		xr_spectcamtarget = _visobj;
		xr_spectcamtargetstr = str _visobj;
		xr_spectcam cameraEffect ["INTERNAL", "Back"];
		xr_spectcam camCommit 0;
		cameraEffectEnableHUD true;
		__dspctrl(1010) ctrlSetText (name _visobj);
	};
	xr_spect_timer = -1;
	__TRACE("ctrl not shown anymore, black in")
	"xr_revtxt" cutText ["","BLACK IN", 1];
};
if (isNull xr_spectcamtarget) then { // player disconnect !?!
	//private _nposvis = ASLToATL (visiblePositionASL (vehicle player));
	//private _campos = [(_nposvis select 0) - 1 + random 2, (_nposvis select 1) - 1 + random 2, 2];
	xr_spectcamtarget = player;
	xr_spectcamtargetstr = xr_strpl;
	xr_spectcam cameraEffect ["INTERNAL", "Back"];
	xr_spectcam camCommit 0;
	cameraEffectEnableHUD true;
	__dspctrl(1010) ctrlSetText xr_name_player;
};

private _bb = boundingBoxreal vehicle xr_spectcamtarget;
private _l = ((_bb select 1) select 1) - ((_bb select 0) select 1);
#define __hstr 0.15
if (isNil "xr_hhx") then {xr_hhx = 2};
xr_hhx = ((((_bb select 1) select 2) - ((_bb select 0) select 2)) * __hstr) + (xr_hhx * (1 - __hstr));

private _vpmtw = ASLToATL (visiblePositionASL (vehicle xr_spectcamtarget));
xr_spectcam camSetTarget [_vpmtw select 0, _vpmtw select 1, (_vpmtw select 2) + (xr_hhx * 0.6)];
xr_spectcam camSetFov xr_szoom;

private _lsdist = _l * (0.3 max xr_sdistance);
private _d = -_lsdist;
private _co = cos xr_fangleY;
xr_spectcam camSetRelPos [(sin xr_fangle * _d) * _co, (cos xr_fangle * _d) * _co, sin xr_fangleY * _lsdist];
xr_spectcam camCommit 0;
cameraEffectEnableHUD true;
//if (!(player getVariable "xr_pluncon") && {!xr_pl_no_lifes}) exitWith {xr_stopspect = true};
//__TRACE("end one frame")