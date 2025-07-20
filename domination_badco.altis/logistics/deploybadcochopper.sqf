params ["_target", "_caller", "_actionId", "_arguments"];

private _nearobjs = nearestObjects [_caller, ["Helicopter"], 20, true];
_nearobjs = _nearobjs select {(alive _x) && {(_x getvariable ["d_vec",0]) == 3010}};

if ((count _nearobjs) < 1) exitWith {
  hint "UH-1Y not available";
};

private _vec = _nearobjs select 0;

if (_vec call d_fnc_isVecLocked) then {
  
  if ((count (nearestObjects [ATLtoASL badcochopperdeploypos, ["LandVehicle", "Air", "Man", "Ship"], 10])) > 0) exitWith {
    hint "Landing deck is occupied!";
  };
  
  hint "Deploying UH-1Y!";
  
  _attachPos = destroyer_badco worldToModel (getPosATL _vec);
  _attachPos set [2, 11];
  _vec attachTo [destroyer_badco, _attachPos];
  [_vec, 180] remoteExecCall ["setDir", _vec];
  for "_i" from 1 to 48 do {
    _attachPos = _attachPos vectorAdd [0,0.5,0];
    _vec attachTo [destroyer_badco, _attachPos];
    sleep 0.33;
  };
  detach _vec;
  _vec setPosATL badcochopperdeploypos;
  [_vec, [["textures\venom.paa","rhsusf\addons\rhsusf_a2port_air2\uh1y\data\uh1y_int_co.paa","","","","","","","","","","","","","","","","","","","","","","","","",""],[["rotor_destructx",0],["rotor_destructy",0],["rotordive_destructx",0],["rotordive_destructy",0],["rotordive_destructz",0],["rotor_static_dive_destructx",0],["rotor_static_dive_destructy",0],["rotor_static_dive_destructz",0],["mala_vrtule_destructy",0],["mala_vrtule_destructz",0],["glass6_destruct",0],["damagehide",0],["hrotor",0],["vrotor",0],["velka_vrtule_damage_unhide",0],["rotorshaft_damage",0],["cargolights_hide",0],["cabinlights_hide",0],["display_on",0],["display_off",0],["pip1_on",0],["monitor1_off",0],["pip2_on",0],["monitor2_off",0],["hide_mg",0],["hide_rockets",0],["hide_frontdoors",0],["hide_cargodoors",0],["indicatorcompass3",-1.52264],["rpm1_p",0],["rpm1_cp",0],["rpm2_p",0],["rpm2_cp",0],["speed1_p",0],["speed2_p",0],["speed1_cp",0],["speed2_cp",0],["vertspeed_p",0],["vertspeed_cp",0],["fuel1_p",1],["fuel1_cp",1],["fuel2_p",1],["fuel2_cp",1],["fuelh_p",0],["fuelh_cp",0],["torq1_p",0],["torq1_cp",0],["torq2_p",0],["torq2_cp",0],["altradardigi_p",0.39865],["altradardigi2_p",0.39865],["altradardigi_cp",0.39865],["altradardigi2_cp",0.39865],["dg_rpm",0],["dp_rpm",0],["dg_vertspeed",0],["dp_vertspeed",0],["dg_compas",-1.52264],["dp_compas",-1.52264],["dg_pitch",0],["dp_pitch",0],["dg_bank",-0],["dp_bank",-0],["flir_compass1",0],["flir_compass2",0],["flir_elevation1",0],["flir_elevation2",0],["horizonbankball",-0],["obsturret",0],["obsgun",0],["mainturret",0],["turret_2",-2.96706],["maingun",0],["gun_2",0],["machinegun_1",0.333333],["machinegun_2",0.333333],["gunner_1_rot1",0],["gunner_1_rot2",0],["gunner_1_rot1legs",0],["gunner_1_rot2legs",0],["gunner_1_t_legs_left_1",0],["gunner_1_y_leg_left",0],["gunner_1_y_leg_left_2",0],["gunner_1_y_leg_right",0],["gunner_1_y_leg_right_2",0],["gunner_1_t_leg_right_1",0],["gunner_1_rotx",0],["gunner_1_rotx_up",0],["gunner_1_rightside_hand_l",0],["gunner_1_rightside_hand_r",0],["gunner_1_translation",0],["gunner_1_translation2",0],["gunner_2_rot1",-2.96706],["gunner_2_rot2",-2.96706],["gunner_2_rot1legs",-2.96706],["gunner_2_t_legs_left_1",-2.96706],["gunner_2_y_leg_left",-2.96706],["gunner_2_y_leg_left_2",-2.96706],["gunner_2_y_leg_right",-2.96706],["gunner_2_y_leg_right_2",-2.96706],["gunner_2_t_leg_left_1",-2.96706],["gunner_2_rot2legs",-2.96706],["gunner_2_rotx",0],["gunner_2_rotx_up",0],["gunner_2_leftside_hand_l",-2.96706],["gunner_2_leftside_hand_r",-2.96706],["gunner_2_translation",-2.96706],["gunner_2_translation2",-2.96706],["mainturret_gunnerview",0],["maingun_gunnerview",0],["mainturret_2_gunnerview",-2.96706],["maingun_2_gunnerview",0],["hide_scopes",0],["hide_scopes2",0],["move_gunnerview_1",0],["move_gunnerview_2",0],["maingun_1_inertia",0],["mainturret_1_inertia",0],["maingun_2_inertia",0],["mainturret_2_inertia",0],["otocvez_damage",0],["otocvez_2_damage",0],["hudaction",0],["mala_vrtule_damage",0],["velka_vrtule_damage",0],["rotorhdive",0],["rotorhbank",-0],["rotortilt",0],["rotorshaft",0],["rotorshaft_damagehide",0],["mainrotor_folded",0],["mainrotor_unfolded",0],["glass1_destruct",0],["glass2_destruct",0],["glass3_destruct",0],["glass4_destruct",0],["glass5_destruct",0],["stick_pilot_dive_01",0],["stick_pilot_dive_02",0],["stick_pilot_dive_03",0],["stick_pilot_dive_04",0],["stick_pilot_dive_05",0],["stick_pilot_bank_01",-0],["stick_pilot_bank_02",-0],["stick_pilot_bank_03",-0],["stick_pilot_bank_04",-0],["stick_pilot_bank_05",-0],["stick_copilot_dive_01",0],["stick_copilot_dive_02",0],["stick_copilot_dive_03",0],["stick_copilot_dive_04",0],["stick_copilot_dive_05",0],["stick_copilot_bank_01",-0],["stick_copilot_bank_02",-0],["stick_copilot_bank_03",-0],["stick_copilot_bank_04",-0],["stick_copilot_bank_05",-0],["lever_pilot",0],["lever_copilot",0],["rudder_l",0],["rudder_r",0],["left_door",0],["right_door",0],["left_back_door",1],["right_back_door",1],["doorhandler_l",0],["doorhandler_r",0],["hmg_muzzleflashrot",610],["hmg_muzzleflashrot2",367],["hit_pylon_1_hide",0],["hit_pylon_2_hide",0]],[["FIR_Hydra_LAU130_P_19rnd_M","FIR_Hydra_LAU130_P_19rnd_M","rhsusf_ANALE39_CMFlare_Chaff_Magazine_x4"],[[],[],[]]]]] call d_fnc_skinpolyresp;
    _vec setVehicleLock "UNLOCKED";
    [_vec, 1] remoteExecCall ["setFuel", _vec];
  
} else {
  hint "UH-1Y already deployed!";
};