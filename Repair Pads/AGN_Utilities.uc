class AGN_Utilities extends Rx_Game;

static final function string Lower(coerce string Text) {
 
  local int IndexChar;
 
  for (IndexChar = 0; IndexChar < Len(Text); IndexChar++)
    if (Mid(Text, IndexChar, 1) >= "A" &&
        Mid(Text, IndexChar, 1) <= "Z")
      Text = Left(Text, IndexChar) $ Chr(Asc(Mid(Text, IndexChar, 1)) + 32) $ Mid(Text, IndexChar + 1);
 
  return Text;
}
  
  