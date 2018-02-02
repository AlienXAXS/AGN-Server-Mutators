class AGN_AdminHandler extends Rx_Mutator;

reliable server function Handle(string MutateString, PlayerController Sender, AGN_CrateExtension AGNCrateExtension)
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

        if (!Sender.PlayerReplicationInfo.bAdmin)
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