#include "eventdriven.h"
#include "app.h"
#include "pindefs.h"

int timers[3];
int timersUsed[3] = {0, 0, 0};
int buttons[3] = { -1, -1, -1};

unsigned long previousMillis = 0;
unsigned long intervalBtn = 200;
unsigned long previousButtonMillis[3] = {0, 0, 0};

/* Funcoes de registro: */
void button_listen(int pin)
{
  int slot = -1;

  // "pin" passado deve gerar notificacoes
  for (int i = 0; i < 3; i++)
  {
    if (buttons[i] < 0)
    {
      slot = i;
    }

    if (buttons[i] == pin)
    {
      slot = -1;
    }
  }

  if (slot >= 0)
  {
    buttons[slot] = pin;
    pinMode(pin, INPUT_PULLUP);
  }
}

void timer_set (int t, int ms)
{
  // timer t deve expirar apos "ms" milisegundos
  // timer so dispara uma vez
  timers[t] = ms;
  timersUsed[t] = 1;
  Serial.println("timers");
  Serial.println(t);
}

/* Callbacks  - definidas em app.h*/

// notifica que "pin" mudou para "v"
void button_changed (int pin, int v);
// notifica que o timer expirou
void timer_expired (void);

/* Programa principal: */
void setup ()
{
  // inicializacao da API
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);
  Serial.begin(9600);
  // inicializacao do usuario
  appinit();
}

void loop ()
{
  unsigned long currentMillis = millis();
  // detecta novos eventos
  for (int i = 0; i < 3; i++)
  {
    if (currentMillis - previousButtonMillis[i] >= intervalBtn) {
      if (buttons[i] >= 0 and digitalRead(buttons[i]) == LOW)
      {
        // notifica o usuario
        button_changed(buttons[i]);
        previousButtonMillis[i] = currentMillis;
      }
    }
  }

  // detecta novos eventos
  for (int i = 0; i < 3; i++)
  {
    if (timersUsed[i] == 1)
    {
      Serial.println(timersUsed[i]);
      Serial.println(timers[i]);
      //atualiza o tempo
      timers[i] -= currentMillis - previousMillis;
      if (timers[i] <= 0)
      {
        Serial.println("timers[i] <= 0");
        // notifica o usuario
        timer_expired(i);
        timersUsed[i] = 0;
      }
    }
  }
  previousMillis = currentMillis;
}
