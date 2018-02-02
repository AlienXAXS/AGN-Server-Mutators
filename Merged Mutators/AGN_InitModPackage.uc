/*
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 *
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 *
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 *
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_InitModPackage extends Rx_Mutator
	config(AGN_Mutator);

var AGN_Veh_Mutator VehMutator;
var AGN_Sys_Mutator SystemMutator;
var AGN_Mut_RepairPad_v2 RepairPads;
var AGN_MapFix_Islands AGNMapFixIslands;
var AGN_Rebuildable_Defence_Handler AGN_RebuildableDefenceHandler;
var AGN_CrateExtension AGNCrateExtension;

var bool modPackageInitComplete;
var bool mutatorInitDone;

var config int MaxPlayersAllowed;

simulated function Tick(float DeltaTime)
{
	if ( SystemMutator != None )
		SystemMutator.OnTick(DeltaTime);
}

function ModifyPlayer(Pawn Other)
{
	`log ( "[ModifyPlayer] " $ string(Other) $ " has spawned" );
}

function InitMutator(string options, out string errorMessage)
{
	local String mapname;
	
	modPackageInitComplete = false;

	if ( MaxPlayersAllowed == 0 )
		MaxPlayersAllowed = 40;

	// From an INI Now, yay!
	WorldInfo.Game.MaxPlayersAllowed = MaxPlayersAllowed;
	WorldInfo.Game.MaxPlayers = MaxPlayersAllowed;

	if ( mutatorInitDone )
	{
		`log("[AGN-Mutator] Attempted to InitMutator twice, stopped this...");
		return;
	}

	mutatorInitDone = true;

	if (Rx_Game(WorldInfo.Game) != None)
	{
		Rx_Game(WorldInfo.Game).PlayerControllerClass = class'AGN_Rx_Controller';
		Rx_Game(WorldInfo.Game).HudClass = class'AGN_HUD';
	}

	// Start our Crate System
	AGNCrateExtension = spawn(class'AGN_CrateExtension');
	if ( AGNCrateExtension != None )
		AGNCrateExtension.OnMutatorLoaded();

	mapname=WorldInfo.GetmapName();
	`log ( "[AGN-MAP-FINDER] Found map " $ mapname);
	if(right(mapname, 6) ~= "_NIGHT") mapname = Left(mapname, Len(mapname)-6);
	if(right(mapname, 4) ~= "_DAY") mapname = Left(mapname, Len(mapname)-4);

	// Start our Veh System
	VehMutator = spawn(class'AGN_Veh_Mutator');
	VehMutator.OnInitMutator(options, errorMessage);
	
	if ( mapname ~= "islands" )
	{
		AGNMapFixIslands = spawn(class'AGN_MapFix_Islands');
		if ( AGNMapFixIslands != None )
			AGNMapFixIslands.InitSystem();
	}

	SystemMutator = spawn(class'AGN_Sys_Mutator');
	if ( SystemMutator != None )
		SystemMutator.InitSystem();

	RepairPads = spawn(class'AGN_Mut_RepairPad_v2');
	if ( RepairPads != None )
		RepairPads.OnInitMutator();
		
	AGN_RebuildableDefenceHandler = spawn(class'AGN_Rebuildable_Defence_Handler');
	if ( AGN_RebuildableDefenceHandler != None)
		AGN_RebuildableDefenceHandler.InitSystem();

	super(Mutator).InitMutator(Options, ErrorMessage);
}

function Mutate(string MutateString, PlayerController Sender)
{
	// Call our VehicleMutator
	if ( VehMutator != None )
		VehMutator.OnMutate(MutateString, Sender);

	MutateHandler(MutateString, Sender);
	Super.Mutate(MutateString, Sender);
}

reliable server function MutateHandler(string MutateString, PlayerController Sender)
{
    local array<string> MutateStringSplit;
	
	// For finding people
	local Rx_PRI PRI;
	local string errorMessage;

    MutateStringSplit = SplitString ( MutateString, " ", true );
    if ( MutateStringSplit.Length == 0) return;

    if ( MutateStringSplit.Length == 1 && MutateStringSplit[0] ~= "agn_admin" )
    {
        if (!Sender.PlayerReplicationInfo.bAdmin)
        {
            Sender.ClientMessage("[AGN-Crates-Admin] Unable to comply, Kane says no!");
            return;
        }

        Sender.ClientMessage("[AGN-Admin] - use agn_admin help for help");
        return;
    }

    if ( MutateStringSplit.Length > 1 && MutateStringSplit[0] ~= "agn_admin" )
    {
        /*
         * [0] = agn_admin
         * [1] = cmd
         * (2) = params (optional, depends on cmd)
         */

        if (!Sender.PlayerReplicationInfo.bAdmin || WorldInfo.NetMode != NM_ListenServer)
        {
            Sender.ClientMessage("[AGN-Crates-Admin] Unable to comply, Kane says no!");
            return;
        }

        Sender.ClientMessage("1 = |" $ MutateStringSplit[1] $ "|");
        if ( MutateStringSplit[1] ~= "help" )
        {
            Sender.ClientMessage("[AGN-Admin] Commands: respawn_crates, despawn_crates, dump_actors, set_commander, give_commander");
        }else if ( MutateStringSplit[1] ~= "respawn_crates" )
        {
			if ( AGNCrateExtension != None	)
				AGNCrateExtension.OnAdminRespawnCrates(Sender);
        }else if ( MutateStringSplit[1] ~= "despawn_crates" )
        {
			if ( AGNCrateExtension != None )
				AGNCrateExtension.OnAdminDespawnCrates(Sender);
        }else if ( MutateStringSplit[1] ~= "dump_actors" )
        {
            class'AGN_UtilitiesX'.static.DumpAllActors(Sender);
		} else if ( MutateStringSplit[1] ~= "set_commander" )
		{
			//0 = agn_admin | 1 = set_commander | 2 = [name] = 3 length
			if ( MutateStringSplit.Length == 3 )
			{
				// We're setting a commander by name, or pid (if using # before the last param)
				PRI = Rx_Game(`WorldInfoObject.Game).ParsePlayer(MutateStringSplit[2], errorMessage);
				
				if ( PRI == None )
				{
					Sender.ClientMessage(errorMessage);
					return;
				}
				
				// Set the found player to be the commander
				Rx_Game(WorldInfo.Game).ChangeCommander(PRI.GetTeamNum(), PRI);
			} else {
				Sender.ClientMessage("Bad parameters for command, expected: agn_admin set_commander [#PLAYERID/PLAYER_NAME]");
			}
		} else if ( MutateStringSplit[1] ~= "give_commander" )
		{
			// Setting ourself to be the commander
			Rx_Game(WorldInfo.Game).ChangeCommander(Sender.GetTeamNum(), Rx_PRI(Sender.PlayerReplicationInfo));
        } else {
            Sender.ClientMessage("[AGN-Crates-Admin] Unknown command");
        }
    }
}

function OnMatchStarted()
{
	`log( "############# MATCH HAS STARTED IN AGN CODE #############" );
}

function Rx_CrateType OnDetermineCrateType(Rx_Pawn Recipient)
{
	if ( AGNCrateExtension != None )
		return AGNCrateExtension.OnDetermineCrateType(Recipient);
	else
		return None;
}

function string OnCratePickupMessageBroadcastPre(int CrateMesageID, PlayerReplicationInfo PRI)
{
	if ( AGNCrateExtension != None )
		return AGNCrateExtension.OnCratePickupMessageBroadcastPre(CrateMesageID, PRI);
	else
		return "";
}

function bool CheckReplacement(Actor Other)
{
	// Call our Vehicle Mutator
	if ( VehMutator != None )
		VehMutator.OnClassReplacement(Other);

	if(Other.IsA('Rx_TeamInfo'))
	{
		Rx_Game(WorldInfo.Game).PlayerControllerClass = class'AGN_Rx_Controller';
	}

	return true;
}

DefaultProperties
{
}
