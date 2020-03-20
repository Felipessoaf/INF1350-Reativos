#include "eventdriven.h"
#include "app.h"
#include "pindefs.h"

int state = LOW;

void appinit()
{
    button_listen(KEY1);
    set_timer (1, 1000);
}

void button_changed (int pin) 
{
    digitalWrite(LED1, LOW);
    exit();
}

void timer_expired (int t) 
{
    state = !state;
    digitalWrite (LED1, state);
    set_timer (1, 1000);
}