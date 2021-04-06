import processing.serial.*;

// Variables for Serial connection
Serial myPort;
String serial_input;
int line_feed = 10;
int [] inputs;

// Variables for Etch-A-Sketch drawing
PImage etch_a_sketch_frame;
float screen_width, screen_height, min_x, min_y, max_x, max_y;
float scale, w, h;
int px, py;


void setup(){   
   // Set up the Serial connection to Arduino Uno
   String portName = Serial.list()[0];
   myPort = new Serial(this, portName, 9600);
   myPort.bufferUntil(line_feed);
   
   // Initialize empty int array for Arduino input
   inputs = new int[3];
   
   // Set up drawing options for Processing
   fullScreen();
   noCursor();
   
   imageMode(CENTER);
   rectMode(CENTER);
   
   background(0);
   strokeWeight(2);
   fill(191, 193, 192);

   // Load image for "Frame" and initialize variables for positions and sizes
   etch_a_sketch_frame = loadImage("etch-a-sketch-frame.png");
   
   // Set sizes to ensure image fills window
   if(width >= height){
      scale = float(height)/etch_a_sketch_frame.height;
      
      w = etch_a_sketch_frame.width * scale;
      h = height;
   }
   else {
      scale = float(width)/etch_a_sketch_frame.width;
      
      w = width;
      h = etch_a_sketch_frame.height * scale;
   }
   
   // Set initial size of inner "etching" screen
   screen_width  = 544;
   screen_height = 384;
   
   // Scale "etching" screen according to image and window size
   screen_width  *= scale;
   screen_height *= scale;
   
   // Set x-axis and y-axis limits for etching
   min_x = float(width)/2 - screen_width/2;
   min_y = float(height)/2 - screen_height/2;
   
   max_x = min_x + screen_width;
   max_y = min_y + screen_height;
   
   // Draw starting screen
   clear_screen();
   image(etch_a_sketch_frame, width/2, height/2, w, h);
}


// Main loop
void draw(){    
   // Update any "etching" then draw frame on top
   etch();
   image(etch_a_sketch_frame, width/2, height/2, w, h);
}


// Clear the etching screen when the button is pressed
void clear_screen() {
   rect(width/2, height/2, screen_width, screen_height);
}


// Serial Event Listener reads String from serial connection and parses inputs
void serialEvent(Serial p) {
   serial_input = p.readString();
   
   String [] values = serial_input.split(",");
      
   if(values.length == 3) {
      inputs[0] = parseInt(values[0].trim());
      inputs[1] = parseInt(values[1].trim());
      inputs[2] = parseInt(values[2].trim());
   }
}


void etch() {
   // Check there was Serial input
   if(serial_input != null) {      
      int x_wheel = inputs[0]; 
      int y_wheel = inputs[1]; 
      int clear_button = inputs[2]; 
      
      // Map potentiometer values to etching screen
      int x = (int)map(x_wheel, 0, 1023, min_x, max_x);
      int y = (int)map(y_wheel, 0, 1023, min_y, max_y);
      
      // If button pressed, clear screen
      if(clear_button == 1) {
         clear_screen();
      }
      // Otherwise, draw line from previous position to current position
      else {
         line(px, py, x, y);
      }
      
      // Overwrite previous position with current position
      px = x;
      py = y;
   }
}
