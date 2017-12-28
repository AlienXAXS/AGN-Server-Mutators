class AGN_Message_Crates extends Rx_Message_Crates;

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    if(Switch > 1000)
    {
        if(Switch == 1001)
        {
            return RelatedPRI_1.PlayerName $ " found a super money crate!";
        }
        if(Switch == 1002)
        {
            return RelatedPRI_1.PlayerName $ " found a weapon crate!";
        }
        if(Switch == 1003)
        {
            return RelatedPRI_1.PlayerName $ " found a drop money crate!";
        }
        if(Switch == 1004)
        {
            return RelatedPRI_1.PlayerName $ " found a beacon crate!";
        }
		if(Switch == 1005)
		{
			return RelatedPRI_1.PlayerName $ " found a base defense EMP crate!"; 
		}
    }
    return Repl(default.PickupBroadcastMessages[Switch], "`PlayerName`", RelatedPRI_1.PlayerName);
}
