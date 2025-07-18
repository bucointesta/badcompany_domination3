@echo off


set mapName=Takistan
set mapExtension=takistan


set mapName=Chernarus
set mapExtension=chernarus
























if exist maps\%mapName%\mission.sqm (

	echo Deploying domination_badco_rhs.%mapExtension%...
	
	if exist __DEPLOYMENT (
		rmdir __DEPLOYMENT /s /q
	)
	
	mkdir __DEPLOYMENT
	mkdir __DEPLOYMENT\domination_badco_rhs.%mapExtension%
	echo Copying files
	xcopy "domination_badco.altis" "__DEPLOYMENT\domination_badco_rhs.%mapExtension%" /s /e /q
	echo Copying map files
	xcopy "maps\%mapName%" "__DEPLOYMENT\domination_badco_rhs.%mapExtension%" /s /e /q
	
	echo Done!
	pause
	
) else (

	echo Error! Mission file for %mapName% doesn't exist!
	pause
)