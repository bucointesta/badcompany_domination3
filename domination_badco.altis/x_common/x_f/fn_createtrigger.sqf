// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_createtrigger.sqf"
#include "..\..\x_setup.sqf"

private _trig = createTrigger ["EmptyDetector", _this select 0, true];
_trig setTriggerArea (_this select 1);
_trig setTriggerActivation (_this select 2);
_trig setTriggerStatements (_this select 3);
_trig