// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_initvrespawn2.sqf"
#include "..\x_setup.sqf"

if (!isServer) exitWith{};

d_vrespawn2_ar = [];
{
	__TRACE_1("","_x")
	_x params ["_vec", "_number_v","_respawnTimer"];
	if (!isNil "_vec" && {!isNull _vec}) then {
		private _vposp = if ((_vec isKindOf "Air") || {_vec isKindOf "Ship"}) then {
			(getPosATL _vec) vectorAdd [0, 0, 0.1];
		} else {
			//getPosATL _vec;
			(getPosATL _vec) vectorAdd [0, 0, 0.1];
		};
		/*
		if (count _x == 2) then {
			d_vrespawn2_ar pushBack [_vec, _number_v, _vposp, getDir _vec, typeOf _vec];
		} else {
			d_vrespawn2_ar pushBack [_vec, _number_v, _vposp, getDir _vec, typeOf _vec, _x # 2];
			if (_number_v < 100) then {_vec setVariable ["d_vec_is_mhq", [_x select 2, _number_v]]};
		};
		*/
		
		d_vrespawn2_ar pushBack [_vec, _number_v, _vposp, getDir _vec, typeOf _vec,_respawnTimer, _vec call bis_fnc_getVehicleCustomization];
		
		_vec setVariable ["d_OUT_OF_SPACE", -1];
		_vec setVariable ["d_vec", _number_v, true];
		// Hunter: initvec should take care of this and we shouldn't be forcing this for all vics (which includes ammo trucks!)
		//_vec setAmmoCargo 0;
		_vec setVariable ["d_vec_islocked", _vec call d_fnc_isVecLocked];
		
		if ((_number_v >= 950) && {_number_v < 1000}) then {
			[_vec, ["Get In",{params ["_target", "_caller", "_actionId", "_arguments"]; _caller moveInGunner _target},nil,100,false,true,"","(alive _target) && {(vehicle _this) == _this} && {(_target emptyPositions 'Gunner') > 0}",5]] remoteExecCall ["addAction", -2 , true];
			_vec setVariable ["d_no_lift", true, true];
			_vec setVehicleLock "UNLOCKED";
		};
		
#ifdef __TT_
		if (_number_v < 1000) then {
			_vec addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_checkveckillblufor}}];
		} else {
			_vec addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_checkveckillopfor}}];
		};
#endif
		if (_number_v < 100 || {_number_v > 999 && {_number_v < 1100}}) then {
			_vec addMPEventhandler ["MPKilled", {(_this select 0) call d_fnc_MHQFunc}];
			_vec addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_fuelCheck; _this call d_fnc_mhqmsg}}];
			_vec addEventHandler ["handleDamage", {_this call d_fnc_pshootatmhq}];
		} else {
			_vec addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_fuelCheck}}];
		};
		if (_vec isKindOf "Air") then {
			_vec enableCopilot false;
		} else {
			_vec setVariable ["d_liftit", true, true];
		};
		if (unitIsUAV _vec) then {
			_vec allowCrewInImmobile true;
		};
	};
} forEach _this;

0 spawn d_fnc_vrespawn2
