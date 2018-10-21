// by Xeno
#define THIS_FILE "fn_settingsdialoginit.sqf"
#include "..\..\..\x_setup.sqf"
#define __ctrl(numcontrol) (_disp displayCtrl numcontrol)

params ["_disp"];

if (d_disable_viewdistance) then {
	__ctrl(1000) ctrlEnable false;
	__ctrl(1999) ctrlSetText (localize "STR_DOM_MISSIONSTRING_357");
	__ctrl(1997) ctrlSetText "";
} else {
	__ctrl(1000) sliderSetRange [200, d_MaxViewDistance];
	__ctrl(1000) sliderSetPosition viewDistance;
	__ctrl(1999) ctrlSetText format [localize "STR_DOM_MISSIONSTRING_358", round viewDistance];
};

private _ctrl = __ctrl(1001);

private _glindex = -1;
{
	private _index = _ctrl lbAdd _x;
	if (d_graslayer_index == _index) then {_glindex = _index};
	false
} count [localize "STR_DOM_MISSIONSTRING_359", localize "STR_DOM_MISSIONSTRING_360", localize "STR_DOM_MISSIONSTRING_361"];

_ctrl lbSetCurSel _glindex;
if (d_Terraindetail == 1) then {
	_ctrl ctrlEnable false;
	__ctrl(1998) ctrlSetText (localize "STR_DOM_MISSIONSTRING_362");
	__ctrl(1996) ctrlSetText "";
};

_ctrl = __ctrl(1002);
{_ctrl lbAdd _x;false} count [localize "STR_DOM_MISSIONSTRING_363", localize "STR_DOM_MISSIONSTRING_364", localize "STR_DOM_MISSIONSTRING_365", localize "STR_DOM_MISSIONSTRING_367"];
_ctrl lbSetCurSel d_show_player_marker;

d_pnsel_first = true;
_ctrl = __ctrl(1602);
{_ctrl lbAdd _x;false} count [localize "STR_DOM_MISSIONSTRING_363a", localize "STR_DOM_MISSIONSTRING_364", localize "STR_DOM_MISSIONSTRING_367"];
_ctrl lbSetCurSel d_show_player_namesx;

__ctrl(2001) ctrlSetText str(d_points_needed select 0);
__ctrl(2002) ctrlSetText str(d_points_needed select 1);
__ctrl(2003) ctrlSetText str(d_points_needed select 2);
__ctrl(2004) ctrlSetText str(d_points_needed select 3);
__ctrl(2005) ctrlSetText str(d_points_needed select 4);
__ctrl(2006) ctrlSetText str(d_points_needed select 5);
__ctrl(2011) ctrlSetText str(d_points_needed select 6);

#define __str _str = _str + 

private _str = "";

{
	private _med = missionNamespace getVariable _x;
	if (!isNil "_med" && {!isNull _med && {isPlayer _med}}) then {
		if (_str != "") then {__str ", "};
		__str (if (alive _med) then {name _med} else {localize "STR_DOM_MISSIONSTRING_493"});
	};
	false
} count d_medics;


if (_str == "") then {_str = localize "STR_DOM_MISSIONSTRING_494"};
__ctrl(2008) ctrlSetText _str;

_str = "";
{
	private _art = missionNamespace getVariable _x;
	if (!isNil "_art" && {!isNull _art && {isPlayer _art}}) then {
		if (_str != "") then {__str ", "};
		__str (if (alive _art) then {name _art} else {localize "STR_DOM_MISSIONSTRING_493"});
	};
	false
} count d_can_use_artillery;

if (_str == "") then {_str = localize "STR_DOM_MISSIONSTRING_495"};
__ctrl(2009) ctrlSetText _str;

_str = "";
{
	private _eng = missionNamespace getVariable _x;
	if (!isNil "_eng" && {!isNull _eng && {isPlayer _eng}}) then {
		if (_str != "") then {__str ", "};
		__str (if (alive _eng) then {name _eng} else {localize "STR_DOM_MISSIONSTRING_493"});
	};
	false
} count d_is_engineer;

if (_str == "") then {_str = localize "STR_DOM_MISSIONSTRING_496"};
__ctrl(2010) ctrlSetText _str;

ctrlSetFocus __ctrl(1212);
