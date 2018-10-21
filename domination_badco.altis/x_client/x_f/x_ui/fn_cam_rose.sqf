// by Xeno
#define THIS_FILE "fn_cam_rose.sqf"
#include "..\..\..\x_setup.sqf"

"d_cam_rose" cutRsc ["d_cam_rose", "PLAIN"];

disableSerialization;

private _center_x = SafeZoneX + SafeZoneW - 0.2;
private _center_y = SafeZoneY + SafeZoneH - 0.3;
#define __radius 0.05
#define __x_offset 0.003
#define __y_offset 0.003

#define _disp (uiNamespace getVariable "d_cam_rose")
private _char_n = _disp displayCtrl 64432;
private _char_e = _disp displayCtrl 64433;
private _char_s = _disp displayCtrl 64434;
private _char_w = _disp displayCtrl 64435;

(ctrlPosition _char_n) params ["", "", "_width", "_height"];

private _correctit_fnc = {
	params ["_pos", "_dir"];
	if (_dir >= 270 || {_dir <= 90}) then {
		_pos set [1, (_pos select 1) + __y_offset]
	} else {
		if (_dir >= 0 && {_dir <= 180}) then {
			_pos set [0, (_pos select 0) - __x_offset]
		} else {
			if (_dir >= 90 && {_dir <= 270}) then {
				_pos set [1, (_pos select 1) - __y_offset]
			} else {
				if (_dir >= 180 && {_dir <= 360}) then {
					_pos set [0, (_pos select 0) + __x_offset]
				};
			};
		};
	};
	_pos
};

while {!isNil "d_do_end_rose"} do {
	private _dir = getDirVisual BIS_fnc_establishingShot_fakeUAV;
	private _x1 = _center_x - (__radius * sin _dir);
	private _y1 = _center_y - (__radius * cos _dir);
	private _pos = [[_x1, _y1], _dir] call _correctit_fnc;
	_char_n ctrlSetPosition [_pos select 0, _pos select 1, _width, _height];
	//_char_n ctrlSetAngle [_dir, _center_x, _center_y];
	_char_n ctrlCommit 0;

	_x1 = _center_x - (__radius * sin (_dir + 90));
	_y1 = _center_y - (__radius * cos (_dir + 90));
	_pos = [[_x1, _y1], _dir] call _correctit_fnc;
	_char_w ctrlSetPosition [_pos select 0, _pos select 1, _width, _height];
	//_char_w ctrlSetAngle [_dir + 90, _center_x, _center_y];
	_char_w ctrlCommit 0;

	_x1 = _center_x - (__radius * sin (_dir + 180));
	_y1 = _center_y - (__radius * cos (_dir + 180));
	_pos = [[_x1, _y1], _dir] call _correctit_fnc;
	_char_s ctrlSetPosition [_pos select 0, _pos select 1, _width, _height];
	//_char_s ctrlSetAngle [_dir + 180, _center_x, _center_y];
	_char_s ctrlCommit 0;

	_x1 = _center_x - (__radius * sin (_dir + 270));
	_y1 = _center_y - (__radius * cos (_dir + 270));
	_pos = [[_x1, _y1], _dir] call _correctit_fnc;
	_char_e ctrlSetPosition [_pos select 0, _pos select 1, _width, _height];
	//_char_e ctrlSetAngle [_dir + 270, _center_x, _center_y];
	_char_e ctrlCommit 0;

	sleep 0.01;
};

"d_cam_rose" cutFadeOut 0;