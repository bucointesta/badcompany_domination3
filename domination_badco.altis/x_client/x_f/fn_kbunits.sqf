// by Xeno
#define THIS_FILE "fn_kbunits.sqf"
#include "..\..\x_setup.sqf"

if (param [1] != side (group player)) exitWith {};
(missionNamespace getVariable (param [0])) kbAddTopic["PL" + str player, "x_bikb\domkba3.bikb"];
