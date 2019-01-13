/******************************************************************************
serialbuttons.ino
Code originally by Byron Jacquot @ SparkFun Electronics
https://learn.sparkfun.com/tutorials/button-pad-hookup-guide/exercise-2-monochrome-plus-buttons
1/6/2015

Edited by Amy Goodchild
Jan 2018

Development environment specifics:
Developed in Arduino 1.6.5
For an Arduino Mega 2560

This code is released under the [MIT License](http://opensource.org/licenses/MIT).

Distributed as-is; no warranty is given.
******************************************************************************/    

// Config variables
#define NUM_LED_COLUMNS (4)
#define NUM_LED_ROWS (4)
#define NUM_BTN_COLUMNS (4)
#define NUM_BTN_ROWS (4)
#define NUM_COLORS (1)

#define MAX_DEBOUNCE (3)

// Used to store whether or not to turn the LED on.
static bool LED_buffer[NUM_LED_COLUMNS][NUM_LED_ROWS];

static int8_t debounce_count[NUM_BTN_COLUMNS][NUM_BTN_ROWS];

// N.b. These pin numbers refer to the ones I (Amy Goodchild) used, please check my instructable for more. https://www.instructables.com/member/amygoodchild/
// If you followed the Sparkfun tutorial to set up and plug in the board then you will be using different pins
static const uint8_t btncolumnpins[NUM_BTN_COLUMNS] = {39, 41, 43, 45};
static const uint8_t btnrowpins[NUM_BTN_ROWS]       = {31, 33, 35, 37};
static const uint8_t ledcolumnpins[NUM_LED_COLUMNS] = {38, 40, 42, 44};
static const uint8_t colorpins[NUM_LED_ROWS]        = {30, 32, 34, 36};  // Only using the green LEDs


void setup()
{
  // put your setup code here, to run once:
  Serial.begin(115200);

  Serial.print("Starting Setup...");

  // setup hardware
  setuppins();

  // init global variables
  for (uint8_t i = 0; i < NUM_LED_COLUMNS; i++)
  {
    for (uint8_t j = 0; j < NUM_LED_ROWS; j++)
    {
      LED_buffer[i][j] = 0;
    }
  }
  Serial.println("Setup Complete.");

}

void loop() {

  scan();

}


static void setuppins()
{
  uint8_t i;
  
  // Set up LED columns
  for (i = 0; i < NUM_LED_COLUMNS; i++)
  {
    pinMode(ledcolumnpins[i], OUTPUT);

    // with nothing selected by default
    digitalWrite(ledcolumnpins[i], HIGH);
  }

  // Set up button columns
  for (i = 0; i < NUM_BTN_COLUMNS; i++)
  {
    pinMode(btncolumnpins[i], OUTPUT);

    // with nothing selected by default
    digitalWrite(btncolumnpins[i], HIGH);
  }

  // Set up button rows
  for (i = 0; i < NUM_BTN_ROWS; i++)
  {
    pinMode(btnrowpins[i], INPUT_PULLUP);
  }

  // Set up LED rows
  for (i = 0; i < NUM_LED_ROWS; i++)
  {
    pinMode(colorpins[i], OUTPUT);
    digitalWrite(colorpins[i], LOW);
  }

  // Initialize the debounce counter array
  for (uint8_t i = 0; i < NUM_BTN_COLUMNS; i++)
  {
    for (uint8_t j = 0; j < NUM_BTN_ROWS; j++)
    {
      debounce_count[i][j] = 0;
    }
  }
}


static void scan()
{ 
  static uint8_t column = 0; 
  uint8_t ledRow, btnRow;

  // Select current columns
  digitalWrite(btncolumnpins[column], LOW);
  digitalWrite(ledcolumnpins[column], LOW);

  // Read the button inputs
  for ( btnRow = 0; btnRow < NUM_BTN_ROWS; btnRow++)
  {
    if (digitalRead(btnrowpins[btnRow]) == LOW)
    {
      // The row value is low, meaning the button
      // in the current column is pressed
      
      if ( debounce_count[column][btnRow] < MAX_DEBOUNCE)
      {
        // start counting how many scans the button has
        // been pressed for. This avoids glitchyness if
        // the button is pressed down slowly, which could
        // otherwise register as multiple presses.
        debounce_count[column][btnRow]++;
        
        if ( debounce_count[column][btnRow] == MAX_DEBOUNCE )
        {
          // The button has been pressed for a significant
          // amount of time, meaning this is a real press!
          
          // Select the corresponding LED, so it gets lit
          // up in the next loop
          LED_buffer[column][btnRow] = true;

          // Write the number of the button to the serial port,
          // so the Processing sketch can pick it up
          Serial.write((btnRow * NUM_BTN_ROWS) + column);
        }
      }
    }
    else
    {
      if ( debounce_count[column][btnRow] > 0)
      {
        // button is not being pressed
        
        // reduce the push time counter
        debounce_count[column][btnRow]--;

        if ( debounce_count[column][btnRow] == 0 )
        // if the push time counter has reached 0, then
        // the button has been released
        {
          // Deselect the corresponding LED so it doesn't
          // light up in the next loop
          LED_buffer[column][btnRow] = 0;
        }
      }
    }
  }

  // light up selected LEDs
  for (ledRow = 0; ledRow < NUM_LED_ROWS; ledRow++)
  {
    if (LED_buffer[column][ledRow])
    {
      digitalWrite(colorpins[ledRow], HIGH);
    }
  }

  // give the LEDs a millisecond to shine their shininess
  delay(1); 

  // turn all the LEDs off
  for (ledRow = 0; ledRow < NUM_LED_ROWS; ledRow++)
  {
    digitalWrite(colorpins[ledRow], LOW);
  }

  // Deselect the current columns
  digitalWrite(btncolumnpins[column], HIGH);
  digitalWrite(ledcolumnpins[column], HIGH);

  // Move to the next column for the next loop()
  column++;
  if (column >= NUM_LED_COLUMNS)
  {
    column = 0;
  }
}
