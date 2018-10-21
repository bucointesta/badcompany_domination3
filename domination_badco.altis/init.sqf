// by Xeno
//#define __DEBUG__
#define THIS_FILE "init.sqf"
#include "x_setup.sqf"
diag_log [diag_frameno, diag_ticktime, time, "Executing Dom init.sqf"];

d_IS_HC_CLIENT = !isDedicated && {!hasInterface};
__TRACE_1("","d_IS_HC_CLIENT")

if (!isMultiplayer) then {d_uids_for_reserved_slots = ["_SP_PLAYER_"];};

//enable/disable calculations for AI sight view
if (isDedicated) then {disableRemoteSensors true};

if (isMultiplayer && {hasInterface}) then {
	enableRadio false;
	showChat false;
	0 fadeSound 0;
	titleText ["", "BLACK FADED"];
};

enableSaving [false,false];
enableTeamSwitch false;

//call of d_init.sqf on first available frame
d_of_ex_id = addMissionEventhandler ["EachFrame", {
	if (isNil "d_init_processed") then {
		call compile preprocessFileLineNumbers "d_init.sqf";
	};
	removeMissionEventHandler ["EachFrame", d_of_ex_id];
	d_of_ex_id = nil;
}];

diag_log [diag_frameno, diag_ticktime, time, "Dom init.sqf processed"];
