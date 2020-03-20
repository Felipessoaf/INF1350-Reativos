#include "eventdriven.h"
#include "app.h"
#include "pindefs.h"

int timers[3];
int buttons[3] = {-1, -1, -1};

unsigned long previousMillis = 0;
unsigned long interval = 500;

/* Funcoes de registro: */
void button_listen(int pin)
{
    // "pin" passado deve gerar notificacoes
    for(int i = 0; i < 3; i++)
    {
        if(buttons[i] != pin && buttons[i] < 0)
        {
            buttons[i] = pin;
            pinMode(pin, INPUT_PULLUP);
        }
    }
}

void timer_set (int t, int ms)
{
    // timer t deve expirar apos "ms" milisegundos
    // timer so dispara uma vez
    timers[t] = ms;
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

    // inicializacao do usuario
    appinit();                 
}

void loop () 
{
    // detecta novos eventos
    if()
    {
        // notifica o usuario
        button_changed(); 
    }

    // detecta novos eventos

    // notifica o usuario
    timer_expired();
}
