/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Description:
    Scans the spawn area for possible storages.

    Parameter(s):
    NONE

    Returns:
    NONE
*/

params ["_crate"];

// Dialog controls
private _dialog = findDisplay 758067;
private _ctrlStorage = _dialog displayCtrl 75802;

// Clear the lists
lbClear _ctrlStorage;

// Reset variables
KPCF_nearStorage = [_crate];

private ["_type", "_config", "_index", "_picture"];

// Fill the list
_type = typeOf _crate;
_config = [_type] call KPCF_fnc_getConfigPath;
_index = _ctrlStorage lbAdd format ["%1m - %2", round (KPCF_activeSpawn distance2D _crate), getText (configFile >> _config >> _type >> "displayName")];
_picture = getText (configFile >> _config >> _type >> "picture");
if (_picture isEqualTo "pictureThing") then {
		_ctrlStorage lbSetPicture [_index, "KP-Cratefiller\KPCF\img\icon_help.paa"];
} else {
		_ctrlStorage lbSetPicture [_index, _picture];
};
