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
// Hunter: Xeno runs this code on mission.sqm individually on all carrier-placed aircraft...
if (d_carrier) then {
	_this spawn {
		sleep 1;
		_pos = [];
		_flagHeight = ((getPosASL d_FLAG_BASE) select 2) + 0.01;
		{
			_height = _flagHeight;
			_vec_a = _x;
			_vec_a params ["_vec"];
			if (!isNil "_vec" && {!isNull _vec}) then {
				if (surfaceIsWater getpos _vec) then {
					_pos = getPosASL _vec;
					_objs = nearestObjects [_pos, ["Land_MapBoard_F"], 100, true];
					if ((count _objs) > 0) then {
						_height = ((getPosASL (_objs select 0)) select 2) + 0.1;
					};
          _pos set [2, _height];
          _vec enableSimulation true;
					_vec setVectorUp [0,0,1];					
					_vec setPosASL _pos;
					_vec setDamage 0;
				};
			};
		} foreach _this;
	};
};


d_helirespawn2_ar = [];
{
	private _vec_a = _x;
	_vec_a params ["_vec"];
	if (!isNil "_vec" && {!isNull _vec}) then {
		_vec_a params ["", "_number_v", "_ifdamage"];
		private _vposp = (getPosATL _vec) vectorAdd [0, 0, 0.1];
		if ((d_carrier) && {surfaceIsWater getpos _vec}) then {
      private _pos = getPosASL _vec;
      private _objs = nearestObjects [_pos, ["Land_MapBoard_F"], 100, true];
      private _isHangarChopper = false;
      if (_number_v == 3010) then {
        _isHangarChopper = true;
      };
      if ((count _objs) > 0) then {
        _vposp set [2, ((getPosASL (_objs select 0)) select 2) + 1];
        if (_isHangarChopper) then {
          _vposp set [2, ((getPosASL (_objs select 0)) select 2) + 0.1];
        };
        _vposp = ASLToATL _vposp; // waves change ASL, so try to grab a stable ATL pos specific to the vehicle at init
      };      
		};
		d_helirespawn2_ar pushBack [_vec, _number_v, _ifdamage, -1, _vposp, direction _vec, typeOf _vec, _vec_a # 3, -1, _vec call d_fnc_getskinpoly];
		
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
