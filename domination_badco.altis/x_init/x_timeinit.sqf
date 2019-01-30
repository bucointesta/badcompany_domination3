// by Bucointesta
//#define __DEBUG__
#define THIS_FILE "x_timeinit.sqf"
#include "..\x_setup.sqf"
diag_log [diag_frameno, diag_ticktime, time, "Executing Dom x_timeinit.sqf"];

[] spawn {
			
	if (!isServer) then {
			waituntil {!isnil "d_publicServerTime"};
			setdate d_publicServerTime;
			"d_publicServerTime" addPublicVariableEventHandler {
			setdate d_publicServerTime; 
			};
	};

	if (isserver) then {
		
			waitUntil {time > 10};
			d_publicServerTime = date;
			d_publicServerTime set [3,d_TimeOfDay];
			publicvariable "d_publicServerTime";
			setdate d_publicServerTime;
			settimemultiplier d_timemultiplier;

			sleep 300;
			
			d_sunrise = (date call BIS_fnc_sunriseSunsetTime) select 0;
			d_sunset = (date call BIS_fnc_sunriseSunsetTime) select 1;
			d_daystart = (round d_sunrise) - 1;
			d_dayend = (round d_sunset) + 1;
			["itemAdd", ["updatetime", { 
				d_publicServerTime = date;
						publicVariable "d_publicServerTime";
						setdate d_publicServerTime;
				if (daytime > d_daystart && daytime < d_dayend) then {setTimeMultiplier d_timemultiplier} else {setTimeMultiplier (d_timemultiplier * 6)};		
			}, 300]] call BIS_fnc_loop;
	};    

	diag_log [diag_frameno, diag_ticktime, time, "Dom x_timeinit.sqf processed"];

};