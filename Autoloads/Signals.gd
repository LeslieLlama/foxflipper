extends Node


#signal UpgradeStats(typeOfPowerup, ammount : int, handName)

signal ResetTable()
signal ResetGame()
signal FlipCoin(is_reflip : bool)
signal FlippedCoin(coin_count : int)

signal PurchasePoints()
signal PurchaseCoin()
signal PurchaseWeight()
signal PurchaseItem(item : Control)
signal RemoveItem(item : Control)
signal SwapItems()

signal CoinHistoryDisplayUpdate()

signal Mouse_Over(title : String, desc : String)
signal Mouse_End()
signal Mouse_Over_Shop(title : String, desc : String)
signal Mouse_End_Shop()

signal ScoreCoins()
signal CoinScored()
signal ComboScored()
signal AllCoinsScored()
signal AddPointsToCoin()
signal MiniCoinAnimation(c : int)

#mostly for the dealers sprite and audio cues
signal RoundWon()
signal RoundLost()
signal EnterShop()
signal NextRound()
signal GameWon()

signal PopupMessage(textToSay : String, pos : Vector2, move_to : Vector2, textColour : Color)

#item spesific signals
signal HoldingTrainStub(isHolding : bool)
signal HoldingHotelSoap(isHolding : bool)
signal UpdateScoreUI() #used by six shooter but it's applicable anywhere you need to update the score display
signal AddItemPurchaseSlot(add : bool) #used by folded bill to add another item slot to the shop, might be used by other items or a challenge mode
signal ForceTriggerItems() #used by fish hook, runs through the scoring sequence before coins are offically scored.
