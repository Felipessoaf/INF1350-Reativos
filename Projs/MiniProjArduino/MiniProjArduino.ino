/*
  Nome: Felipe Pessoa e Guilherme Bizzo
  Matricula: 1411716 e 1710563
*/
//TODO:
//1- Botar sons de acerto e erro
//2- Ver quanto tempo cada jogador levou para acertar a sequencia, e usar isso para desempate da rodada e desempate final
//3- Botar para piscar o resultado no final e botar um som?
//4- Separar previousMillis para cada key (pode ver o exemplo no event driven)

#include "pindefs.h"

/* Define shift register pins used for seven segment display */
#define LATCH_DIO 4
#define CLK_DIO 7
#define DATA_DIO 8

/* Segment byte maps for numbers 0 to 9 */
const byte SEGMENT_MAP[] = {0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0X80, 0X90};
/* Byte maps to select digit 1 to 4 */
const byte SEGMENT_SELECT[] = {0xF1, 0xF2, 0xF4, 0xF8};

// Globals
int state = 1;
int countSequence = 0;
int turnCount = 1;
int turnPlayer = 0;

// Players stats
bool turnResult[2] = {true, true};
int totalPoints[2] = {0, 0};
unsigned long turnDuration[2] = {0, 0};
unsigned long totalDuration[2] = {0, 0};

// Time
unsigned long previousMillis = 0;
unsigned long interval = 200;
unsigned long ledInterval = 1000;

int sequenceAnswer[5];
int sequencePlayer[5];

void setup()
{
  /* Set DIO pins to outputs */
  pinMode(LATCH_DIO, OUTPUT);
  pinMode(CLK_DIO, OUTPUT);
  pinMode(DATA_DIO, OUTPUT);

  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);
  pinMode(KEY1, INPUT_PULLUP);
  pinMode(KEY2, INPUT_PULLUP);
  pinMode(KEY3, INPUT_PULLUP);

  RestartSequence();

  randomSeed(analogRead(0));
  Serial.begin(9600);
}

