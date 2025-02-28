extends Node


#signal UpgradeStats(typeOfPowerup, ammount : int, handName)

signal ResetTable()
signal ResetGame()
signal FlipCoin(coin_count : int)

signal PurchasePoints()
signal PurchaseCoin()
signal PurchaseWeight()
signal PurchaseItem(item : Control)
signal RemoveItem(item : Control)

signal CoinHistoryDisplayUpdate()

signal Mouse_Over(title : String, desc : String)
signal Mouse_End()

signal ScoreCoins()
signal CoinScored()
signal ComboScored()
signal AllCoinsScored()
signal AddPointsToCoin()
signal MiniCoinAnimation(c : int)

signal NextRound()
signal GameWon()

signal PopupMessage(textToSay : String, pos : Vector2, move_to : Vector2, textColour : Color)

#item spesific signals
signal HoldingTrainStub(isHolding : bool)
