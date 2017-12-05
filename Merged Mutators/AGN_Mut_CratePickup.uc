class AGN_Mut_CratePickup extends Rx_CratePickup;

function InstantiateDefaultCrateTypes()
{
	LogInternal ("Overwriting InstantiateDefaultCrateTypes now... adding in our own crates to the mix");
	
	// Call the original
	super.InstantiateDefaultCrateTypes();
	
	
	
}