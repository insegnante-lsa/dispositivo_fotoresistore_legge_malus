// Obiettivo: misurare la caduta di tensione ai capi di un fotoresistore
 
import processing.serial.*;
import java.util.Date;

void scorrimento(float valoreSensore, float valoriSensore[], int dim)
{
  for(int i = 1; i < dim; i++)
    valoriSensore[i-1] = valoriSensore[i];  

  valoriSensore[dim - 1] = valoreSensore;
}

long calcoloMedia(float valoriSensore[], int dim)
{
  long somma = 0;
  for(int i = 0; i < dim; i++)
    somma += valoriSensore[i]; 

  return somma / dim;
}

static final int DIM = 100;
float valoriSensore[]= new float[DIM];
  
Serial myPort;    // The serial port
PFont myFont;     // The display font
String inString;  // Input string from serial port
int lf = 10;      // ASCII linefeed

PrintWriter output;
// DateFormat fnameFormat = new SimpleDateFormat("yyMMdd_HHmm");
// DateFormat timeFormat = new SimpleDateFormat("hh:mm:ss");
String fileName; 

void setup() {
  // List all the available serial ports: 
  printArray(Serial.list()); 
  // I know that the first port in the serial list on my mac 
  // is always my  Keyspan adaptor, so I open Serial.list()[0]. 
  // Open whatever port is the one you're using. 
  // myPort = new Serial(this, Serial.list()[0], 9600); 
  myPort = new Serial(this, "/dev/ttyACM0", 9600);
  myPort.bufferUntil(lf);
  
  size (720, 480); // window's size
  background (178,255,255);  // bgcolor

  // myFont = loadFont("Courier10PitchBT-Bold-48.vlw");
  // You'll need to make this font with the Create Font Tool 
  myFont = createFont(PFont.list()[0],20);
  textFont(myFont); 

  // Date now = new Date();
  // fileName = fnameFormat.format(now);
  fileName = "archivio";
  output = createWriter(fileName + ".txt"); // save the file in the sketch folder
} 
 
void draw() {
  frameRate(30);
  
  float valore = float(inString);
  scorrimento(valore, valoriSensore, DIM);
  float valoreMedio = calcoloMedia(valoriSensore, DIM);
  // calcolo della caduta di tensione
  int caduta = int((map(valoreMedio,0,1023,0,5000)));
  caduta = 5000 - caduta;
 
  fill(0);
  textSize(20);
  text("VALORE SENSORE:",60,130);
  text("CADUTA TENSIONE:",435,130);  
  
  fill(218,253,218);
  stroke(0);
  strokeWeight(2);
  quad(50,150,300,150,300,250,50,250);
  quad(420,150,670,150,670,250,420,250);
  
  fill(0); 
  textSize(50);
  text(int(valoreMedio),145,220);
  // scrittura del valore della caduta di tensione
  text(caduta,485,220);
  
  // rappresentazione del valore del sensore con una barra
  strokeWeight(30);
  stroke(0,100,0);
  line(20,400,700,400);
  strokeWeight(15);
  stroke(0,180,0);
  line(20,400,valore,400);
  
  // output.println(inString); 
} 
 
void serialEvent(Serial p) {
  // String timeString = timeFormat.format(new Date());
  // String inString = "";
  
  // inString = inString + p.readString();
  inString = p.readString();
}

void keyPressed() {
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  exit(); // Stops the program
}