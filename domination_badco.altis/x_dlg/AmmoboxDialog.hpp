class d_AmmoboxDialog {
	
	idd = -1;
	movingEnable = 1;
	onLoad = "";
	onUnLoad = "";
	effectTilesAlpha = 0.15;
	class controlsBackground {
		COMMON_BACKGROUND_VIGNETTE
		COMMON_BACKGROUND_TILES
		__DDIALOG_BG($STR_DOM_MISSIONSTRING_1322)
	};
	
	class controls {
		
			class VecPicture: D_RscPicture {
				idc = 44444;
				x=0.36; y=0.11; w=0.15; h=0.1;
				text="";
				sizeEx = 256;
			};
			
			class rtjyhrtj: RscButton
			{
				idc = 1600;
				text = "Load Default (Pre-filled) Box"; //--- ToDo: Localize;
				x = 0.15;
				y = 0.22;
				w = 0.7;
				h = 0.18;
				colorText[] = {0.84,0.84,0,1};
				colorBackground[] = {0.1,0.1,0.1,0.1};
				colorBackgroundActive[] = {1,1,1,0.3};
				action = "closeDialog 0;";
			};
			class ccbvbc: RscButton
			{
				idc = 1601;
				text = "Load Custom (Empty) Box"; //--- ToDo: Localize;
				x = 0.15;
				y = 0.54;
				w = 0.7;
				h = 0.18;
				colorText[] = {1,1,1,1};
				colorBackground[] = {0.1,0.1,0.1,0.1};
				colorBackgroundActive[] = {1,1,1,0.3};
				action = "(vehicle player) setVariable ['d_ammobox_isEmpty', true, true]; closeDialog 0;";
			};
		
	};
	
};