void loop()
{
  unsigned long currentMillis = millis();

  WriteNumberToSegment(0, turnCount);
  WriteNumberToSegment(1, turnPlayer + 1);
  WriteNumberToSegment(2, totalPoints[0]);
  WriteNumberToSegment(3, totalPoints[1]);

  switch (state)
  {
    case 1:
      /*  Fase dos leds  */

      //piscar leds 1,2,3 5 vezes aleatoriamente
      if (countSequence < 5)
      {
        //randomizando o led
        int randLed = random(LED1, LED3 + 1);

        //piscando o led
        digitalWrite(randLed, LOW);
        delay(ledInterval);
        digitalWrite(randLed, HIGH);
        delay(ledInterval);

        int step = countSequence + 1;
        Serial.println("Sequence :");
        Serial.println(randLed);

        //salvando na sequencia e aumentando contador
        sequenceAnswer[countSequence] = randLed;
        countSequence++;
      }
      else
      {
        state = 2;
        countSequence = 0;
        digitalWrite(LED1, HIGH);
        digitalWrite(LED2, HIGH);
        digitalWrite(LED3, HIGH);
      }
      break;
    case 2:
      /*  Fase de input do usuario  */

      //grava o tempo inicial caso seja o primeiro input
      if (turnDuration[turnPlayer] == 0)
      {
        turnDuration[turnPlayer] = currentMillis;
      }

      if (countSequence < 5)
      {
        if (currentMillis - previousMillis >= interval)
        {
          previousMillis = currentMillis;

          if (digitalRead(KEY1) == LOW)
          {
            checkSequence(LED1);
          }
          if (digitalRead(KEY2) == LOW)
          {
            checkSequence(LED2);
          }
          if (digitalRead(KEY3) == LOW)
          {
            checkSequence(LED3);
          }
        }
      }
      else
      {
        state = 3;
        countSequence = 0;
        turnResult[turnPlayer] = true;
      }
      break;
    case 3:
      /*  Fase de resultados  */
      
      //calcula o tempo que o jogador levou
      turnDuration[turnPlayer] = currentMillis - turnDuration[turnPlayer];
      //mostra resultados
      if (turnResult[turnPlayer])
      {
        //Ativa som de acerto
        /*tone(3, 32, 1000);
          delay(10);
          noTone(3);
          tone(3, 49, 1000);
          delay(10);
          noTone(3);*/

        Serial.println("Right :");
        Serial.println(turnPlayer);
        totalDuration[turnPlayer] += turnDuration[turnPlayer];
      }
      else
      {
        //Ativa som de erro
        /*tone(3, 20, 1000);
          delay(10);
          noTone(3);
          tone(3, 20, 1000);
          delay(10);
          noTone(3);*/

        Serial.println("Wrong :");
        Serial.println(turnPlayer);
      }

      // Se o jogador 2 acabou de jogar, acabou a rodada, e o ponto pode ser calculado
      if (turnPlayer == 1)
      {
        // Jogador 1 acertou
        if (turnResult[0] == true)
        {
          // Jogador 2 acertou
          if (turnResult[1] == true)
          {
            // Jogador 1 foi mais rápido
            if (turnDuration[0] < turnDuration[1])
            {
              Serial.println("Player 1 was faster!");
              totalPoints[0] += 1;
            }
            else
            {
              Serial.println("Player 2 was faster!");
              totalPoints[1] += 1;
            }
          }
          else
          {
            Serial.println("Player 1 won this round!");
            totalPoints[0] += 1;
          }

        }
        else if (turnResult[1] == true)
        {
          Serial.println("Player 2 won this round!");
          totalPoints[1] += 1;
        }
        else
        {
          Serial.println("No winners!");
        }
      }

      turnPlayer = (turnPlayer == 0) ? 1 : 0;

      if (turnCount < 5)
      {
        if (turnPlayer == 0)
        {
          turnCount += 1;
        }
        RestartSequence();
      }
      else
      {
        //Escreve e pisca resultado final da partida
        /*WriteNumberToSegment(0, 1);
        WriteNumberToSegment(1, totalPoints[0]);
        WriteNumberToSegment(2, 2);
        WriteNumberToSegment(3, totalPoints[1]);
        delay(1000);*/
        
        //Checa empate
        if (totalPoints[0] == totalPoints[1])
        {
          if (totalDuration[0] < totalDuration[1])
          {
            Serial.println("Player 1 won the game!");
          }
          else if (totalDuration[0] > totalDuration[1])
          {
            Serial.println("Player 2 won the game!");
          }
          else
          {
            Serial.println("It's a tie!");
          }
        }
        else
        {
          if (totalPoints[0] > totalPoints[1])
          {
            Serial.println("Player 1 won the game!");
          }
          else
          {
            Serial.println("Player 2 won the game!");
          }
        }

        //Botar para piscar o resultado no final e botar um som?


        //input para resetar
        if (currentMillis - previousMillis >= interval)
        {
          previousMillis = currentMillis;

          if (digitalRead(KEY1) == LOW and digitalRead(KEY2) == LOW and digitalRead(KEY3) == LOW)
          {
            RestartGame();
          }
        }       
      }
      break;
    default:
      RestartSequence();
      break;
  }
}

void RestartSequence()
{
  state = 1;
  countSequence = 0;
  turnResult[turnPlayer] = true;
  turnDuration[turnPlayer] = 0;

  digitalWrite(LED1, HIGH);
  digitalWrite(LED2, HIGH);
  digitalWrite(LED3, HIGH);
}

void RestartGame()
{
  turnCount = 1;
  totalPoints[0] = 0;
  totalPoints[1] = 0;
  totalDuration[0] = 0;
  totalDuration[1] = 0;
  turnPlayer = 0;
  RestartSequence();
}

void checkSequence(int led)
{
  //salvando na sequencia e aumentando contador
  sequencePlayer[countSequence] = led;
  Serial.println("Usuario apertou ");
  Serial.println(led);
  if (sequencePlayer[countSequence] != sequenceAnswer[countSequence])
  {
    state = 3;
    turnResult[turnPlayer] = false;
  }

  countSequence++;
}

/* Write a decimal number between 0 and 9 to one of the 4 digits of the display */
void WriteNumberToSegment(byte Segment, byte Value)
{
  digitalWrite(LATCH_DIO, LOW);
  shiftOut(DATA_DIO, CLK_DIO, MSBFIRST, SEGMENT_MAP[Value]);
  shiftOut(DATA_DIO, CLK_DIO, MSBFIRST, SEGMENT_SELECT[Segment]);
  digitalWrite(LATCH_DIO, HIGH);
}
