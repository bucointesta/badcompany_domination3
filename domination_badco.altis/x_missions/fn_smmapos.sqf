// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_smmapos.sqf"
#include "..\x_setup.sqf"

private _res = [markerPos _this];
for "_i" from 1 to 100 do {
	private _nm = format ["%1_%2", _this, _i];
	if (markerPos _nm isEqualTo [0,0,0]) exitWith {};
	_res pushBack (markerPos _nm);
};
_res
