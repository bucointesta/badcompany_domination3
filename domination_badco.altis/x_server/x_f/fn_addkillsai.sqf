// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_addkillsai.sqf"
#include "..\..\x_setup.sqf"

private _killer = param [1];
if (!isPlayer _killer) then {
	private _lead = leader _killer;
	if (!isNull _lead && {isPlayer _lead && {side (group _killer) != d_side_enemy}}) then {
		_lead addScore (param [0]);
	};
};