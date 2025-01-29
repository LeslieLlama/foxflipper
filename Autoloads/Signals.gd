extends Node


#signal UpgradeStats(typeOfPowerup, ammount : int, handName)

signal ResetTable()
signal ResetGame()
signal FlipCoin(coin_count : int)

signal PurchasePoints()
signal PurchaseCoin()

signal CoinHistoryDisplayUpdate()

signal ScoreCoins()
signal CoinScored()
signal AllCoinsScored()

signal NextRound()

signal PopupMessage(textToSay : String, pos : Vector2, textColour : Color)
