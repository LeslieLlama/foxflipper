extends Node

var coinsToThrow = 0
var coinCount = 0
var maxCoinCount = 0

var currentScore = 0
var CoinHistory = []
var CoinValues = []
var CoinHistorySprites = []

var totalValue = 100
var headsValue = 50
var tailsValue = 50

var headsThreshhold : float = 0.5
var totalWeight = 0.05

#var LuckyCharms = []
enum item_type {IMMEDIATE, ADDITION, POST_RUN, UTILITY}

var purchases = 0
var maxPurchases = 2
var itemNum = 0
