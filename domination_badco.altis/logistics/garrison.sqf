// let the unit settle

private ["_unit","_radius","_buildingslist","_build","_nbuild","_localbuilding","_buildpos","_group","_buildingsleft","_bposleft","_minheight","_capacityarray","_warping","_occupied","_pcnt","_allbpos","_selectedbpos","_limitedPositions","_rnum","_poscoords","_sillyarray","_issilly","_totalPositions","_posx","_posy","_posz","_AccessibleFound","_BB","_BC","_BCworld","_heightEstimate","_widthEstimate","_lengthEstimate","_halfwidthEstimate","_halflengthEstimate","_halfheightEstimate","_t","_stationary","_capacity","_maxcap","_side","_patrolgroup","_remainders","_objectslist","_noposbuildings"];
sleep 1;
_t = time;

_minheight = _this select 5;
if (isNil("_minheight")) then {
  _minheight  = 0;
};

_group = _this select 0;
_cleanup = units _group;

_unit = leader _group;
_radius = _this select 1;
_stationary = _this select 2;

_capacityarray = _this select 3;
if ((count _capacityarray) == 0) then {
  _capacityarray  = [60,0];
};

_capacity = _capacityarray select 0;
_maxcap = _capacityarray select 1;

_warping = _this select 4;
if (isNil("_warping")) then {
  _warping  = false;
};


_group setvariable ["Hz_defending",_stationary];
_side = side _unit;
/*
  nul = [_group] spawn
  {
    _group = _this select 0;
    
    while {sleep 0.5; true} do
    {
      _unit = leader _group;
      hint (str(behaviour _unit));
    };
  };
  */
//missionnamespace setvariable [format ["group1%1",name _unit],createGroup _side];
//_patrolgroup = missionnamespace getvariable (format ["group1%1",name _unit]);
_remainders = creategroup _side;

_objectslist = nearestObjects [_unit,["House"],_radius];
_buildingslist = [];
_buildingsleft = [];
_noposbuildings = [];

//define functions
if (isnil("fnc_sillybuild_check")) then {
  fnc_sillybuild_check = compile loadfile "logistics\fnc_sillybuild_check.sqf";
  //hint "sillybuild check compiled";
};

// Populate the building list with occupiable buildings
_objCount = count _objectslist;

