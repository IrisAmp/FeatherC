#include <atmel_start.h>

int main()
{
  atmel_start_init();

  while (true)
  {
    gpio_toggle_pin_level(FEATHER_PIN_13);
    delay_ms(1000);
  }
}
