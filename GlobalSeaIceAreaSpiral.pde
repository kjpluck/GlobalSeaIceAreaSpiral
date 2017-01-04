
import com.hamoid.*;

VideoExport videoExport;

StringList _seaIceData;
int _frameCount = 0;
int _lineCount = 0;
PFont _font;
color purple = color(127, 0, 127);
color red = color(255, 255, 0);
int _width = 1000;
int _height = 1000;
int _halfWidth = _width/2;
int _halfHeight = _height/2;


void setup() {
	size(1000, 1000);
  background(60,0,60);
  background(100);
  fill(60,0,60);
  ellipse(_halfWidth, _halfHeight, 850, 850);
  fill(255);
	stroke(255);
  strokeWeight(4);
  
  //line(0,_halfHeight, _width, _halfHeight);
  //line(_halfWidth, 0, _halfWidth, _height);
  
  frameRate(30);
  
  textSize(20);
  text("Global Sea Ice Area 1978 - 2017", 10, 30);
  text("@kevpluck", 10, 60);
  textSize(10);
  text("Sea Ice Concentrations from Nimbus-7 SMMR and DMSP SSM/I-SSMIS Passive Microwave Data (NSIDC-0051), Near-Real-Time DMSP SSMIS Daily Polar Gridded Sea Ice Concentrations", 10, _height - 12);
  
  textSize(32);
	_seaIceData = filterFile();

  makeClock();
  
  videoExport = new VideoExport(this);
  videoExport.setFrameRate(30);
  videoExport.startMovie();
}
 //<>//
boolean _drawLine = false;
int _lastX = 0;
int _lastY = 0;
int _skip = 20;

void draw(){
  
  if(_frameCount >= _lineCount) {
    videoExport.saveFrame();
    return;
  };
  
  int start = _frameCount++ * _skip;
  int end = start + _skip;
  
  for(int c = start; c < end; c++)
  {
    String[] seaIceDatum = split(_seaIceData.get(c), ',');
    
    String[] dateTime = split(seaIceDatum[0], '-');
    
    fill(60,0,60);
    noStroke(); //<>//
    rect(450,460,150,150);
    stroke(255);
    fill(255);
    text(dateTime[0], 460, 510);
    
    int year = int(dateTime[0]);
    int yearDay = int(trim(split(seaIceDatum[1],'.')[0]));
    
    if(year>2015 && yearDay > 250 && _skip>1) 
    {
      _frameCount = end;
      _skip = 1;
    }
    
    int daysInYear = 365;
        
    float area = float(seaIceDatum[3]);
    
    if(year % 4 == 0) daysInYear = 366;
    
    int x = int(18 * area * cos(TWO_PI *  yearDay/daysInYear - HALF_PI));
    int y = int(18 * area * sin(TWO_PI *  yearDay/daysInYear - HALF_PI));
    
    if(x==0 && y==0)
    {
      _drawLine = false;
      continue;
    }
    
    if(_drawLine)
    {
      float lerp = float(year-1978)/float(2016-1978);
      stroke(lerpColor(purple, red, lerp));
      line(500 + _lastX, 500 + _lastY, 500 + x, 500 + y);
    }
    
    _lastX = x;
    _lastY = y;
    _drawLine = true;
  }
  
  videoExport.saveFrame();
}

void keyPressed() {
  if (key == 'q') {
    videoExport.endMovie();
    exit();
  }
}

StringList filterFile()
{
	StringList toReturn = new StringList();
  String[] lines = loadStrings("nsidc_global_nt_final_and_nrt.txt");
  
	for (String line : lines) {
	  if(line.charAt(0) == '#' || line.charAt(0) == ' ') continue;
    _lineCount++;
	  toReturn.append(line);
	}

	return toReturn;
}

void makeClock(){
  
  translate(_halfWidth, _halfHeight);
  text("Jan", -25, -450);
  rotate(PI/6);
  text("Feb", -25, -450);
  rotate(PI/6);
  text("Mar", -25, -450);
  rotate(PI/6);
  text("Apr", -25, -450);
  rotate(PI/6);
  text("May", -25, -450);
  rotate(PI/6);
  text("Jun", -25, -450);
  rotate(PI/6);
  text("Jul", -25, -450);
  rotate(PI/6);
  text("Aug", -25, -450);
  rotate(PI/6);
  text("Sep", -25, -450);
  rotate(PI/6);
  text("Oct", -25, -450);
  rotate(PI/6);
  text("Nov", -25, -450);
  rotate(PI/6);
  text("Dec", -25, -450);
}