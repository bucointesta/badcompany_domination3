// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_firearty.sqf"
#include "..\..\..\x_setup.sqf"

if (isDedicated) exitWith {};

if !(d_ari_available) exitWith {[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_149")};

disableSerialization;

private _lbctrl = (uiNamespace getVariable "d_ArtilleryDialog2") displayCtrl 1000;
private _idx = lbCurSel _lbctrl;
if (_idx == -1) exitWith {};

private _arele = d_cur_art_marker_ar select (_lbctrl lbValue _idx);
private _curmar_pos = markerPos (_arele select 0);
__TRACE_2("","_arele","_curmar_pos")

private _no = [];
private _ammoconf = configFile>>"CfgAmmo">>getText(configFile>>"CfgMagazines">>(_arele select 2)>>"ammo");

if (getText(_ammoconf>>"effectFlare") != "CounterMeasureFlare" && {getText(_ammoconf>>"submunitionAmmo") != "SmokeShellArty"}) then {
	private _man_types = [];
	{
		_man_types pushBack (switch (_x) do {
			case "WEST": {"SoldierWB"};
			case "EAST": {"SoldierEB"};
			case "GUER": {"SoldierGB"};
			default {"SoldierWB"};
		});
		false
	} count d_own_sides;
	_no = _curmar_pos nearEntities [_man_types, 20];
};

if !(_no isEqualTo []) exitWith {
	[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_151");
};

if (d_with_ranked && {d_ranked_a select 2 > 0}) then {[player, (d_ranked_a select 2) * -1] remoteExecCall ["addScore", 2]};
player kbTell [d_kb_logic1, d_kb_topic_side_arti, "ArtilleryRequest", ["1", "", getText(configFile>>"CfgMagazines">>(_arele select 2)>>"displayname"), []], ["2", "", str (_arele select 3), []], ["3", "", mapGridPosition _curmar_pos, []], d_kbtel_chan];
[_arele select 2, _arele select 3, str player, _arele select 0] remoteExec ["d_fnc_arifire", 2];
d_arti_did_fire = true;
