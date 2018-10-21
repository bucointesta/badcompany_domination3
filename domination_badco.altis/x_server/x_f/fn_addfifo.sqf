// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_addfifo.sqf"
#include "..\..\x_setup.sqf"

d_fifo_ar append _this;

if (count d_fifo_ar > 20) then {
	private _num = count d_fifo_ar - 20;
	for "_i" from 0 to _num do {
		deleteVehicle (d_fifo_ar select _i);
	};
	d_fifo_ar deleteRange [0, _num];
};