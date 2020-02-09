// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_inithelirespawn2.sqf"
#include "..\x_setup.sqf"

if (!isServer) exitWith{};

/*creation of chopper's array
each chopper is an array composed like this:
0) name (d_chopper_x)
1) ID number
2) boolean, true if respawn only when destroyed, false if respawn when inactive
3) time of server after which chopper respawn
4) vertical position relative to ground + 0.1
5) direction
6) config class name
7) time of inactivity left (during countdown) before respawn or -1 
8) time of inactivity before respawn or -1 
*/
d_helirespawn2_ar = [];
{
	private _vec_a = _x;
	_vec_a params ["_vec"];
	if (!isNil "_vec" && {!isNull _vec}) then {
		_vec_a params ["", "_number_v", "_ifdamage"];
		private _vposp = (getPosATL _vec) vectorAdd [0, 0, 0.1];
		d_helirespawn2_ar pushBack [_vec, _number_v, _ifdamage, -1, _vposp, direction _vec, typeOf _vec, if (_ifdamage) then {-1} else {_vec_a # 3},if (_ifdamage) then {-1} else {_vec_a # 3}];
		
		_vec setVariable ["d_OUT_OF_SPACE", -1];
		_vec setVariable ["d_vec", _number_v, true];
		_vec setVariable ["d_vec_islocked", _vec call d_fnc_isVecLocked];
		
		_vec setPos _vposp;
		_vec setDamage 0;
		
		_vec addEventhandler ["local", {_this call d_fnc_heli_local_check}];
		
#ifdef __TT__
		if (_number_v < 4000) then {
			_vec addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_checkveckillblufor}}];
		} else {
			_vec addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_checkveckillopfor}}];
		};
#endif
		
		_vec addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_chopperkilled}}];
	
		if (unitIsUAV _vec) then {
			_vec allowCrewInImmobile true;
		};
	};
} forEach _this;

__TRACE("Before d_fnc_helirespawn2")

0 spawn d_fnc_helirespawn2
