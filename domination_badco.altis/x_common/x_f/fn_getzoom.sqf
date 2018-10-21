// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_getzoom.sqf"
#include "..\..\x_setup.sqf"

([0.5,0.5] distance2D worldToScreen positionCameraToWorld [0,3,4]) * (getResolution select 5) / 2
