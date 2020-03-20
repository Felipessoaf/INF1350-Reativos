#include "eventdriven.h"
#include "app.h"
#include "pindefs.h"

int state = LOW;
int canBlink = 1;
unsigned long ledInterval = 500;

unsigned long btnInterval = 500;

unsigned long oldMillisBtn1 = 0;
unsigned long oldMillisBtn2 = 0;

unsigned long ledMinimo = 125;
unsigned long ledMaximo = 1000;

void appinit()
{
  button_listen(KEY1);
  button_listen(KEY2);
  button_listen(KEY3);

  timer_set(0, ledInterval);

  digitalWrite(LED1, HIGH);
  digitalWrite(LED2, HIGH);
  digitalWrite(LED3, HIGH);
}

void button_changed (int pin)
{
  if (pin == KEY1)
  {
    Serial.println("btn 1");
    if (millis() - oldMillisBtn2 < btnInterval)
    {
      Serial.println("btn 1 && 2");
      canBlink = !canBlink;
    }
    else
    {
      ledInterval /= 2;

      if (ledInterval < ledMinimo)
      {
        ledInterval = ledMinimo;
      }
    }

    oldMillisBtn1 = millis();
  }
  else if (pin == KEY2)
  {
    Serial.println("btn 2");
    if (millis() - oldMillisBtn1 < btnInterval)
    {
      Serial.println("btn 2 && 1");
      canBlink = !canBlink;
    }
    else
    {
      ledInterval *= 2;

      if (ledInterval > ledMaximo)
      {
        ledInterval = ledMaximo;
      }
    }

    oldMillisBtn2 = millis();
  }
}

void timer_expired (int t)
{
  if (t == 0)
  {
    if (canBlink)
    {
      state = !state;
      digitalWrite (LED1, state);
    }
    timer_set (1, ledInterval);
  }
}
