class D_DBTop10Dialog {
	idd = -1;
	movingEnable = 1;
	onLoad = "uiNamespace setVariable ['D_DBTop10Dialog', param [0]];[param [0]] call bis_fnc_guiEffectTiles;call d_fnc_initdbtop10dialog;d_dbtop10_dialog_open = true";
	onUnLoad = "uiNamespace setVariable ['D_DBTop10Dialog', nil];d_dbtop10_dialog_open = false; d_dbtop10_dialog_open = nil";
	effectTilesAlpha = 0.15;
	class controlsBackground {
		COMMON_BACKGROUND_VIGNETTE
		COMMON_BACKGROUND_TILES
		__DDIALOG_BG($STR_DOM_MISSIONSTRING_1756)
	};
	class controls {
		__CANCELCLOSEB(-1)
		
		class Caption: RscText2 {
			x = 0; y = 0.01;
			w = 1; h = 0.1;
			sizeEx = 0.024;
			colorBackground[] = {1, 1, 1, 0};
			colorText[] = {1, 1, 1, 0.7};
			shadow = 0;
			text = "Name | Playtime | Infkills | Softveckills | Armorkills | Airkills | Deaths | Totalscore | Radiotowerkills | Maintarget Sidemission Kills | Number played on server | Camps captured | Teamkills";
		};
		class Top10LNListbox: RscListNBox {
			idc = 100;
			x = 0; y = 0.12; w = 1; h = 0.9;
			drawSideArrows = 1;
			idcRight = 147;
			idcLeft = 146;
			sizeEx = 0.032;
		};
	};
};
