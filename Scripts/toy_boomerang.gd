extends LuckyCharm

var used : bool = false

func _ready() -> void:
	assign_seq_sym()
	Signals.ResetTable.connect(_reset_table)

func MultiplyScore():
	if used == true:
		return
	print("boomerang trigger")
	Signals.emit_signal("ScoreCoins")
	used = true
	_activation_animation()

func _reset_table():
	used = false
