extends Node


#signal UpgradeStats(typeOfPowerup, ammount : int, handName)

signal ResetTable()
signal ResetGame()
signal FlipCoin(coin_count : int)

signal PurchasePoints()
signal PurchaseCoin()
signal PurchaseWeight()

signal CoinHistoryDisplayUpdate()

signal ScoreCoins()
signal CoinScored()
signal ComboScored()
signal AllCoinsScored()

signal NextRound()
signal GameWon()

signal PopupMessage(textToSay : String, pos : Vector2, move_to : Vector2, textColour : Color)
