extends Control

var inst_time_accumulator := 0.0
var inst_delta_sum := 0.0
var inst_frame_count := 0

var long_time_accumulator := 0.0
var long_delta_sum := 0.0
var long_frame_count := 0
var long_duration := 10.0

func _process(delta: float) -> void:
	# print frame time every second and average every [long_duration] seconds.
	inst_time_accumulator += delta
	inst_delta_sum += delta
	inst_frame_count += 1

	long_time_accumulator += delta
	long_delta_sum += delta
	long_frame_count += 1

	if inst_time_accumulator >= 1.0:
		var avg_ms = (inst_delta_sum / inst_frame_count) * 1000.0
		print("Frame Time: %f ms" % avg_ms)
		inst_time_accumulator = 0.0
		inst_delta_sum = 0.0
		inst_frame_count = 0

	if long_time_accumulator >= long_duration:
		var avg_ms = (long_delta_sum / long_frame_count) * 1000.0
		print("%d second average Frame Time: %f ms" % [long_duration, avg_ms])
		long_time_accumulator = 0.0
		long_delta_sum = 0.0
		long_frame_count = 0
