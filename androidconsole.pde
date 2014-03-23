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

void setup() {
  orientation(LANDSCAPE);
  
  oscP5 = new OscP5(this, 12005);
  shipControls = new ShipControls("ship", this); 


  globalFont = createFont("Monospaced-Bold", 20);


  tabStrip = new TabStrip();
  utilPanel = new UtilityPanel("utilities", this);
  tabStrip.addPanel(utilPanel);
  // tabStrip.addPanel(shipControls, "shipControls");


  launchPanel = new LaunchPanel("launch", this);
  tabStrip.addPanel(launchPanel);

  hyperPanel = new HyperPanel("Hyperspace", this);
  tabStrip.addPanel(hyperPanel);

  dropPanel = new DropPanel("Dropscene", this);
  tabStrip.addPanel(dropPanel);

  warzonePanel = new WarzonePanel("Warzone", this);
  tabStrip.addPanel(warzonePanel);
  
  landPanel = new LandPanel("landing", this);
  tabStrip.addPanel(landPanel);
  
  deadPanel = new EndGamePanel("dead", this);
  tabStrip.addPanel(deadPanel);

  lightPanel = new LightPanel("lighting", this);
  tabStrip.addPanel(lightPanel);

  tabStrip.switchToTab("utilities");
}

void draw() {

  background(0); //black background
  tabStrip.draw();
  shipControls.draw();
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

