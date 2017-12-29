/*
 *	The start of the AGN Persistence Mutator
 *		This Mutator will capture small pieces of data every x seconds
 *		so that if a player were to disconnect and reconnect, this captured data would be returned to them
 *		such as:  Credits, Team, and maybe even one day the class they last were, health, etc.
*/

class InitModPackage extends Rx_Mutator;

// Where does our Player Data get stored?
var() array<PlayerData> CapturedPlayerData;
var int UpdateTickRate;

simulated function Tick(float DeltaTime)
{
	if ( SystemMutator != None )
		SystemMutator.OnTick(DeltaTime);
}

function ModifyPlayer(Pawn Other)
{
	// This is where we can handle giving back what the player had lost.
	local PlayerData tmpPlayerData;
	local Rx_Controller ourController;
	local Rx_PRI rxPRI;
	
	if ( Rx_Controller(Pawn.Controller) != None )
	{
		ourController = Rx_Controller(Pawn.Controller);
		if ( ourController.PlayerReplicationInfo != None )
		{
			rxPRI = ourController.PlayerReplicationInfo;
			tmpPlayerData = tmpPlayerData = FindPlayerDataByUUID(ourController.PlayerUUID);
			if ( tmpPlayerData != None )
			{
				// We found our player data from last session.
				// Now we need to check if this is a new instance of this player.
				// TODO: Figure out how to find out how long a player has been connected to the server for.
			}
		} else {
			`log("Unable to load player for persistance, no PRI...");
		}
	} else {
		`log("Unable to load player for persistance, no controller...");
	}
}

function InitMutator(string options, out string errorMessage)
{
	// Only run this on the server
	if(`WorldInfoObject.NetMode == NM_DedicatedServer)
		SetTimer(UpdateTickRate, true, 'ServerHeartbeat');
}

reliable server function ServerHeartbeat()
{
	local PlayerData tmpPlayerData;
	local Controller c;

	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
	{
		if ( c != None )
		{
			if ( Rx_Controller(c) != none && Rx_PRI(Rx_Controller(c).PlayerReplicationInfo) != None )
			{
				tmpPlayerData = FindPlayerDataByUUID(Rx_Controller(c).PlayerUUID);
				if ( tmpPlayerData != None )
					UpdatePlayer(Rx_PRI(Rx_Controller(c).PlayerReplicationInfo),tmpPlayerData);
				else
				{
					AddPlayer(Rx_Controller(c));
					Rx_Controller(c).CTextMessage("[AGN Persistence] You're stats are now being saved, if you lose connection and rejoin you will keep your credits",'LightGreen',250);
				}
			}
		}
	}
}

function PlayerData FindPlayerDataByUUID(string UUID)
{
	local PlayerData pd;
	foreach CapturedPlayerData(pd)
	{
		if ( pd.UUID == UUID )
			return pd;
	}
	
	return None;
}

function AddPlayer(Rx_Controller playerCtrlr)
{
	local PlayerData pd;
	local Rx_PRI rxPRI;
	
	if ( playerCtrlr.PlayerReplicationInfo != None )
	{
		rxPRI = playerCtrlr.PlayerReplicationInfo;
		
		pd = new PlayerData;
		pd.UUID = playerCtrlr.PlayerUUID;
		pd.Credits = rxPRI.GetCredits();
		pd.Team = playerCtrlr.GetTeamNum();
		
		CapturedPlayerData.AddItem(pd);
		
		playerCtrlr.CTextMessage("Added Player Stats");
	}
}

function UpdatePlayer(Rx_Controller playerCtrlr, PlayerData thisPlayerData)
{
	local Rx_PRI rxPRI;
	
	if ( playerCtrlr.PlayerReplicationInfo != None )
	{
		rxPRI = playerCtrlr.PlayerReplicationInfo;
		thisPlayerData.Credits = rxPRI.GetCredits();
		thisPlayerData.Team = playerCtrlr.GetTeamNum();
		
		playerCtrlr.CTextMessage("Updated your player");
	}
}

DefaultProperties
{
	UpdateTickRate = 30;
}