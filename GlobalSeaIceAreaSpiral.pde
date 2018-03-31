
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
  strokeWeight(4);
  
  frameRate(30);
	_seaIceData = filterFile();

  
  videoExport = new VideoExport(this);
  videoExport.setFrameRate(30);
  videoExport.startMovie();
}

boolean _drawLine = false;
boolean _drawRecordLow = false; //<>//
int _lastX = 0;
int _lastY = 0;
int _skip = 60;
float _currentLow = Float.MAX_VALUE;


void drawBackground()
{
  background(100);
  noStroke();
  fill(70,0,70);
  ellipse(_halfWidth, _halfHeight, 850, 850);
  
  
  fill(60,0,60);
  noStroke();
  ellipse(_halfWidth, _halfHeight, 17.8 * 20 * 2, 17.8 * 20 * 2);
  fill(70,0,70);
  ellipse(_halfWidth, _halfHeight, 17.8 * 15 * 2, 17.8 * 15 * 2);
  fill(60,0,60);
  ellipse(_halfWidth, _halfHeight, 17.8 * 10 * 2, 17.8 * 10 * 2);
  
  fill(255);
  textSize(15);
  text("20M Km²",_halfWidth - 30, _halfHeight - 17.8 * 20 + 20);
  text("15M Km²",_halfWidth - 30, _halfHeight - 17.8 * 15 + 20);
  text("10M Km²",_halfWidth - 30, _halfHeight - 17.8 * 10 + 20);
  
  
  textSize(30);
  text("Global Sea Ice Area\n1978 - 2017\n@kevpluck", 10, 40);
  textSize(10);
  text("Sea Ice Concentrations from Nimbus-7 SMMR and DMSP SSM/I-SSMIS Passive Microwave Data (NSIDC-0051), Near-Real-Time DMSP SSMIS Daily Polar Gridded Sea Ice Concentrations", 10, _height - 12);
  
  textSize(32);
  makeClock();
  
}

  
int _end = 0;
int _year = 0;
float _angleOfRecord = 0.0;
int _yearOfRecord = 1979;
int _endPauseFrameCount = 0;
void draw(){
  
  drawBackground();
  
  if(_frameCount < _lineCount) 
  {
    _end = (_frameCount++ * _skip) + _skip;
    _year = 0;
  }
  else
  {
    _endPauseFrameCount++;
  };
  
  for(int c = 2; c < _end; c++)
  {
    String[] seaIceDatum = split(_seaIceData.get(c), ',');
    
    String[] dateTime = split(seaIceDatum[0], '-');
     //<>//
    
    _year = int(dateTime[0]);
    int yearDay = int(trim(split(seaIceDatum[1],'.')[0]));
    
    if(_year>2015 && yearDay > 250 && _skip>1) 
    {
      _frameCount = _end;
      _skip = 1;
    }
    
    int daysInYear = 365;
        
    float area = float(seaIceDatum[3]);
    
    if(_year % 4 == 0) daysInYear = 366;
    
    int x = int(18 * area * cos(TWO_PI *  yearDay/daysInYear - HALF_PI));
    int y = int(18 * area * sin(TWO_PI *  yearDay/daysInYear - HALF_PI));
    
    if(x==0 && y==0)
    {
      _drawLine = false;
      continue;
    }
    
    if(_drawLine)
    {
      float lerp = float(_year-1978)/float(2016-1978);
      stroke(lerpColor(purple, red, lerp));
      strokeWeight(4);
      line(500 + _lastX, 500 + _lastY, 500 + x, 500 + y);
    }
    
    _lastX = x;
    _lastY = y;
    _drawLine = true;
    
    
    if(area < _currentLow)
    {
      _currentLow = area;
      _angleOfRecord = TWO_PI *  yearDay/daysInYear;
      _yearOfRecord = _year;
      if(yearDay > 30 && yearDay < 180)
      {        
        _drawRecordLow = true;
      }
    }
  }
    
  if(_drawRecordLow)
  {
    pushStyle();
      textAlign(CENTER);
      noFill();
      stroke(90,0,90);
      strokeWeight(4);
      //ellipse(_halfWidth, _halfHeight, 17.7 * _currentLow * 2, 17.7 * _currentLow * 2);
      fill(255);
      textSize(15);
      
      translate(_halfWidth, _halfHeight);
      rotate(_angleOfRecord);
      stroke(255);
      line(0, - 16 * _currentLow - 15, 0, - 16 * _currentLow - 25);
      text(String.format("%.1fM Km²\n%d", _currentLow, _yearOfRecord), 0 , - 16 * _currentLow);
      rotate(-_angleOfRecord);
        
      translate(-_halfWidth, -_halfHeight);
    popStyle();
  }
  
  textSize(32);
  stroke(255);
  fill(255);
  text(_year, 460, 510);
  _drawLine = false;
  videoExport.saveFrame();
  
  if(_endPauseFrameCount > 210)
  {
    videoExport.endMovie();
    exit();
  }
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
  rotate(PI/6);
  
  translate(-_halfWidth, -_halfHeight);
}