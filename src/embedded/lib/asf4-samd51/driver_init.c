/*
 * Code generated from Atmel Start.
 *
 * This file will be overwritten when reconfiguring your Atmel Start project.
 * Please copy examples or other code you want to keep to a separate file
 * to avoid losing it when reconfiguring.
 */

#include "driver_init.h"
#include <peripheral_clk_config.h>
#include <utils.h>
#include <hal_init.h>

void system_init(void)
{
	init_mcu();

	gpio_set_pin_direction(FEATHER_PIN_13, GPIO_DIRECTION_OUT);
	gpio_set_pin_level(FEATHER_PIN_13, true);
}
