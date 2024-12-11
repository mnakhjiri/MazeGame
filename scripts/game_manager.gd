extends Node

# Global functions

signal success
signal fail

# Item use Puzzle
enum Items {Oil, Cloth, Stick}
var player_items = []

func aquire_item(Item: Items):
	player_items.append(Item)

func has_all_items() -> bool:
	return [Items.Oil, Items.Cloth, Items.Stick].all(player_items.has)

# Match moving Puzzle
var num_turns = 3
var slot_occupancy: Dictionary = {1: true, 2: true, 3: true, 5: true, 6: true, 7: true, 8: true, 9: true, 10: true,
								11: true, 12: true, 13: true, 14: true, 15: true, 16: true, 17: true, 18: true, 19: true,
								20: true, 21: true, 22: true, 23: true, 24: true, 25: true, 26: true, 27: true, 28: true,
								29: true, 30: true, 31: true, 32: true}  # Tracks whether slots are occupied

# List of slot IDs that must be occupied to solve the puzzle
@export var solution_slots: Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 
									11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
									21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]

@onready var match_label: Label = $"../CanvasLayer/PanelGUI/MatchPuzzle/Label"
@onready var panel_gui: Control = $"../CanvasLayer/PanelGUI"

func decrease_turns():
	if num_turns > 1:
		num_turns -= 1
		match_label.text = "move the matches so the equation is right\nyou have " + str(num_turns) + " tries left"
	else:
		match_label.text = "You Failed!"
		match_label.add_theme_color_override("font_color", Color(1, 0, 0))
		
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = 1
		add_child(timer)
		timer.start()
		await timer.timeout
		
		fail.emit()

func update_slot_occupancy(slot_id: int, is_occupied: bool) -> void:
	slot_occupancy[slot_id] = is_occupied
	check_match_puzzle()

func check_match_puzzle() -> void:
	for slot_id in solution_slots:
		if not slot_occupancy.get(slot_id, false):  # If a required slot is not occupied
			return
	success.emit()
