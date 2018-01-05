/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


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
	if(Switch == 1006)
	{
	    return RelatedPRI_1.PlayerName $ " found a mega speed crate!"; 
	}
	if(Switch == 1007)
	{
	    return RelatedPRI_1.PlayerName $ " found a Personal Obelisk Cannon crate!"; 
	}
    }
    return Repl(default.PickupBroadcastMessages[Switch], "`PlayerName`", RelatedPRI_1.PlayerName);
}

