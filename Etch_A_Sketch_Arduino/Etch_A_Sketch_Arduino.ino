// Initialize constants for input pins
const int x_pin = A0;
const int y_pin = A5;
const int clear_button = 4;

void setup() {
    // Put analog pins in input mode
    pinMode(x_pin, INPUT);
    pinMode(y_pin, INPUT);

    // Put digital pin in input mode (default: high)
    pinMode(clear_button, INPUT_PULLUP);
    
    Serial.begin(9600);
}

void loop() {
    // Read from potentiometers connected to analog pins
    int x = analogRead(x_pin);
    int y = analogRead(y_pin);

    // Invert value of button (FALSE = pushed, TRUE = not pushed)
    int clear_screen = !digitalRead(clear_button);

    // Send values over Serial connection
    Serial.print(x);
    Serial.print(",");
    Serial.print(y);
    Serial.print(",");
    Serial.print(clear_screen);
    Serial.println();

    // Wait for short time before looping
    delay(100);
}
