#define THIS_FILE "fn_unflipVehicle.sqf"
#include "..\..\x_setup.sqf"

player removeAction (param [2]);
private _vec = (param [3]) select 0;
private _hhe = createVehicle [d_HeliHEmpty, getPosATL _vec, [], 0, "NONE"];
_vec setPos (getPosATL _hhe);
deleteVehicle _hhe;
