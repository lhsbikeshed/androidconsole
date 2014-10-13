import apwidgets.*;
import oscP5.*;
import netP5.*;
import android.os.AsyncTask;
import java.util.ArrayList;
import android.view.MotionEvent;


ShipControls shipControls; 

APToggleButton toggle;

int rectSize = 100;
OscP5 oscP5;


NetAddress myRemoteLocation;                            
String serverIP = "10.0.0.100";  

PFont globalFont;
TabStrip tabStrip;

ControlPanel utilPanel, launchPanel, hyperPanel, dropPanel, warzonePanel, landPanel, deadPanel, lightPanel;
APMediaPlayer player;

int missilesInPlay = 0;

//mission timer 
// althought technically part of the warzone stuff I've put it in this class
// as having it globally available is more useful. It also means that if the tab is wrong when the timer starts we dont
// miss the start signal
long countdownStartTime = 1000;
boolean countdownRunning = false;
long countdownDuration = 900000;//900000; //15 min defaul


//drawing offset
int offset = 0;
int startOffset = 0;
MyScrollView scrollView;


void setup() {
  orientation(LANDSCAPE);

  oscP5 = new OscP5(this, 12005);
  shipControls = new ShipControls("ship", this); 


  globalFont = createFont("Monospaced-Bold", 20);


  tabStrip = new TabStrip();
  utilPanel = new UtilityPanel("util", this);
  tabStrip.addPanel(utilPanel);
  // tabStrip.addPanel(shipControls, "shipControls");
  lightPanel = new LightPanel("light", this);
  tabStrip.addPanel(lightPanel);

  launchPanel = new LaunchPanel("launch", this);
  tabStrip.addPanel(launchPanel);

  hyperPanel = new HyperPanel("Hyper", this);
  tabStrip.addPanel(hyperPanel);

  dropPanel = new DropPanel("Drop", this);
  tabStrip.addPanel(dropPanel);

  warzonePanel = new WarzonePanel("War", this);
  tabStrip.addPanel(warzonePanel);

  landPanel = new LandPanel("land", this);
  tabStrip.addPanel(landPanel);

  deadPanel = new EndGamePanel("dead", this);
  tabStrip.addPanel(deadPanel);



  tabStrip.switchToTab("utilities");

  player = new APMediaPlayer(this); //create new APMediaPlayer

  scrollView = (MyScrollView)getWindow().findViewById(983475893);
  if (scrollView == null) {
    println("NULL SCROLL VIEW");
  }
}

public void playSound(String s) {
  player.setMediaFile(s);
  player.start();
}

public void onDestroy() {
  super.onDestroy(); //call onDestroy on super class
  if (player!=null) { //must be checked because or else crash when return from landscape mode
    player.release(); //release the player
  }
}

void draw() {

  background(0); //black background



  tabStrip.draw();

  if (scrollView != null) {
    offset = scrollView.getScrollY();

   
  }
  pushMatrix();
  translate(0, -offset);
  shipControls.draw();
  popMatrix();
  stroke(255, 255, 255);
  line(260, 25, 260, height);
}

//onClickWidget is called when a widget is clicked/touched
void onClickWidget(APWidget widget) {
  tabStrip.getActivePanel().onWidget(widget);
  shipControls.onWidget(widget);
}



private class SendOSCTask extends AsyncTask<OscMessage, Void, String> {
  protected String doInBackground(OscMessage... Messages) {
    for (OscMessage message : Messages) {

      oscP5.send(message, new NetAddress(serverIP, 12000));
      println("Sending: " + message.addrPattern());
    }

    return "done";
  }
  protected void onProgressUpdate() {
    // setProgressPercent(progress[0]);
  }

  protected void onPostExecute() {
    // showDialog("Downloaded " + result + " bytes");
  }
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/scene/change")==true) {
    int scene = theOscMessage.get(0).intValue();
    tabStrip.switchToTab(scene);
    if(scene == 0){
      missilesInPlay = 0;
    }
  } 
  else if (theOscMessage.checkAddrPattern("/scene/warzone/missilelaunch")) {
    missilesInPlay++;
  } 
  else if (theOscMessage.checkAddrPattern("/scene/warzone/missileexplode")) {
    missilesInPlay--;
  } 
  else if (theOscMessage.checkAddrPattern("/game/reset")) {
    missilesInPlay = 0;
    countdownRunning = false;
  } 
  else if (theOscMessage.checkAddrPattern("/scene/warzone/evacStart")) {
    countdownRunning = true;
    countdownStartTime = millis();
    countdownDuration = (long)theOscMessage.get(0).intValue();
  }
  // println("ass");
  //pass to active tab
  tabStrip.getActivePanel().oscReceive(theOscMessage);
  shipControls.oscReceive(theOscMessage);
}

@Override
public boolean dispatchTouchEvent(MotionEvent event) {

  int x = (int)event.getX();                              // get x/y coords of touch event
  int y = (int)event.getY();

  int action = event.getActionMasked();          // get code for action

  switch (action) {                              // let us know which action code shows up
  case MotionEvent.ACTION_DOWN:

    tabStrip.clickEvent(x, y);
    break;
  }

  return super.dispatchTouchEvent(event);        // pass data along when done!
}

