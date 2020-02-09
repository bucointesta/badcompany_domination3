_carrier = _this select 0;
_cargo = _this select 1;         

_cargo setVelocity (velocity _carrier);
//_cargo setDir (getDir _carrier);

waituntil {((getpos _cargo) select 2) < 750};


sleep 0.5;
_cargo setvectorup [0,0,1];
sleep 0.5;
_cargo setvectorup [0,1,1];
 sleep 0.5;
_cargo setvectorup [0,2,1];
 sleep 0.5;
_cargo setvectorup [0,1,1];
 sleep 0.5;
_cargo setvectorup [0,-1,1];
 sleep 0.5;
_cargo setvectorup [0,0,1];

_verticalsp = -70;

_cargo setvelocity [((velocity _cargo) select 0)-10,((velocity _cargo) select 1)-10,_verticalsp+10];

while {((getpos _cargo) select 2) > 20} do {
		
_cargo setvelocity [((velocity _cargo) select 0),((velocity _cargo) select 1),_verticalsp];
if (_verticalsp < -4) then {_verticalsp = _verticalsp + 2;} else {_verticalsp = -4;};
sleep 0.3;
};

//_cargo setvelocity [((velocity _cargo) select 0),((velocity _cargo) select 1),-4];
waituntil {_cargo setvelocity [0,0,-4]; ((getpos _cargo) select 2) < 5};