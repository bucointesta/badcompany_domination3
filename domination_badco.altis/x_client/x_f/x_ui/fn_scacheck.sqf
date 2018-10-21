// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_scacheck.sqf"
#include "..\..\..\x_setup.sqf"

d_pisadminp = (isMultiplayer && {serverCommandAvailable "#shutdown"}) || {isServer};