if (_objCount > 0) then {

  for "_i" from 0 to (_objCount - 1) do {
    _build = _objectslist select _i;
    
    if (format ["%1",_build buildingPos 0] != "[0,0,0]") then {
      
      _buildingslist set [count _buildingslist,_build];

    } else {
      
      _noposbuildings set [count _noposbuildings,_build];
      
    };
    
  };

  {
    _occupied = _x getvariable ["occupied",false];

    if (!(_occupied)) then {
      
      _buildingsleft set [count _buildingsleft,_x];		
      
    };
    
  } foreach _buildingslist;

  // make group enter random building and occupy the positions

  // building randomly selected and array of positions generated

  if ((count _buildingsleft) >= 1) then {

    _nbuild	= floor (random (count _buildingsleft));
    _localbuilding = _buildingsleft select _nbuild;
    if((typeof _localbuilding) != "Land_hotel") then {
      _localbuilding setvariable ["occupied",true]; 
    };
    

    // Check if building is in array of predefined buildings that i know have issues. if so manaully set the positions to be used.

    _sillyarray = [_localbuilding] call fnc_sillybuild_check;
    _issilly = _sillyarray select 0;
    if (_issilly) then {

      _bposleft = _sillyarray select 1;

    } else {


      _bposleft = [];
      _allbpos = [];

      _pcnt = 0;		 
      _selectedbpos = _localbuilding buildingPos (_pcnt);
      
      
      while {(format ["%1", _localbuilding buildingPos (_pcnt)] != "[0,0,0]")} do {

        if (((_localbuilding buildingPos (_pcnt)) select 2) >= _minheight) then {_bposleft set [count _bposleft, (_pcnt)];} else {if ((_localbuilding iskindof "Land_fortified_nest_big") || (_localbuilding iskindof "Land_Fort_Watchtower") || (_localbuilding iskindof "Land_fortified_nest_small")) then{_bposleft set [count _bposleft, (_pcnt)];};};
        
        
        _pcnt = _pcnt + 1;

      };

    };
    
    // adjust positions for requested capacity as per _capacity var
    _totalPositions = count _bposleft;
    _limitedPositions = ceil ((_totalPositions / 100) * _capacity);
    if (_limitedPositions < 1) then {
      _limitedPositions = 1;
    };
    
    //Handle for a fixed limit in the capacityarray
    if (_maxcap != 0) then {
      if (_limitedPositions > _maxcap) then {
        _limitedPositions = _maxcap;
      };
    };
    
    While {(count _bposleft) > _limitedPositions} do {	
      _rnum = floor (random (count _bposleft));
      _bposleft set [_rnum,-1];
      _bposleft = _bposleft - [-1];
    };
    
    //hint (str(_limitedPositions));

    // units select a position and go, if building fills up a new building is selected and then populated.
    // moveTO doesn't seem to work without a do stop and sleep of 0.1 :s
    {doStop _x;
      sleep 0.01;
    } foreach units _group;

    {if ((count _bposleft) >= 1) then {
        // select random position
        
        
        _buildpos = _bposleft select (floor (random (count _bposleft)));
        _buildpos = _bposleft select ((count _bposleft) - 1); 
        // moveTo or jump to position depending on if warping is true or false
        
        
        
        if (_warping) then {	
          _x setPos (_localbuilding buildingPos _buildpos);                           
          sleep 0.05;
          _x forcespeed 0;
					_x setvariable ["Hz_noMove",true];
					_x setvariable ["Hz_clearingBuilding",true];
          
        } else {
          sleep 0.1;
          _x moveTo (_localbuilding buildingPos _buildpos);
          sleep 0.1;
        };
        _bposleft = _bposleft - [_buildpos];
        
        _poscoords = (_localbuilding buildingPos _buildpos);
        // assign the selected position to the units "homepos" variable so it remembers where he's meant to be
        _x setvariable ["homepos",_buildpos];
            
        
      } else {

        // remove building details of current select building from list of possible buildings 

        _buildingsleft = _buildingsleft - [_localbuilding];
        
        {
          _occupied = _x getvariable ["occupied",false];

          if (_occupied) then {
            
            _buildingsleft = _buildingsleft - [_x];		
            
          };
          
        } foreach _buildingslist;

        // building randomly selected and array of positions generated

        if ((count _buildingsleft) >= 1) then {

          _nbuild	= floor (random (count _buildingsleft));
          _localbuilding = _buildingsleft select _nbuild;
          _localbuilding setvariable ["occupied",true];

          // Check if building is in array of predefined buildings that i know have issues. if so manaully set the positions to be used.

          _sillyarray = [_localbuilding] call fnc_sillybuild_check;
          _issilly = _sillyarray select 0;
          if (_issilly) then {

            _bposleft = _sillyarray select 1;

          } else {


            _bposleft = [];

            _pcnt = 0;		 
            
            while {format ["%1", _localbuilding buildingPos (_pcnt)] != "[0,0,0]" } do {

              _bposleft set [count _bposleft, (_pcnt)];
              _pcnt = _pcnt + 1;

            };

          };
          
          // adjust positions for requested capacity as per _capacity var
          _totalPositions = count _bposleft;
          _limitedPositions = ceil ((_totalPositions / 100) * _capacity);
          if (_limitedPositions < 1) then {
            _limitedPositions = 1;
          };
          
          //Handle for a fixed limit in the c_apacityarray
          if (_maxcap != 0) then {
            if (_limitedPositions > _maxcap) then {
              _limitedPositions = _maxcap;
            };
          };
          
          While {(count _bposleft) > _limitedPositions} do {
            _rnum = floor (random (count _bposleft));
            _bposleft set [_rnum,-1];
            _bposleft = _bposleft - [-1];
          };
          
          //hint (str(_limitedPositions));


          if ((count _bposleft) >= 1) then {
            doStop _x;
            sleep 0.03;

            _buildpos = _bposleft select (floor (random (count _bposleft)));
            if (_warping) then {
              _x setPos (_localbuilding buildingPos _buildpos);
              sleep 0.05;
              _x forcespeed 0;
							_x setvariable ["Hz_noMove",true];
							_x setvariable ["Hz_clearingBuilding",true];
              dostop _x;
            } else {
              sleep 0.1;
              _x moveTo (_localbuilding buildingPos _buildpos);
              sleep 0.1;
            };
            _bposleft = _bposleft - [_buildpos];

            _poscoords = (_localbuilding buildingPos _buildpos);
            _x setvariable ["homepos",_buildpos];
                        
          } else {

            _buildingsleft = _buildingsleft - [_localbuilding];
            
            [_x] join _remainders;

            //[_x] join _patrolgroup;

          };
          
        } else {

          //[_x] join _patrolgroup;
          
          [_x] join _remainders;

        };

        
      };
      

    } foreach units _group;

  } else {

    //{[_x] join _patrolgroup} foreach units _group;

    {[_x] join _remainders;} foreach units _group;

  };

} else {
  
  //{[_x] join _patrolgroup} foreach units _group;

  {[_x] join _remainders;} foreach units _group;

};

