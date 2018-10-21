// by Xeno
#define THIS_FILE "x_missionsetup.sqf"
#include "..\x_setup.sqf"

// I'm using x_mXX.sqf for the mission filename where XX (index number) has to be added to d_sm_array
d_sm_fname = "x_m";

// d_sm_array contains the indices of the sidemissions (it gets shuffled later)
// to remove a specific side mission just remove the index from d_sm_array
d_sm_array =
	[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,
	20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,
	41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,
	61,62,63,64,65,66,67,68,69,70,71,72,73,74,100,101,102];//,103,104,105,106];

d_number_side_missions = count d_sm_array;

if (call d_fnc_checkSHC) then {		
	// these vehicles get spawned in a convoy sidemission. Be aware that it is the best to use a wheeled vehicle first as leader.
	// at least wheeled AI vehicles try to stay on the road somehow
	d_sm_convoy_vehicles = ["O_MRAP_02_hmg_F","O_APC_Wheeled_02_rcws_F", "O_MRAP_02_gmg_F", "O_Truck_03_repair_F", "O_Truck_03_fuel_F", "O_Truck_03_ammo_F", "O_APC_Wheeled_02_rcws_F"];
};

// Instead of a random vehicle chosen for winning a side mission you can setup it in the mission yourself now
// Add d_current_sm_bonus_vec to the beginning of a sidemission script with a vehicle class string and that vehicle gets chosen instead of a random one.
// Examples:
// d_current_sm_bonus_vec = "B_MBT_01_cannon_F";
// DON'T CHANGE IT HERE IN X_MISSIONSETUP.SQF!!!!!!!!!!!!!!!!!!!!!!!!!
if (call d_fnc_checkSHC) then {
	d_current_sm_bonus_vec = "";
};
