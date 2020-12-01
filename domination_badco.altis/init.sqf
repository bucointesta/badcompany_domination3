// by Xeno
//#define __DEBUG__
#define THIS_FILE "init.sqf"
#include "x_setup.sqf"
#include "AI.sqf"
#include "AI_resupply.sqf"
diag_log [diag_frameno, diag_ticktime, time, "Executing Dom init.sqf"];

d_IS_HC_CLIENT = !isDedicated && {!hasInterface};
__TRACE_1("","d_IS_HC_CLIENT")

if (!isMultiplayer) then {membersarr = ["_SP_PLAYER_"]; adminarr = ["_SP_PLAYER_"];};
if (isDedicated) then {disableRemoteSensors true};

if (isMultiplayer && {hasInterface}) then {
	enableRadio false;
	showChat false;
	0 fadeSound 0;
	titleText ["", "BLACK FADED"];
};

enableSaving [false,false];
enableTeamSwitch false;

addMissionEventhandler ["EachFrame", {
	if (isNil "d_init_processed") then {
		call compile preprocessFileLineNumbers "d_init.sqf";
	};
	removeMissionEventHandler ["EachFrame", _thisEventHandler];
}];

if (isServer) then {
	call compile preprocessFileLineNumbers "debug.sqf";
	addMissionEventHandler ["Ended", {
		params ["_endType"];
		diag_log format ["Mission ended! End type: %1", _endType];
	}];
};

diag_log [diag_frameno, diag_ticktime, time, "Dom init.sqf processed"];
