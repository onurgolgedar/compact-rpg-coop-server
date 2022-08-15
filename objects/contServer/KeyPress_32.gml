if (keyboard_check(vk_control) and keyboard_check(vk_shift)) {
	draw_enable_drawevent(!global.drawEventEnabled)
	global.drawEventEnabled = !global.drawEventEnabled
}