/*

_possarray = [];

{

  _possarray set [count _possarray,_x getvariable ["homepos","none"]];

}foreach units _group;

//hint (str(_possarray));

_t = time;

waituntil {sleep 5; ((count units _patrolgroup) > 0) or ((time - _t) > 240)};

if ((count units _patrolgroup) > 0) then {

  _patrolCenter = [];
  if ((leader _patrolgroup) != _unit) then
  {
    hint (str([(leader _patrolgroup),_unit]));
    _patrolCenter = getpos (nearestbuilding (getpos (leader _patrolgroup)))
  }
  else
  {
    hint "no buildings";
    _lPos = getPosATL _unit;
    _lPos set [0,((_lPos select 0) + 5)];
    _patrolCenter = _lPos;
  };

  nul = [leader _patrolgroup,_patrolCenter,_radius,true] execVM "Garrison_fncs\patrol.sqf";

  _t = time;
  _gnumber = 2;

  while {sleep 1;true} do {
  
    waituntil {((count units _patrolgroup) > 4) or ((time - _t) > 120)};
  
    if ((count units _patrolgroup) > 4) then {

      _allunits = units _patrolgroup;
      _gunits = [];

      for "_i" from 1 to 4 do {
      
        _gunit = _allunits select _i;
        _gunits set [(count _gunits),_gunit];
      
      };

      missionnamespace setvariable [format ["group%1%2",_gnumber,name _unit],createGroup _side];
      _newgroup = missionnamespace getvariable (format ["group%1%2",_gnumber,name _unit]);

      _gnumber = _gnumber + 1;

      _gunits join _newgroup;	
  
      nul = [leader _newgroup,_patrolCenter,_radius,true] execVM "Garrison_fncs\patrol.sqf";
    
    };
    
  };

};
    */

sleep 1;

if((count (units _remainders)) > 0) then {
  
  if ((count _noposbuildings) > 0) then {
    
    _AccessibleFound = false;        

    {
      //check if accessible building like fallujah hotel
      if(!isnil "Hz_noposbuildings") then {
        if((toupper typeof _x) in Hz_noposbuildings) then {

          _AccessibleFound = true;  
          
          _BB = boundingbox _x;
          _BC = boundingcenter _x;
          
          // BC is in [x,z,y] format. Swap axes around
          _BC = [(_BC select 0),(_BC select 2),(_BC select 1)];
          _BCworld = _x modeltoworld _BC;
          
          _heightEstimate = abs (((_BB select 1) select 2) - ((_BB select 0) select 2));
          _widthEstimate = abs (((_BB select 1) select 1) - ((_BB select 0) select 1));
          _lengthEstimate = abs (((_BB select 1) select 0) - ((_BB select 0) select 0));
          
          //try to compensate for inaccurate boundingbox
          _halfwidthEstimate = _widthEstimate * 0.4; //80% of original value which is then halved
          _halflengthEstimate = _lengthEstimate * 0.4;        
          
          //_heightEstimate = _heightEstimate * 0.8;
          
          //use BC instead? still overshoots...
          _halfheightEstimate = (_BCworld select 2)*0.5;
          
          //place units
          
          {
            _posx = random _halflengthEstimate;
            _posy = random _halfwidthEstimate;
            _posz = random _halfheightEstimate;
            
            if ((random 1) < 0.5) then {_posx = -_posx;};
            if ((random 1) < 0.5) then {_posy = -_posy;};
            if ((random 1) < 0.5) then {_posz = -_posz;};
            
            _posx = _posx + (_BCworld select 0);
            _posy = _posy + (_BCworld select 1);
            _posz = _posz + (_BCworld select 2);
            
            if (_posz < 0) then {_posz = 0;};
            
            dostop _x;
            _x setposatl [_posx, _posy, _posz];
            _x forcespeed 0;
						_x setvariable ["Hz_noMove",true];
						_x setvariable ["Hz_clearingBuilding",true];
            
          }foreach units _remainders;        
          
        };};
      if (_AccessibleFound) exitwith {};
      
      
    }foreach _noposbuildings;
    
    if (!_AccessibleFound) then {
      
      //otherwise spread them about on rooftops and around buildings?
      
      {  
        //random chance of max 2-3 people on one roof/near one building
      }foreach _noposbuildings;  
      
      //not yet implemented
      {deleteVehicle _x} foreach units _remainders;
            
    };
    

  };            

};


//cover up screw-ups
sleep 3;

_remainders deleteGroupWhenEmpty true;

{if(!alive _x) then {deletevehicle _x} else {_x setdamage 0; if(!isnil "ace_sys_wounds_fnc_RemovePain") then {_x call ace_sys_wounds_fnc_RemovePain;};};}foreach _cleanup;