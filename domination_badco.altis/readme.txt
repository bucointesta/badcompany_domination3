!!!!!!!!!BESIDE THE NORMAL license.txt FILE READ ALSO THE license_additional.txt FILE!!!!!!!!!!!!

While some things may basically be and look the same, all scripts were touched and a lot of code has changed.
Also all code regarding custom made third party content was removed (for example ACRE).

#############################################################################################################

Changelogs

3.74
- Fixed: AI CAS plane gets no longer deleted immediately when it can not move anymore (destroyed, pilot dead, etc)
- Fixed: Dying while parachuting could result in constant radial blurr on screen (BI bug)
- Changed: Check if player is medic is no longer done via var name but with getUnitTrait "Medic" (also true for revive when only medics can revive)
- Fixed: Enemy AI vehicles should no longer explode during creation when something goes wrong (wrong spot because of setpos command)
- Fixed: Additional respawn points did not work at all (d_additional_respawn_points)
- Changed: If SQL database is available and auto save is enabled also save progress to database after sidemission is finished (till now only after main target got cleared)
- Fixed: Major problem with the algorithm which created the main target positions. It could pick up the wrong target if one werent a city but a village (instead of Aggelochori Kavala was chosen)
- More optimizations

3.73
- Fixed: Don't draw MHQ lettering when a MHQ is in the air
- Changed: AI in static weapons has no longer skill 1 but random skill
- Fixed: Two Chernarus sidemissions still had an old variable name (sm 2 and 19)
- Fixed: One steal plane sidemission in the IFA3 version did not spawn a plane

3.72
- Fixed: Non existing macro caused script error in sidemission 22 in the Chernarus version
- Fixed: CAS did not work at all in the IFA3 version
- Fixed: Missing engineer unit in the IFA3 version added again
- Fixed: Various Winter Chernarus problems because of missing mapSize config entry in the Winter Chernarus config
- Fixed: Major bug in updating the sql database when updating an existing mission progress (invalid number of inputs)

3.71
- Fixed: Parajump at base did not work in the IFA3 version (vehicles without cargo positions were not supported)
- Fixed: Script error in airai script
- Fixed: Some Team Bravo units still had Team Alpha in role description in the IFA3 version

3.70
ATTENTION: mission.sqm files of ALL versions were changed!!!!

