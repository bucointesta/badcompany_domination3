#define THIS_FILE "x_revive.sqf"
#include "x_macros.sqf";

// set max lives to -1 to have unlimited lives
if (isNil "xr_max_lives") then {
	xr_max_lives = 30;
};

// show markers on map where unit died
xr_with_marker = true;

// life time once unconscious
if (isNil "xr_lifetime") then {
	xr_lifetime = 300;
};

// map click respawn available after x seconds, -1 for immedeate respawn
if (isNil "xr_respawn_available_after") then {
	xr_respawn_available_after = 120;
};

// respawn available when no other players in near_player_dist
xr_near_player_dist_respawn = true;

// set the number of bonus lifes a player gets when he revives another player, 0 to disable it
xr_help_bonus = 1;

// if set to false no "x was revived by y" message will show up
xr_revivemsg = true;

// if a player can not revive another unit he can at least use CPR. cpr_time_add gets added to the other units livetime
xr_cpr_time_add = 300;

// selfheals, how often a player can heal himself (0 = disabled)
xr_selfheals = 0;
// if selfheals is enabled then if damage player >= 0.3 and <= 0.7 the action shows up
xr_selfheals_minmaxdam = [0.3, 0.7];

// if xr_spectating is set to true then player can use spectate view when he is unconscious
// if set to false no spectating dialog is shown, camera remains in player view
xr_spectating = d_WithReviveSpectating == 0;

call compile preprocessFileLineNumbers "x_revive\xr_main.sqf";

execVM "x_revive\xr_init.sqf";
