// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_vrespawn2.sqf"
#include "..\..\x_setup.sqf"

/*each 8-13  seconds, pass every line of veichle array and forEach line
- check if deserted
- check if out of space
- if empty and abandoned, out of space, destroyed or underwater, then respawn it
*/
sleep (8 + round 5);

while {true} do {
	{
		private _vec_a = _x;
                /*composition of _x
		0) ingame object (d_out_of_space = -1 or time before respawn in OOS // d_ammobox = true if contained an ammobox // d_vec = type of veichle // d_is_locked = true if locked)
		1) id number of veichle
		2) position
		3) direction
		4) type
		5) respawn: if MHQ an identifier string, else =-1
		*/
		_vec_a params ["_vec"];
		private _number_v = _vec_a select 1;
		
		__TRACE_1("","_vec_a")
		
		//private _disabled = damage _vec >= 0.9; //true if destroyed
		private _disabled = false;
			
		private _empty = {alive _x} count (crew _vec) == 0; //true if empty

/*script for respawn if abandoned, set to work only with bikes*/	
		if ((_number_v >= 700) && {_number_v < 800} && {alive _vec}) then {  
			if (_empty) then {
				private _empty_respawn = _vec_a select 5;
				if (_empty_respawn == -1) then {
					if (_vec distance2D (_vec_a select 2) > 10) then { //distance from initial respawn
						_vec_a set [5, time + 60]; // abandoned timeout
						d_vrespawn2_ar set [_forEachIndex, _vec_a];
					};
				} else {
					if (time > _empty_respawn) then {
						private _runits = ((allPlayers - entities "HeadlessClient_F") select {!isNil "_x" && {!isNull _x}});
						sleep 0.1;
						if ({_x distance2D _vec < 50} count _runits == 0) then { //distance from other player
							_disabled = true;
						};
					};
				};
			__TRACE_3("","_empty_respawn","time","alive _vec")	
			} else {
				_vec_a set [5, -1];
				d_vrespawn2_ar set [_forEachIndex, _vec_a];
			};
		};
		
		//add respawn for dead timer
		if (_number_v < 1000) then {  
			if ((!alive _vec) || {(underwater _vec) && {!(_vec iskindof "SDV_01_base_F")}}) then {
				private _respawnTimer = _vec_a select 5;
				if (_respawnTimer == -1) then {
					_vec_a set [5, time + 900]; // currently 15 minutes for all)
					d_vrespawn2_ar set [_forEachIndex, _vec_a];
				} else {
					if (time > _respawnTimer) then {
							_disabled = true; //do respawn
							_vec_a set [5, -1]; //reset timer
							d_vrespawn2_ar set [_forEachIndex, _vec_a];
					};
				};
			};
		};

		
		__TRACE_1("","_vec call d_fnc_OutOfBounds")
		
		if (_empty && {!_disabled && {alive _vec && {_vec call d_fnc_OutOfBounds}}}) then {
			private _outb = _vec getVariable "d_OUT_OF_SPACE";
			if (_outb != -1) then {
				if (time > _outb) then {_disabled = true};
			} else {
				_vec setVariable ["d_OUT_OF_SPACE", time + 600];
			};
		} else {
			_vec setVariable ["d_OUT_OF_SPACE", -1];
		};
		
		sleep 0.01;

		__TRACE_3("","_empty","_disabled","alive _vec")
		__TRACE_1("","underwater _vec")
		
		if (_disabled) then {
			private _fuelleft = _vec getVariable ["d_fuel", 1];
			/*remove 1 ammobox from total count*/
			if (_vec getVariable ["d_ammobox", false]) then {
				d_num_ammo_boxes = d_num_ammo_boxes - 1; publicVariable "d_num_ammo_boxes";
			};
			if (_number_v < 100) then {
				private _dhqcamo = _vec getVariable ["d_MHQ_Camo", objNull];
				if (!isNull _dhqcamo) then {deleteVehicle _dhqcamo};
			};
			
			_ammbox = _vec getvariable ["actualAmmobox",objNull];			
			if (!isNull _ammbox) then {
			
				deleteVehicle _ammbox;
			
			};				
			
			private _isitlocked = _vec getVariable ["d_vec_islocked", false]; // || {_vec call d_fnc_isVecLocked};
			private _skinpoly = _vec call d_fnc_getskinpoly;
			__TRACE_1("","_skinpoly")
			sleep 0.1;
			if (unitIsUAV _vec) then {
				{_vec deleteVehicleCrew _x} forEach (crew _vec);
			};
			_customs = _vec call bis_fnc_getVehicleCustomization;			
			deleteVehicle _vec;
			sleep 0.5;
			//_vec = createVehicle [_vec_a # 4, _vec_a # 2, [], 0, "NONE"];
			_vec = createVehicle [_vec_a # 4, [0,0,5000], [], 0, "NONE"];
			_customsArray = [_vec];		
			{_customsArray pushBack _x;} foreach _customs;		
			_customsArray call BIS_fnc_initVehicle;
			if ((_number_v == 806) || (_number_v == 807)) then {
				_vec setObjectTextureGlobal [0, "textures\offroad4.paa"];
			};
			if (_number_v == 808) then {
				_vec setObjectTextureGlobal [0, "textures\suv4.paa"];
			};
			_vec setDir (_vec_a # 3);
			sleep 0.1;
			_vec setPosATL (_vec_a # 2);
			_vec setVariable ["d_vec_islocked", _isitlocked];
			if (_isitlocked) then {_vec lock true};
			if (_vec isKindOf "Air") then {
				private _cposc = _vec_a # 2;
				__TRACE_2("","_vec","_cposc")
				if (surfaceIsWater _cposc) then {
					_cposc set [2, (getPosASL d_FLAG_BASE) # 2];
					[_vec, _cposc] spawn {
						params ["_vec", "_cposc"];
						sleep 1;
						_vec setPosASL _cposc;
						_vec setDamage 0;
					};
				};
			};
			_vec setFuel _fuelleft;
			[_vec, _skinpoly] call d_fnc_skinpolyresp;
			_skinpoly = nil;
#ifdef __TT_
			if (_number_v < 1000) then {
				_vec addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_checkveckillblufor}}];
			} else {
				_vec addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_checkveckillopfor}}];
			};
#endif
			if (_number_v < 100) then {
				_vec addMPEventhandler ["MPKilled", {(_this select 0) call d_fnc_MHQFunc}];
				/*
				if (count _vec_a == 6) then {
					_vec setVariable ["d_vec_is_mhq", [_vec_a # 5, _number_v]];
				};
				*/
				_vec addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_fuelCheck; _this call d_fnc_mhqmsg}}];
				_vec addEventHandler ["handleDamage", {_this call d_fnc_pshootatmhq}];
			};
			_vec addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_fuelCheck}}];
			_vec_a set [0, _vec];
			d_vrespawn2_ar set [_forEachIndex, _vec_a];
			_vec setVariable ["d_OUT_OF_SPACE", -1];
			_vec setVariable ["d_vec", _number_v, true];
			_vec setAmmoCargo 0;
			_vec setVariable ["d_vec_islocked", _isitlocked];
			if (_isitlocked) then {_vec lock true};
			if (_vec isKindOf "Air") then {
				_vec enableCopilot false;
			} else {
				_vec setVariable ["d_liftit", true, true];
			};
			if (unitIsUAV _vec) then {
				createVehicleCrew _vec;
				_vec allowCrewInImmobile true;
			};
			sleep 0.01;
			_vec remoteExecCall ["d_fnc_initvec", [0, -2] select isDedicated];
		};
		sleep (8 + random 5);
	} forEach d_vrespawn2_ar;
	sleep (8 + random 5);
};
