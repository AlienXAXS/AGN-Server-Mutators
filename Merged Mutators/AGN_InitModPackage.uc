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
var AGN_AdminHandler AGNAdminHandler;

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
		
	AGNAdminHandler = spawn(class'AGN_AdminHandler');

	super(Mutator).InitMutator(Options, ErrorMessage);
}

function Mutate(string MutateString, PlayerController Sender)
{
	// Call our VehicleMutator
	if ( VehMutator != None )
		VehMutator.OnMutate(MutateString, Sender);

	if ( AGNAdminHandler != None )
		AGNAdminHandler.Handle(MutateString, Sender, AGNCrateExtension);
	
	Super.Mutate(MutateString, Sender);
}

function OnMatchStart()
{
	`log( "############# MATCH HAS STARTED IN AGN CODE #############" );
	class'AGN_UtilitiesX'.static.SendMessageToAllPlayers("Welcome to AGN Gaming.\nThis is a heavily modified server and is in no way a reflection of the base Renegade-X Game\nEnjoy your stay!", 400);
	if ( AGN_RebuildableDefenceHandler != None )
		AGN_RebuildableDefenceHandler.OnMatchStart();
}

function Rx_CrateType OnDetermineCrateType(Rx_Pawn Recipient, Rx_CratePickup CratePickup)
{
	if ( AGNCrateExtension != None )
		return AGNCrateExtension.OnDetermineCrateType(Recipient, CratePickup);
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
		Rx_Game(WorldInfo.Game).PlayerReplicationInfoClass = class'AGN_Rx_PRI';
	}

	return true;
}

DefaultProperties
{
}