- Added: IFA3Lite version
- Changed: It is now possible to have more than one side on the player side in the normal versions (for example WEST and GUER groups)
- Added: Dynamic Simulation (it's possible to disable it in server parameters, default is on)
- Added: External database support (extDB3) including saving mission progress (and autosave and autoload also available, check initServer.sqf)
- Fixed: Correct "is swimming" check for leader in teleport/revive respawn
- Fixed: Air AI units did not move to a new main target
- Fixed: Uncon Draw3D was using player position instead of positionCameraToWorld [0,0,0]
- Fixed: Two common sidemission files were still using outdated variable names so that the missions didn't end (Chernarus only) and sidetrafo was completely missing in cfgfunctions file
- Fixed: Wrong path to particle resource in winter weather script
- Fixed: Don't add a camo net when a player deploys a MHQ which is kindOf Air (if camo net is enabled)
- Changed: You can now disable main target bonus vehicles or side mission bonus vehicles or both together in the server lobby
- Fixed: Disabled near own side soldier check for artillery targets in the CUP versions as it always reported friendlies even though no own soldiers were near the target (bug in CUP?)
- Fixed: Group could already be nil in handleDisconnect before beeing used in remoteExec
- Changed: Ships/boats can now also only be entered as driver with a specific rank in the ranked version (can be changed in x_initcommon.sqf, d_ranked_a select 8)
- Changed: In the ranked version players can now also enter vehicles in a cargo position even if their rank doesn't allow them to access other positions
- Added: A kbTell message (sidechat) is now displayed when a MHQ gets destroyed
- Changed: In the ranked version you need rank Corporal now to enter a static weapon (MG, GMG, mortar)
- Added: The main target respawn groups (those are not the aerial reinforcements brought in by chopper or plane) can now be disabled in the lobby
- Fixed: Issue where destroyed trains and trafo stations did not trigger end of sidemission (Chernarus version) (hopefully fixed)
- Changed: Domination now uses the new engine group cleaning introduced in A3 1.67 and no longer a FSM
- Added: Main target marker alpha value can now be changed in fn_preinit with d_e_marker_color_alpha, it's now 0.8 instead of 1
- Fixed: n's are back in hint/sidechat messages :)
- Changed: If "MT Tower Satchels only" is set to "No" a main target radio tower can be destroyed by any weapon now (and not only by satchels)
- Changed: If "no parachute jump flags" is enabled then "parachute from base" is no longer disabled
- Fixed: Air AI units should no longer spawn near main targets if a main target is close to the border of a map
- Changed: Relaxed streaming, removed black screen when Streaming friendly UI was enabled and message which showed up every now and then on the bottom of the screen. 
  Read, streaming and Youtube video upload now allowed BUT only it is not monetized (the non-commercial license is still valid that virtually 99,999999% of all the other user content made for A3 uses too)
- Fixed: Camps at main targets now really do no longer spawn close to each other and the radio tower (if there is enough space at a main target)
- Optimized: Ambient life (rabbits, snakes, etc) is now disabled!
- Fixed: In ranked mode it is no longer possible to load Virtual Arsenal loadouts with CTRL-O (which was some kind of cheating)
- Changed: Updated Spanish and Portuguese translation by Linux
- Changed: CAS planes now use machinegun and rockets
- Fixed: Stratis version was using a CUP Takistan sidemission breaking the sidemission system
- Added: It is now also possible to have a normal vehicle wreck transport (no choppers available in WW2 mod IFA3). Simply drive with the wreck vehicle to the wreck, an action menu to load the wreck should appear!
- Added: Spectate other players from flag at base
- Fixed: Side mission 17 in the CUP Chernarus version had a wrong variable reference (_officer instead of d_soldier_officer)
- Fuxed: If a player blocked artullery and disconnected artillery stayed blocked
- Fixed: Admin dialog did not work in a hosted environment
- Fixed: d_WreckMaxRepair for bonus vehicles was not applied to bonus vehicles in the non TT version
- Added: A loged in admin or host can now end a side mission manually (admin dialog)
- Fixed: Isle patrols should now spawn at least 2000m away from players
- Added: Japanese translation by aki_hat
- Added; Korean translation by Axion
- Fixed: Ammo load at base did not work for CRV in opfor Altis version
- Added: 3D text over MHQ
- Fixed: Players should no longer die when respawning at base (in revive mode)
- Fixed: Replaced the IED factory main target mission building with a correct factory building
- Changed: Reduced size of stringtable.xml
- Added: You can now press M for map dialog, N for nightvision and P for players dialog in revive spectating dialog
- More optimizations

KNOWN ISSUES:
- In the IFA3Lite version the artillery on your own side won't fire when a player requested an arty strike.
  Neither doArtilleryFire nor commandArtilleryFire work with the either IFA3 mortars or the BM21...

(There are no versions between 3.64 and 3.70)

3.64e
- Fixed: Yet another script error in spectating scripts :(

3.64d
- Fixed: Script error in spectating scripts (wrong version chosen where lbSetColor index is still missing)

3.64c
- Changed: Better check for nightvision goggles (finds third party NV goggles too)
- Changed: Turn on NVgoogles after revive (if nvg was on before)
- Fixed: Artillery script was broken (script error)

3.64b
- Fixed: Changeleader was messed up (calling d_fnc instead of xr_fnc, etc)
- Fixed: Target clear still broken
- Fixed: Main target mission object was not deleted when it wasn't a unit

3.64a
- Fixed: Possible fix for ace treatment problem
- Fixed: Possible fix for too much Error: No Unit names (should not happen anymore)
- Fixed: Wrong unit variable name in handleDisconnect script
- Fixed: UI resources were broken in 3.64

3.64
- Fixed: Some units where not available for Zeus (players, recruited AI in the AI version, etc)
- Added: In the AI version (non ranked) a player can use Virtual Arsenal for AI units too (action menu entry for each unit; player has to be near the unit, 3m, only the player who created the unit has the action menu entry)
- Fixed: Player names over head were not shown in static weapons
- Fixed: When a player selected respawn or teleport at/to squad leader and squad leader was in a vehicle without empty cargo positions the player was moved exactly to the vehicle position instead of behind it
- Changed: Show group members in revive player list in green color
- Fixed: If a player teleported, respawned or did a parajump in the AI version dead player AI units were moved to the new player position too
- More optimizations

3.63
ATTENTION: mission.sqm files of ALL versions were changed!!!!

- Changed: Replaced fired eventhandler for player with new firedMan EH available in 1.66
- Changed: Set fatigue to 0 when player respawns
- Fixed: createUnit command in A3 ignores the group parameter completely since a few patches and adds the unit to the units config side instead to the provided group (bug in A3?)
- Fixed: Wrong detected by sides in the triggers to activate enemy AI paratroopers in the TT version
- Optimized: Use new 1.66 parameter for nearestTerrainObjects to search in 2D and not 3D
- Fixed: Side mission 42 in the Chernarus version was missing a semicolon
- Changed: Don't allways fill all cargo positions in enemy APCs with AI, choose a random number to save performance
- Fixed: Side mission 19 (trains) was broken in the Chernarus version
- Fixed: Side mission 15 in the Chernarus version still had a not existing macro
- Added: Zeus suppport (not available in the TT versions).
	     Please note that for security reasons you have to edit the mission and place a Game Master module and add A3 player UID (I've placed one in every mission file with my own UID to show you how it works,
		 you have to place one Game Master module per player who is allowed to use Zeus with the UID of that player)
- Added: Simple sandstorm script by Lelik (enabled by default on Altis, Stratis, Sahrani and Takistan). Can be enabled/disabled in the server lobby (parameters)

3.62
ATTENTION: mission.sqm files of ALL versions were changed!!!!

- Fixed: The headless client unit was missing in the CUP Sahrani version
- Fixed: Respawn at squad leader was available when the player was the only unit in a group
- Added: New server parameter "Armor at side missions:" (options Normal or None), in addition with "Armor at main targets:" set to none you now have the option to play without any armor on the AI enemy side
- Changed: Send player position to the server too to fix wrong air taxi landing position
- Fixed: Air taxi was not set to available again in some cases
- Optimized: Using inArea scripting command to check position of lift choppers near lift objects now
- Fixed: Island patrol groups did not respawn when the crew jumped out of a damaged vehicle; crews now stay in damaged vehicles and respawn is triggered when one group vehicle can't move anymore
- Fixed: The number of tracked armored vehicles for the island patrol now depends on the selection in "Armor at main targets:" server lobby parameter
- Fixed: Some controls (player list and map) in the spectating dialog were not hidden immediately but were visible for a short time when the dialog opened for the first time
- Changed: Better way to select unit under mouse cursor in revive spectating dialog (with lineintersects)
- Fixed: medikit_ca.paa file was removed from ui_f pbo in Arma 3 1.66 (why?), so a new icon was necessary for uncon players (*)
- Fixed: Wrong creation distance for vehicles in convoy sidemission
- Changed: Convoy sidemissions now use a vehicle distance of 20 meters (new command setConvoySeparation)
- Changed: Sidemission convoys now only have wheeled vehicles
- Fixed: Wrong object placed near spawn in CUP Sahrani version
- Changed: Reduced AI group respawn time at main targets (still depends on player numbers, higher player numbers = shorter time between respawns)
- Fixed: UAV invisible crews no longer leave UAVs
- Fixed: Wrong calculation (wrong number) for reinforcement AI choppers over main targets
- Changed: Reinforcement choppers (for para troopers) now have a waypoint about 1500m behind a main target so that they don't do a full stop over a main target anymore
			(why oh why BI have you changed that behaviour, if the next waypoint for AI is another move waypoint and no timeouts involved then let them fly and don't make them virtually full stop at each waypoint)
- Fixed: Don't allow respawn at squad leader if squad leader is swimming
- Changed: You can now also respawn or teleport in a vehicle cargo position if respawn at squad leader is enabled and the squad leader is in a vehicle with empty cargo positions
- Fixed: Jump flags at main targets did spawn in buildings when main target was cleared
- Fixed: If a player who drags another player leaves the server, the dragged player could get stuck in dragging animation
- Added: Winter Chernarus version ( http://www.armaholic.com/page.php?id=29752 )
- Added: Winter weather (light snow, only enabled in the Winter Chernarus version by default)
- Added: Icons to revive spectating player list
- Added: ACE support, if ACE is loaded as mod on the server, Domination revive gets disabled and Dom player handleDamage eventhandler removed (to use ACE medical system; scripts updated to check if a player is ace_isunconscious)
- Fixed: Sometimes if a player was kicked immediately a remoteExec with a nil group was executed
- Fixed: AI revive was enabled even when Dom revive was disabled
- Fixed: Two Draw3D eventhandlers were drawing playernames above head when player was in revive spectating
- Fixed: Bonus vehicles should no longer explode when they are created and all possible positions are already filled with other bonus vehicles
- Changed: Replaced A3 Nato units and vehicles with CUP US Army/BAF units and vehicles in the Takistan version
- Changed: Replaced A3 Nato units and vehicles with CUP US Marine Corps/BAF units and vehicles in the Chernarus version
- Changed: Replaced A3 Nato units and vehicles with CUP US Army units and vehicles in the Sahrani version
- Fixed: Added missing CUP vehicles for heli lift
- Optimized: Only search once in an array of strings for the heli lift types to find out if a vehicle is liftable or not
- Added: T90 to CUP Chernarus version
- Fixed: When the AI version is enabled the player does recruit CUP AI units now instead of A3 AI units
- Fixed: Use correct male CfgEntities speakers in CUP versions
- Added: Enemy AI wheeled and tracked APCs now have additional infantry units in the cargo seats which get unloaded in combat
- Fixed: Counterattack (main target) was spawning armored vehicles when armor was completely disabled
- Changed: If old rep engineer is enabled update fuel and damage in every iteration of the loop instead of just at the end
- Fixed: Main target enemy AI paratroopers were not added to main target cleanup routine
- Fixed: The normal One Team version code should now also support independent player side (and not only blufor and opfor; at least I hope it works :P)
- Changed: Replaced main target paratrooper choppers with Apex VTOL vehicles in the ALTIS, STRATIS and TANOA versions; CUP Sahrani version: Mi8 SLA, CUP Chernarus version: Mi6, CUP Takistan version: AN2 TKA
- Fixed: Some dialogs were not initialized in dialog onLoad event leading to controls not being immediately invisible
- Changed: Replaced some objects with simple objects (see https://community.bistudio.com/wiki/createSimpleObject)
- Fixed: Independent FIA CfgGroups no longer exist (at least in 1.66, why @BI?) resulting in empty allmen groups in the TT version
- Changed: Deploying an MHQ is now possible with other entities on board (players or AI). They get kicked out of the vehicle now.
- Fixed: Secondary main target mission object was not deleted in main target cleanup routine (non CAManBase objects)
- Changed: Vehicle reload script now also restores ammo, repair and fuel cargo (if a vehicles has the transport capacity; done without messages)
- Changed: Global and side channel voice disabled by default now (check disableChannels in description.ext to change it)
- Changed: Using internal A3 engine corpse and wreck manager now to remove dead bodies and destroyed vehicles
- Fixed: Null divisor script error in mando chute script
- Fixed: Air dropped boxes were never removed, now they get deleted after 30 minutes
- Changed: Nearby repair truck no longer needed for an engineer to unflip a vehicle (only toolkit)
- Fixed: Script error when AI was enabled causing AI not to be moved to the player position
- Fixed: It could happen that ammo boxes with virtual arsenal got created before the variables were inited (causing a script error)
- More optimizations

3.61
- Fixed: In the teleport and revive respawn dialog the position marker of MHQs moving were not updated (did not influence correct teleport or respawn position)
- Fixed: Better handling of who is group leader internally (when changing groups with Squad dialog and at mission joining)
- Fixed: Calling in an airtaxi (in the AI version) could block the Domination user menu
- Fixed: In a prisoner side mission the mission timeout now gets reset to 2400 seconds if a player has rescued the prisoners
- Fixed: Air taxi script broke when a player who called in an air taxi left the mission (AI version only)
- Fixed: Virtual spectator clients did start client scripts
- Fixed: Air AI could stop moving/patrolling over the AO
- Changed: Drawing names of player in 3D world in revive spectating is now done by Draw3D eventhandler
- Changed: Replaced the lift and wreck choppers with Hurons in the Altis Blufor version
- Changed: In the non Tanoa versions players can now also create an unarmed Prowler/Qilin beside an ATV at a MHQ
- Changed: Players can no longer call in CAS into the base
- Plus some more changes between 3.60 and 3.61 which I forgot to add to the changelog

3.60
- Fixed: 3D player name on screen did draw in the wrong height when a player was above the ground
- Fixed: Revive uncon near player check (including informing other players) gets called every minute now instead of only once
- Added: Short message in revive spectating when another player starts to revive you
- Fixed: GPS map player icon drawing
- Fixed: Finally sorted out (oh the irony) the sort issues in the revive spectating dialog player listbox once and for all (why didn't anybody tell me that there is a lbSortByValue command :))
- Fixed: Don't show (Medic) extension in the AI or With AI features versions where everybody is a medic
- Added: Show player name in revive dialog when mouse hovers over player unit
- Added: You can now simply click on another unit in 3D world in revive spectating to switch to it
- Fixed: Sidemissions where you had to deactivate mines were broken when a headless client was running
- Fixed: CAS was already available again after 5 seconds and not after 5 minutes

3.59
- Fixed: Player list in revive spectating dialog was sorted wrong
- Fixed: Nearby player caption was shown in spectating dialog when player had no lifes left
- Fixed: Players in nearby vehicles did not get informed about an uncon player
- Changed: Added medic and engineer traits for all players in the AI and with AI features versions and explosiveSpecialist trait for all players in all other versions
- Fixed: Because of some internal changes server side saved player gear was not restored on clients after reconnect

3.58
- Fixed: Wrong object reference in revive uncon script (string instead of object)
- Fixed: There were still issues with the respawn dialog (spectating that is)
- Changed: Nearby players get a message when a player dies and can be revived, including relative direction (40 m)
- Changed: Show distance to other players in revive spectating player listbox and if another player is uncon 
- Changed: Players can't kill player AI units in the base anymore (AI version, only true if the player which the AI belongs to is also in the base, for performance reasons)
- Changed: Moved PiP resource in chopper lift hud below GPS map position, removed border
- Fixed: Sometimes after respawn some game radial blurr effect was still there (died while free fall before opening a chute for example), gets reset at respawn now
- Added: Ear plugs, can be enabled and disabled via Commanding menu (press TeamSwitch key, default is U key for TeamSwitch to open the Domination menu)
- Fixed: Wrong "you were revived by" message when an AI medic revives a player
- More optimizations

3.57
- Fixed: More issues with respawn dialog (it was completely broken sometimes). All issues should be finally fixed now!
- Changed: Wreck repair times
- Added: Teleport to Squad Leader

3.56
- Changed: Set attached object mass before and after rope create in heli lift and not just after rope create
- Fixed: In the AI version air taxi was not blocked immediately for other players so more than one player could call in an air taxi
- Optimized: Save respawn gear only when player dies
- Changed: Player names over head now default instead of cursor target
- Changed: Replaced standard A3 OPFOR units with the correct ones for the CUP Chernarus, CUP Sahrani and CUP Takistan versions
- Fixed: Small issues with respawn dialog
- Fixed: Camps (to capture) should not spawn close to each other anymore (if there are enough possible places available at a main target)
- Changed: When a wreck gets put on the wreck repair point the seconds it will take to rebuild the vehicle are also displayed (sidechat once and the 3D text over the wreck point will display the sconds too)
- Added: Portuguese translation by Linux �
- Fixed: Problem with including arrays for the TT versions
- More optimizations

3.55
- Changed: In the TT version a main target ends once one side has captured all camps and the radio tower is destroyed, no check for how many AI enemy units and vehicles are still at the AO
           Can also be enabled in the normal version (lobby server parameter) but not in the TT version as it is default there
- Changed: Show sidemission index number in ShowStatus dialog
- Fixed: Enemy main target respawn camp positon was suddenly not behind main targets anymore
- Fixed: Sometimes the enemy respawn camp (thus a main target) was not created because of a missing dist return value in a function needed for it (game breaker)
- More optimizations

3.54
- Fixed: fn_teleupdate_dlg.sqf did throw an undefined variable error when a player teleported

3.53
- Added: Stratis Blufor version
- Fixed: Possible workaround for (editor placed) base artillery vehicles falling through the map
- Fixed: Switched back to attachTo for wreck heli lifting (normal non wreck lifting still uses game slingload)
- Changed: In the Tanoa version squad leaders air drop an unarmed Prowler/Qilin now instead of a Hunter/Ifrit
- Changed: In the Tanoa version players can create an unarmed Prowler/Qilin beside an ATV at a MHQ
- Changed: Air drops (called by squad leaders) now drop exactly where the player placed the drop marker
- Changed: Set overcast to zero if weather is disabled
- Changed: Removed 6Rnd_155mm_Mo_AT_mine and 6Rnd_155mm_Mo_mine from artillery (dialog)
- Changed: Replaced disableAI "MOVE" with dsiableAI "PATH" (introduced in A3 1.61)
- Fixed: Script error in fn_vec_hudsp.sqf
- Fixed: Possible fix for a script error in fn_chop_hudsp.sqf
- Changed: Replaced scripting solution to check which enemy units got killed by artillery or CAS strike with new setShotParents command
- Added: In respawn dialog better markers for respawn position (like in the BI respawn dialog) plus current selected one animates
- Fixed: Respawn button in respawn dialog was often available even though respawn points were blocked/unavailable
- Added: If a player leaves a running mission and joins the same mission again he/she will have the same gear loadout as before
- Fixed: Killed message for main target sidemission was gone in the TT version
- Fixed: Enemy AI artillery observers did call in artillery strikes even though their own inf was at the strike position in the TT version
- More optimizations

3.52
ATTENTION: Tanoa version mission.sqm file has changed!
ATTENTION: Tanoa TT version mission.sqm file has changed!
ATTENTION: Chernarus version mission.sqm file has changed!

- Changed: Better random positions especially on Tanoa (for example spawn and waypoint positions for infantry units in forrests/jungle)
- Changed: Main target clear now happens also when there is still one enemy AI car or tank left
- Fixed: Arty operator did not receive arty messages from already firing arty anymore when he/she died
- Fixed: Fog was coming even if it was completely disabled (seems to be a bug in A3)
- Fixed: Removed not working CfgGroups from preinit
- Fixed: For whatever reason the CH-53 chopper suddenly was half in the ground in the Chernarus CUP version (in the editor already)
- Fixed: Added missing Opfor vehicles for heli lift in the TT version
- Changed: Replaced all base vehicles, player units and CSAT AI units and vehicles with Apex T versions in the normal and TT version
- Fixed: Some choppers at base were placed above the ground in the normal Tanoa version
- Added: Complete Spanish translation by Brigada_ESP
- Changed: Removed loiter waypoints for airai introduced in 3.43 again (air AI units did not attack anymore)
- Fixed: Convoy sidemission in TT version was broken (did not end)
- Fixed: In the TT version the wrong bonus vehicles got spawned (opfor vehicles for blufor and vice versa)
- Fixed: Blufor helilift types were added to opfor choppers in the TT version
- Fixed: In the ranked TT version blufor players where getting the same gear as the opfor players (player object not initialized while checking for player side)
- Changed: Servicing a drone on chopper service/vehicle service now also writes a message on the screen
- Fixed: Virtual Aresenal 3D text was visible for para jumpers even when they were far away (distance2D check instead just distance)
- Fixed: In the Tanoa AI version recruited AI did not wear tropical uniforms
- Changed: Replaced all TahomaB fonts with RobotoCondensed
- Fixed: Wrong KBTell message in the TT version for main target missions
- Fixed: Opposite team got the message that a MHQ is too close to the main target too (TT version)
- Fixed: The team which did not resolve the sidemission got the "sidemission resolved" hint in the TT version
- Added: Missing localization for sidemission resolved
- Changed: Disabling radio already in respawn eh (revive) and disabling sound till uncon script runs at respawn
- Changed: Increased AI skill
- Fixed: Missing kbTell for the TT version in fn_sm_up (announcing side mission in chat)
- Fixed: fn_checkmthardtarget and fn_mtmtargetkilled were using the unit instead of the side of the unit in the TT version
- Fixed: Typo in fn_preinit.sqf (it's ParaCombatGroup not ParaConbatGroup)
- Fixed: TT version medics were missing in x revive init when only medics can revive was enabled
- Fixed: Script error in fn_target_clear_client.sqf (undefined variable)
- Fixed: Missing distance check for second wreck repair point in the TT version (fn_wreckmarker2.sqf)
- Added: Close air support (CAS), available for Squad Leaders (works like artillery target marking with LD, but the CAS is available immediately, 10 minutes between two CAS strikes, rockets only).
- Fixed: Removed XMIT from bikb config, was causing RPT entries
- Fixed: Sometimes the flag spawned inside a building in the capture the flag side mission 31 on Tanoa
- Changed: In the TT version MT killpoints are now also added for artillery and CAS strikes
- Changed: Player UID gets stored only once now in the player store on the server
- Changed: Default AI skill settings are now "Normal" and not "Low"
- Fixed: Possible nil variable error in gear handling
- Changed: Reduced chance to get fog from 30 to 10 percent
- Optimized: 3D text over player heads (removed visibility check)
- Fixed: No check if player was at delivery point in the deliver side missions if ranked was enabled
- Added: Adding additional static respawn points is now available via d_additional_respawn_points variable in x_init\fn_preinit.sqf
- Fixed: Outdated stringtable entries
- Fixed: Time multiplier reduced to max 120 (the engine doesn't allow more anyway)
- Fixed: Wrong number of maintargets got created by create random main targets function
- More optimizations

3.51
Internal developement version, see 3.52 changelog

3.50
ATTENTION: Tanoa TT version mission.sqm file has changed!

- Addded: Parameter to disable fog when the internal weather system is on
- Fixed: Some blufor markers did not get deleted for the opfor side in the Tanoa TT version (wrong marker names in mission.sqm file)
- Fixed: Headless Client was not working anymore. Somehow remoteExec lost the ability to use a HC as target
- Changed: Respawning at base or at a MHQ gives you the complete Arsenal chosen weapons and magazine layout back
- Changed: Renamed SQL in revive respawn dialog to Squad Leader
- Fixed: Dropping an ammo box from a vehicle did create the Virtual Arsenal 3D text for the oponent team too in the TT version
- Changed: Different progress icon for revive hold action
- Fixed: In the Tanoa TT version the respawn marker for the opfor side had a wrong name thus the ofpor players were teleported into the sea

3.49
- Fixed: Marked artillery targets were visible for the opponent team in the TT version
- Fixed: Ofpor arty operator did not see artillery messages in the TT version
- Fixed: Oponent team in the TT version did see specific artillery messages of the other team (like artillery available again in a few minutes)
- Fixed: Opening the artillery dialog as a blufor player blocked opening the artillery dialog for opfor players too
- Fixed: When the independent AI enemy side in the TT version took a camp from blufor again the flag turned red instead of green (a little bit confusing that was)
- Changed: Enabled parajump flags at main targets in the TT version
- Fixed: Some kbTell messages were broadcasted globally instead of just for one side in the TT version
- Changed: Added an enemy specops group to each camp at the main target to defend them (similar to radio tower at main target)

3.48
- Added: Tanoa TT version
- Fixed: Added missing getflatarea function

3.47
- Fixed: Item STR_DOM_MISSIONSTRING_1705 listed twice
- Fixed: Typo in Tanoa version (Lihnhaven instead of Lijnhaven)
- Fixed: Dropping a box a second time from a vehicle resulted in 3D text over box not being drawn
- Fixed: Loaded boxes were not removed from the 3D draw array (memory leak)

3.46
ATTENTION: Altis TT version mission.sqm file has changed!

- Fixed: Wrong points for Captain in the TT version (were the same as for Seargeant). Resulted in an endless loop between getting promoted to Seargent and Captain
- Changed: Simulation is no longer disabled for dead AI units so one can pick up ammo and weapons from dead AI units again!
- Fixed: It was possible to respawn at squad leader when the squad leader was uncon or dead or even in a vehicle
- Fixed: Vehicles created at MHQ stay longer again
- Fixed: Yet another fix for the Tanoa time problem. Default mission start on Tanoa is now 7 am and not 5 am (was still pitch black night at 5)
- Changed: Reduced wait time to drop or load an ammbox from/to a MHQ to 20 second
- Added: Check in the TT version so that the Parajump dialog does not accept the enemy base area as jump target

3.45
- Added: Respawn at squad leader (only available when revive is used, not available for teleport from base)
- Changed: Medics can now revive faster than normal units
- Fixed: Player received two revive messages when he revived another player
- Fixed: Uncon 3D draw eventhandler for marking uncon units were drawing the player name on the ground instead above the player when the player died in the first floor for example
- Fixed: In the TT version uncon map markers got deleted for blufor side for own units (probably the same on the opfor side)
- Fixed: Markers of uncon units of the opposing side were not removed for JIP players in the TT version
- Fixed: Chopper (lift) hud script was broken in the TT version (wrong variable for accessing the object to lift)
- Changed: Reduced time to spawn a vehicle at MHQ from 5 minutes to 1 minute
- Fixed: Wrong start time for Tanoa version (mission.sqm file time was set to 12 noon instead 12 midnight)

3.44
- Fixed: Revive drag action menu was missing (whoever removed it, I'll find you!)
- Fixed: Nasty respawn in the air bug at Tanoa base (I know who introduced it and I know where your house lives)
- Changed: Reduced mass of heavy vehicles for chopper lifting even more
- Changed: Parajump wait time at base removed from 30 minutes to 0 (time between two jumps from base)

3.43
ATTENTION: Altis version mission.sqm file has changed!

- Added: Tanoa Blufor version
- Added: Altis Opfor version
- Fixed: Wrong isEqualTo scalar check for array in fn_target_clear.sqf
- Changed: Air AI script uses loiter waypoint now which seems to be finally working in combination with flyinheight
- Fixed: Next target on client could be created before d_current_seize was initialized (script error) depending on join time
- Fixed: When TI mode was used in SAT view (MHQ) it stayed on even in revive camera
- Fixed: Side mission tasks get now removed once a side mission is done
- Fixed: Using pushBack with remoteExec does not work very well
- Fixed: Player was not moved back into revive uncon animation after waterfix was running (prevents uncon players from lying on the ground of the sea, moves him to the shore)
- Fixed: Revive waterfix (see above) removed the black screen (should stay till waterfix is done)
- Fixed: Artillery targets can now be marked with any Laserdesignator not just the default vanilla one
- Fixed: Typo in fn_killedsmtargetnormal.sqf
- Changed: Made handling who killed a target of a side mission more robust for the TT version
- Added: New deliver and mines sidemissions by Lelik (only available in the Altis non TT version)
- Changed: Domination revive uses new APEX action menu now!
- Changed: If a lifted vehicle dropped into the sea it did not respawn
- Added: Even more naked women
- And of course more optimizations

3.42
- Hotfix for the hotfix for the hotfix: nearestTerrainObjects sort parameter does not yet exist in 1.60... 

3.41
- Workaround: CUP versions were broken due to an addon problem. The headless client entity gets created even though there is no hc connected. Disabled for CUP versions to make them work again.
- Changed: Moved outer air respawn point a little bit more away from the map sides
- Fixed: Script for adding player score on the server was accidentally using a client side variable (only valid for the ranked version)
- Fixed: Admin lock was broken, missing server lock function in CfgFunctions
- Fixed: A player was still bleeding when healing at a mash
- Fixed: RespawnGroups FSM ended when radio tower was killed and not when the main target was done
- More optimizations

3.40
- Added: Support for hosted environment (might still be a little bit buggy, please report)
- Added: Task for side missions
- Fixed: Arrest side missions were broken due to a logic error (between my ears)
- Changed: Better check which team won a radio tower sidemission in the TT version
- Fixed: Added player ASL position instead of default positioin to playSound3D parameters in revive
- More optimizations

3.39
- Changed: Use setWaypointForceBehaviour for specific AI groups
- Fixed: Wrong topic side and logic for kbTell in server artillery script
- Fixed: Vehicle creation should not result in vehicles falling over anymore
- Fixed: Arrest side missions did not work at all in the TT version
- Added: Missing weapons, mags and backpack in i_weapons.sqf for the ranked TT version (currently both contain the same weapons, mags and backpacks, at least it works now)
- Changed: If a bonus vehicle gets killed over water/over the sea, it'll now be moved to the next beach so that it can still be picked up by a wreck chopper
- Fixed: Stupid typo in x_server\x_f\fn_airtaxiserver.sqf (underline got lost)
- More optimizations

3.38
- Fixed: Blufor players were kicked out of blufor vehicles, did only affect blufor players in the TT version, not used in the normal non TT version

3.37
- Tweaked: Player name hud color (if enabled)
- Changed: Only arty ops and squad leaders can draw lines on the map
- Fixed: In the CUP Chernarus version the bag fences at the jet reload point where positioned in the air
- Fixed: In the CUP Sahrani version the bag fences at the jet reload point where positioned 90 degree in the wrong direction
- Changed: Make use of the height parameter for triggers where possible
- Changed: Air drop marker gets now created for every player which calls a drop (gets removed automatically after about 900 seconds)
- Fixed: Make UAV at MHQ did not work in the TT version (for both sides)
- Changed: Turn MHQ engine off before deploying it
- Fixed: Drop answers when an air drop was executed was not working anymore
- Fixed: Missing localization string STR_DOM_MISSIONSTRING_641 in TT version
- Changed: If virtual arsenal box at base gets destroyed a new one reappears immediately
- Fixed: Replaced d_player_entities with allPlayers in fn_helirespawn2.sqf, variable d_player_entities does not exist on the server in the TT version
- Fixed: Engineers were kicked from engineer trucks in the TT version
- Fixed: Map marker line drawing for AI group waypoint debugging (only for debugging purposes, not available in MP)
- Changed: Progress bar for capping camps turns yellow now if capping is stalled beacuse of nearby enemies
- Fixed: Side mission 39 in the CUP Chernarus version, side mission did not end at all because of missing killed eventhandler
- More optimizations

3.36
- Fixed: Draw3D eventhandler drawing was only drawing when the player was near enough to an object and not the camera
- Updated: Spanish translation (thanks to Brigada_ESP)
- Added: The Two Teams (TT) PvPvE version is back... Yeah, Domi with PvP again!
- Added: Tons of new bugs (due to the quite severe TT version changes)
- Optimized: Replaced saving gear with 5 billion scripting commands with newly available getUnitLoadout and setUnitLoadout scripting commands
- Added: (Lobby) param to disable NVG equipment (disableNVGEquipment)
- Fixed: Stupid _d_pos script error in revive respawn eh script
- Fixed: Another stupid script error in fnc_ampoi which adds points to the player who places a mash when someone heals at a mash in the ranked version
- Fixed: When a player placed an object like a Mash and the object was killed the script was trying to access getVariable space with the player object instead of the player string name
- Optimized: Player firing in base area check (no longer checks if player is in base area every shot)
- Optimized: Non sidemission related buildings are now also restored if they get destroyed while solving a sidemission
- Changed: disableRemoteSensors true on clients in ai version too (for testing purposes)
- Fixed: NVG check for players was broken
- Changed: Disabling TI (for vecs) and disabling NVG will now also remove infantry weapon optics which have these modes (after arsenal gets closed, easiest way and needs no unncessary script loop running)
- Fixed: Retake camps was completely broken in the normal and TT version because of "OPFOR", "EAST", "BLUFOR", "INDEPENDENT", "GUER" inconsistencies
- Fixed: Got rid of the short standing animation before a dead player moves into unconscious animation state (xr revive), was visible only for other players now gone
- Added: Naked women
- Many optimizations

3.35
- Fixed: Wrong references to engineer trucks in fn_repengineer.sqf
- Fixed: Side mission 31 in CUP Takistan version was completely broken
- Fixed: Non existent variable d_heli_taxi_available did break airtaxi script in AI version
- Fixed: Side mission 23 (Special forces boats in a bay near Pacamac) in the CUP Sahrani version bailed out because of a script error
- Fixed: Side mission 9 (Helicopter Prototype at Krasnostav Airfield) in the CUP Chernarus version (a non existent macro broke the mission)

3.34
- Fixed: CUP_O_Mi8_RU accidentally made it into the normal vanilla version
- Changed: New main target index selection. Hopefully fixes the nilified index variable problem (I was still not able to reproduce it)
- Fixed: If player left the server remoteExec dropanswer resulted in sending the message to a nil object
- Fixed: When a player died in a building he was placed on the ground instead in the floor he died (xr_revive)

3.33
- Fixed: Some stringtable names were used twice
- Fixed: Tasks should now work correctly (I think I now know how it works :P...)
- Changed: d_can_mark_artillery units now get the same artillery messages as artillery operators
- Changed: Air drop marker position is adjusted to the position of the dropped object once it is on the ground
- Changed: Added some debug output to find an issue where the target center is missing when calling getranpointcircleold (and one possible fix added)

3.32
- Fixed: Counter attack was using wrong function to find enemy start positions
- Changed: Counter attack starts earlier now (45-90 seconds instead of 120-240 seconds after main target is clear), check trigger for end condition gets also created a lot earlier now
- Changed: Decreased minimal distance check in script which searches for random positions for bigger objects in a circle

3.31
- Fixed: Since 1.58 nore FSMs do not worked when added via CfgFunctions, switched to old execFSM way

3.30
- Changed: Parajump is now also possible with backpack
- Fixed: Script error in map draw script (affected AI version)

3.29
- Added: Spanish translation (thx to Brigada_ESP)
- Changed: Height check in client artillery script changed from getPosATL back to getPos
- Fixed: Wrong variable was used to check if a player is engineer. Resulted in broken engineer functionality sometimes
- Fixed: Automatic NVG in Virtual Arsenal dialog was not disabled when Virtual Arsenal was closed
- Optimized: Replaced some triggers with new inArea command
- Changed: New method to draw player and vehicle markers on map (does not use the game marker system anymore but draws directly on maps)
- Fixed: Another try to make Ammoload working again if a player dies in a vehicle
- Optimized: Using new string based engine layer system for resources (cutRsc, etc.)
- Fixed: BIS_fnc_EGSpectator changes viewdistance. When BIS_fnc_EGSpectator exits viewdistance is set to the one before BIS_fnc_EGSpectator was started (BIS_fnc_EGSpectator is admin only)
- Optimized: Using getInMan (and getOutMan) eventhandler now for vehicle scripts instead of the typical waituntil {vehicle player != player} script construct
- Changed: Increased timeout in evac sidemissions from 30 minutes to 60 minutes
- Changed: "Created" task state switched to "Assigned" to fix a problem with BI tasks overhaul
- Added: North, east, south, west, full ordered routes for Altis, Chernarus and Takistan versions (means ordered main targets instead of random main targets)
- Added: Message to deploy a MHQ when it gets dropped after a air lift or when a player drives a MHQ
- Fixed: Sidemission 36 building got indestructible after game update
- Fixed: In the ranked version (and AI enabled) AI counter was incremented even though no AI was created

3.28
- Fixed: If you want to change an element of an array use set and not setVariable (error in fn_p_o_ar, me dumb)
- Changed, reset player in vehicle variable after respawn. Possible fix for ammoload problem (stops working after respawn if player is in a vehicle when he dies)
- Fixed, player markers are now also shown when a player is in a non standard vehicle like a quad (new marker system is on the way anyway)
- Added one missing drag prone animation
- Changed, vehicles get now airlifted with four ropes instead of one (thanks to the get corners function by duda123), currently only available for normal non wreck lifting

3.27
- Fixed, wrong use of allowCrewInImmobile in armor creation script for side missions
- Fixed script error in BIS_fnc_establishingShot
- Fixed script errors when player created a UAV at MHQ (array instead the UAV object itself was send to server)
- Fixed, UAVs created with MHQ menu now get correctly deleted and UAV terminals removed

3.26
- Fixed, retrieving respawn and layoutgear was broken as it was using the same container object for uniform, vest and backpack
- Fixed, at respawn backpack content was doubled
- Added: Cleanup routine for player assembled objects

3.25
- Fixed, drivers of the artillery vehicles in base did not get deleted thus they were driving around
- Base artillery vehicle crews are now captive so they won't attack anything nor will they get attacked
- Fixed an error in spectating which completely broke it
- Fixed, wrong layer in spectating script caused black in to early before spectating started
- Fixed some more sidemission related erros

3.24
- Fixed free prisoners sidemissions in AI version
- Fixed artillery base sidemissions
- Added first experimental Community Upgrade Project (CUP) Chernarus version

3.23
- Mission now works with 3DEN
- mission.sqm file is now in 3DEN format (not binarized)
- Fixed respawn (was completely broken)

3.22
- Fixed CreateTriggerLocal, instead of creating local triggers it created global triggers :(
- 3D text "Virtual Arsenal" is now added above Virtual Arsenal ammo boxes

3.21
- Fixed chopper and vehicle respawn (note to myself: NEVER EVER USE BI SYSTEMS, THEY WILL FAIL LIKE THEY ALWAYS DO!!! This time it was BIS_fnc_loop which suddenly stopped working without a warning)
- Changed CfgRemoteExec mode to 2-turned on, however, ignoring whitelists (default because of backward compatibility) There was a bis_fnc_execVM warning in RPT although Dom is not using bis_fnc_execVM
- Vehicle overlay alignment corrected
- Switched to enhanced BI task system
- Fixed UI serialisation
- Fixed various small bugs
- Some optimizations

3.20
(only important changes)
- Rewrote many scripts using improved A3 scripting commands (also the ones included in 1.56)
- Many optimizations in virtually all scripts
- Removed many unnecessary scripts
- Replaced Dom network system with remoteExec/remoteExecCall from A3
- Replaced Spectating with the new A3 Spectating
- Replaced Domination Group Management System with Dynamic Groups System from A3
- Fixed various side missions
- Removed old Dom backpack system
- Millions of bug fixes
- And many many more things...