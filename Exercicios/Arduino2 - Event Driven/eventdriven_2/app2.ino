#include "eventdriven.h"
#include "app.h"
#include "pindefs.h"

int state = LOW;

void appinit()
{
    button_listen(KEY1);
    timer_set(1, 1000);
    digitalWrite(LED1, HIGH);
    digitalWrite(LED2, HIGH);
    digitalWrite(LED3, HIGH);
}

void button_changed (int pin) 
{
    digitalWrite(LED1, LOW);
    exit(0);
}

void timer_expired (int t) 
{
    state = !state;
    digitalWrite (LED1, state);
    timer_set (1, 1000);
}
