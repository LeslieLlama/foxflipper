extends LuckyCharm

var used : bool = false

func _ready() -> void:
	assign_seq_sym()
	Signals.ResetTable.connect(_reset_table)

func MultiplyScore():
	Globals.reverse_score_direction = false
	if used == true:
		return
	print("boomerang trigger")
	Globals.score_loop += 1
	Globals.reverse_score_direction = true
	used = true
	_activation_animation()
	

func _reset_table():
	used = false
	Globals.score_loop = 1
	Globals.reverse_score_direction = false
