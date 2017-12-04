class AGN_Message_Crates extends Rx_Message_Crates;

//var localized array<string> PickupBroadcastMessages;

static function string GetString(
   optional int Switch,
   optional bool bPRI1HUD,
   optional PlayerReplicationInfo RelatedPRI_1,
   optional PlayerReplicationInfo RelatedPRI_2,
   optional Object OptionalObject
   )
{
	if ( Switch > 1000 )
	{
		if ( Switch == 1001 )
			return RelatedPRI_1.PlayerName $ " found a Super Money Crate!";
		if ( Switch == 1002 )
			return RelatedPRI_1.PlayerName $ " found a Random Weapon Crate!";
    if ( Switch == 1003 )
  			return RelatedPRI_1.PlayerName $ " found a Drop Money Crate!";
	}

   return Repl(default.PickupBroadcastMessages[Switch], "`PlayerName`", RelatedPRI_1.PlayerName);
}

DefaultProperties
{
}
