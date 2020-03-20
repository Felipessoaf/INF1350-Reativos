/* Funcoes de registro: */
void button_listen(int pin)
{
    // "pin" passado deve gerar notificacoes
}

void timer_set (int t, int ms)
{
    // timer t deve expirar ap ́os "ms" milisegundos// timer s ́o dispara uma vez
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

    // notifica o usu ́ario
    button_changed(); 

    // detecta novos eventos

    // notifica o usuario
    timer_expired();
}