// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_ispilotcheck.sqf"
#include "..\..\x_setup.sqf"

private _enterer = param [0];
private _vec = param [1];
private _vecnum =  param [2];

if (_enterer == "d_admin") exitWith {true};

if ((((_vecnum >= 900) && {_vecnum < 950}) || {(_vecnum >= 980) && {_vecnum < 1000}}) && {!(_enterer in d_crewmen)}) exitWith {
	hint "You need to be a crewman to use this vehicle.";
	false
};

if (((_vecnum >= 940) && {_vecnum < 950}) || {(_vecnum >= 980) && {_vecnum < 1000}}) then {
	if (player == (gunner _vec)) then {
		_vec spawn {
			private _noSightVicTypes = ["rhsusf_M142_usarmy_D", "rhsgref_cdf_b_reg_BM21"];
			private _shipWeaponTypes = ["B_Ship_Gun_01_F"];
			private _mags = [];
			private _hasSights = true;
			if ((typeof vehicle player) in _noSightVicTypes) then {
				_hasSights = false;
			};
      private _isNotShipWeapon = true;
      if ((typeof vehicle player) in _shipWeaponTypes) then {
				_isNotShipWeapon = false;
			};
			private _sleepTime = [0.1, 0.75] select _hasSights;
			private _gun = _this getVariable ["gun", ""];
			if (_gun == "") then {
				_gun = currentWeapon _this;
				_this setVariable ["gun", _gun, true];
			};
			
			// start in a locked state by default
			private _locked = true;
			_this removeWeaponTurret [_gun, [0]];
			_this setTurretLimits [[0], 0, 0, 0, 0];
			sleep 1;
			
			while {(alive player) && {(gunner _this) == player}} do {
				if (((count allPlayers) < 50)
				|| {_isNotShipWeapon && ((_this distance2D (markerPos "d_base_marker")) < 1500)}
				|| {_isNotShipWeapon && ((_this distance2D d_cur_tgt_pos) < 3500)}
				|| {_isNotShipWeapon && (((getposATL _this) select 2) > 10)}
				|| {({(_x distance d_cur_tgt_pos) < 1000} count playableUnits) < 6}) then {
					if (!_locked) then {
						_locked = true;
						_this removeWeaponTurret [_gun, [0]];
						_this setTurretLimits [[0], 0, 0, 0, 0];
					};
					if (cameraView == "GUNNER") then {
						#ifndef __RHS__
							_this switchCamera "INTERNAL";
						#else
              if (_isNotShipWeapon) then {
                _this switchCamera "EXTERNAL";
              } else {
                _this switchCamera "INTERNAL";
              };
						#endif
					};          
					hintSilent "Artillery is disabled when:\n\n1) There are less than 50 players on the server\n\n2) You are closer than 1.5 km to base\n\n3) You are closer than 3.5 km to the AO.\n\n4) There are less than 6 players within 1 km of the AO to give you targets.";
				} else {
					if (_locked) then {
						_locked = false;
						_this addWeaponTurret [_gun, [0]];
						_this setTurretLimits [[0]]; //reset
						hintSilent "";
					};
					if (!_hasSights) then {
						hintSilent format ["Gun Azimuth: %1\nGun Elevation: %2", call {
							_wdir = _this weaponDirection _gun;
							_wdir_deg = round ((_wdir select 0) atan2 (_wdir select 1));
							if (_wdir_deg < 0) then {
								_wdir_deg = _wdir_deg + 360
							};
							_wdir_deg
						}, deg(_this animationPhase "mainGun")];
					};
				};
				_mags = magazines _this;
				{
					if (_x in _mags) then {
						_this removeMagazinesTurret [_x, [0]];
					};
				} foreach 
					#ifndef __RHS__
						["4Rnd_155mm_Mo_guided","6Rnd_155mm_Mo_mine","2Rnd_155mm_Mo_Cluster","2Rnd_155mm_Mo_LG","6Rnd_155mm_Mo_AT_mine","magazine_ShipCannon_120mm_HE_guided_shells_x2","magazine_ShipCannon_120mm_HE_LG_shells_x2","magazine_ShipCannon_120mm_HE_cluster_shells_x2","magazine_ShipCannon_120mm_mine_shells_x6","magazine_ShipCannon_120mm_AT_mine_shells_x6"];
					#else
						["rhs_mag_155mm_m712_2","rhs_mag_155mm_m731_1","rhs_mag_155mm_raams_1","rhs_mag_155mm_m864_3","magazine_ShipCannon_120mm_HE_guided_shells_x2","magazine_ShipCannon_120mm_HE_LG_shells_x2","magazine_ShipCannon_120mm_HE_cluster_shells_x2","magazine_ShipCannon_120mm_mine_shells_x6","magazine_ShipCannon_120mm_AT_mine_shells_x6"];
					#endif
				
				sleep _sleepTime;
			};
			if (_locked) then {
				hintSilent "";
			};
		};
	} else {
		if (isNull gunner _vec) then {
			private _gun = _vec getVariable ["gun", ""];
			if (_gun == "") then {
				_gun = currentWeapon _vec;
				_vec setVariable ["gun", _gun, true];
				_vec removeWeapon _gun;
			};
		};		
	};	
};

//so medevac pilots can't fly other choppers
//_transPilots = d_transport_pilots - ["d_medpilot"];

//have common pilot slot instead...
_pilots = d_transport_pilots + d_attack_pilots - ["d_medpilot"];

if (_enterer == "d_medpilot") exitWith {
	if (_vecnum == 3012) then {
		true
	} else {
		if (_vec isKindOf "Air") then {
			hint "You are not authorized to fly this aircraft!";
			false		
		} else {
			if ((_vecnum in [806,807,808,721,729,730]) && {!(call d_fnc_isbadco)}) then {
				false
			} else {
				true
			}
		}
	}
};
if (_vecnum == 3012) exitWith {
	hint "Only MedEvac pilots can fly this chopper!";		
	false	
};

if (_vecnum == 3011) exitWith {hint "This is an admin reserved chopper";false};

if ((_vec isKindOf "Air") && {!(_enterer in _pilots)}) exitWith {hint "You need to be a pilot to fly this aircraft";false};

if ((_vecnum in [806,807,808,721,729,730,756,757,3009,3010]) && {!(call d_fnc_isbadco)}) exitWith {hint "This vehicle is reserved for Bad Company members";false};

//if (((_vecnum == 3008) || {_vecnum == 3101} || {_vecnum == 3102} || {_vecnum == 3005}) && {!(_enterer in d_attack_pilots)}) exitWith {hint "You need to be an attack pilot to fly this vehicle";false};
//if ((_vec isKindOf "Air") && {!((_enterer in d_attack_pilots) || {_enterer in _transPilots})}) exitWith {hint "You need to be a pilot to fly this vehicle";false};

#ifndef __RHS__
	// Jet nerf
	if ((_vec iskindof "Plane_CAS_01_base_F") || {_vec iskindof "Plane_Fighter_01_Base_F"}) then {
		// seems there is no EH for this...
		_vec spawn {
			while {(alive player) && {(vehicle player) == _this}} do {
				uiSleep 0.1;
				if (cameraView == "GUNNER") then {
					hint "The targeting pod on jets is disabled on this server. Ask a ground team member to lase targets!";
					_this switchCamera "INTERNAL";
				};
			};
		};
	};
#endif

true
