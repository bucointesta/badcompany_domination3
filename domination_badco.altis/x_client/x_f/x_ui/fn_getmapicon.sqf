// by Xeno
#define THIS_FILE "fn_getmapicon.sqf"
#include "..\..\..\x_setup.sqf"

params ["_v", "_u", ["_m", false]];

private _i = _v getVariable (["d_ma_type", "d_icon_type"] select (!_m));
if (isNil "_i") then {
	_i = getText (configFile >>"CfgVehicles">>typeOf _v>>"icon");
	_v setVariable ["d_icon_type", _i];
};
private _s = _v getVariable "d_icon_size";
if (isNil "_s") then {
	_s = if (_v isKindOf "Man") then {
		22
	} else {
		if (_v isKindOf "LandVehicle" || {_v isKindOf "Air"}) then {
			28
		} else {
			26 // Ship
		}
	};
	_v setVariable ["d_icon_size", _s];
};

if (!_m) then {
	private _a = [0.7, 0.9] select (!isNull _u && {(group _u) isEqualTo (group player)});
	private _c = [0, 0.3, 0.6, _a];
	[_i, _s, _c]
} else {
	[_i, _s, _v getVariable "d_ma_color"]
};