package processing.test.androidconsole;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import apwidgets.*; 
import oscP5.*; 
import netP5.*; 
import android.os.AsyncTask; 
import java.util.ArrayList; 
import android.view.MotionEvent; 
import java.util.Set; 

import processing.net.*; 
import apwidgets.*; 
import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class androidconsole extends PApplet {









ShipControls shipControls; 

APToggleButton toggle;

int rectSize = 100;
OscP5 oscP5;


NetAddress myRemoteLocation;                            
String serverIP = "192.168.0.17";  

PFont globalFont;
TabStrip tabStrip;

ControlPanel utilPanel, launchPanel, hyperPanel, dropPanel, warzonePanel, landPanel, deadPanel, lightPanel;

public void setup() {
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

public void draw() {

  background(0); //black background
  tabStrip.draw();
  shipControls.draw();
  stroke(255, 255, 255);
  line(260, 25, 260, height);
}

//onClickWidget is called when a widget is clicked/touched
public void onClickWidget(APWidget widget) {
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

public void oscEvent(OscMessage theOscMessage) {
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



public abstract class ControlPanel{
  
  String title = "";
  PApplet parent;
  APWidgetContainer widgetContainer;
  ArrayList<APWidget> buttonList = new ArrayList<APWidget>();
   
  boolean isVisible = false;
  protected int sceneId = -1;
  
  public ControlPanel(String title, PApplet parent){
    this.title = title;
    this.parent = parent;
    widgetContainer = new APWidgetContainer(parent);
  }
  
  public void setSceneNumber(int id){
    sceneId = id;
  }
  
  public int getSceneNumber(){
    return sceneId;
  }
  
  public void show(){
    if(widgetContainer != null){
      widgetContainer.show();
      isVisible = true;
    }
  }
  public void hide(){
    if(widgetContainer != null){
      widgetContainer.hide();
      isVisible = false;
    }
  }
  
  public String getTitle(){
    return title;
  }
  
  
  public abstract void draw();
  
  public void onWidget(APWidget widget){
    if(!buttonList.contains(widget)){
      return;
    }
     println("Clickbase");
     //check to see if its an OSC sending control
    try {
      ModButton mb = (ModButton)widget;
      new SendOSCTask().execute(mb.getOscMessages());
    } 
    catch (ClassCastException e) {
    }
    try {
      ModToggle mb = (ModToggle)widget;
      new SendOSCTask().execute(mb.getOscMessages());
    } 
    catch (ClassCastException e) {
    }
  }

  public abstract void oscReceive(OscMessage message);
}

public class ModButton extends APButton {
  String oscString = "/unnasigned";
  int value = 0;
  boolean sendValue = false;

  public ModButton (int x, int y, int w, int h, String title, String oscString) {
    super(x, y, w, h, title);
    this.oscString = oscString;
  }

  public void setValue(int value) {
    this.value = value;
    sendValue = true;
  }

  public ModButton(int x, int y, String title, String oscString) {

    super(x, y, title);
    this.oscString = oscString;
  }

  public OscMessage[] getOscMessages() {
    OscMessage m[] = new OscMessage[1];
    m[0] =  new OscMessage(oscString);
    if (sendValue) {
      m[0].add(value);
    }
    return m;
  }
}


public class ModToggle extends APToggleButton {
  String oscString = "/unnasigned";
  String serverMessage = "";
  boolean inverted = false;

  public ModToggle (int x, int y, int w, int h, String title, String oscString, boolean startState) {
    super(x, y, w, h, title);
    setChecked(startState);
    this.oscString = oscString;
    serverMessage = oscString;
  }

  public ModToggle(int x, int y, String title, String oscString, boolean startState) {
    super(x, y, title);
    setChecked(startState);
    this.oscString = oscString;
    serverMessage = oscString;
  }

  public void setInverted(boolean state) {
    inverted = state;
  }

  public boolean isInverted() {
    return inverted;
  }


  public OscMessage[] getOscMessages() {
    OscMessage m[] = new OscMessage[1];
    m[0] =  new OscMessage(oscString);
    m[0].add( isChecked() == (true & !inverted) ? 1 : 0 );
    return m;
  }

  public void setServerMessage(String s) {
    serverMessage = s;
  }

  public String getServerMessage() {
    return serverMessage;
  }

  public String getOscString() {
    return oscString;
  }
}



public class DropPanel extends ControlPanel {


  float altitude = 0;
  float[] temps = new float[6];
  String[] tempNames = {
    "Top Temp", "Bottom Temp", "Left Temp", "Right Temp", "Front Temp", "Back Temp"
  };

  boolean panelRepaired = false;
  boolean codeOk = false;


  public DropPanel(String title, PApplet parent) {
    super(title, parent);

    ModButton m =  new ModButton(20, 50, "Repair Panel", "/scene/drop/droppanelrepaired");
    m.setValue(1);
    buttonList.add( m );
    ModButton m2 =  new ModButton(150, 50, "Auth Code", "/scene/drop/droppanelrepaired");
    m2.setValue(2);
    buttonList.add(m2 );


    for (APWidget w : buttonList) {
      widgetContainer.addWidget(w);
    }

    //map this tab to a scene number from the game
    setSceneNumber(2);
  }

  public void show() {
    super.show();
    panelRepaired = false;
    codeOk = false;
  }

  public  void initGui() {
  }

  public  void draw() {

    textFont(globalFont, 15);

    for (int i = 0; i < 6; i++) {
      if (temps[i] < 200) {
        fill(0, 255, 0);
      } 
      else if (temps[i] >=200 && temps[i] <= 250) {
        fill(255, 255, 0);
      } 
      else {
        fill(255, 0, 0);
      }
      text(tempNames[i] + " : " + (int)temps[i], 10, 230 + i * 15);
    }

    fill(255, 255, 255);

    text("Altitude : " + altitude, 10, 210);
    if (panelRepaired) {
      text("Broken panel repaired, waiting for code", 10, 110);
    } 
    else {
      text("Waiting for panel repair", 10, 110);
    }
    if (codeOk) {
      text("CODE OK! Jump enabled", 10, 130);
    } 
    else {
      text("Waiting for code....", 10, 130);
    }
  }


  public  void oscReceive(OscMessage msg) {

    //loop through togglelist to see if the osc message appears there, if it does set the controls state
    for (APWidget w : buttonList) {
      try {
        ModToggle b = (ModToggle)w;
        if (b.getOscString().equals(msg.addrPattern())) {
          int val = msg.get(0).intValue();
          if (val == 0) {
            b.setChecked(false & !b.isInverted());
          } 
          else {
            b.setChecked(true & !b.isInverted());
          }
        }
      } 
      catch (ClassCastException e) {
      }
    }


    if (msg.checkAddrPattern("/scene/drop/statupdate")==true) {
      altitude = msg.get(0).floatValue();
      for (int t = 0; t < 6; t++) {
        temps[t] = msg.get(1+t).floatValue();
      }
    } 
    else if (msg.checkAddrPattern("/scene/drop/droppanelrepaired")==true) {
      int dat = msg.get(0).intValue();
      if (dat == 1) {
        panelRepaired = true;
      } 
      else if (dat == 2) {
        codeOk = true;
      }
    }
  }
}



public class EndGamePanel extends ControlPanel {


  
  public EndGamePanel(String title, PApplet parent) {
    super(title, parent);


    buttonList.add( new ModButton(20, 50, "Reset", "/game/reset") );
    

    for (APWidget w : buttonList) {
      widgetContainer.addWidget(w);
    }

   

    //map this tab to a scene number from the game
    setSceneNumber(5);
  }

  public  void initGui() {
  }

  public  void draw() {
    
  }

  public void onWidget(APWidget widget) {
    super.onWidget(widget);
   
  }


  public  void oscReceive(OscMessage message) {

  }
}



public class HyperPanel extends ControlPanel {
  int secondsUntilExit = 0;
  long exitTime = 0;
  boolean exiting = false;
  boolean failedExit = false;

  public HyperPanel(String title, PApplet parent) {
    super(title, parent);

    setSceneNumber(1);
  }

  public void show() {
    super.show();
    secondsUntilExit = 0;
    exitTime = 0;
    exiting = false;
    failedExit = false;
  }

  public  void initGui() {
  }

  public  void draw() {
    textFont(globalFont, 15);
    if (exiting) {

      text("State : Exiting!", 10, 130);
      text("exiting in: " + (secondsUntilExit*1000 - (millis() - exitTime)), 10, 145);
      if (failedExit) {
        text("FAILED JUMP - WARN PLAYERS OF ROUGH RIDE AND DAMAGE", 10, 1260);
      }
    } 
    else {
      text("State : In Jump", 10, 130);
    }
  }

  public  void oscReceive(OscMessage msg) {

    if (msg.checkAddrPattern("/scene/warp/failjump")) {
      exiting = true;
      failedExit = true;
      secondsUntilExit = msg.get(0).intValue();
      exitTime = millis();
    } 
    else if (msg.checkAddrPattern("/warpscene/exitjump")) {
      exiting = true;
      failedExit = false;
      exitTime = millis();
      secondsUntilExit = msg.get(0).intValue();
    }
  }
}



public class LandPanel extends ControlPanel {


  public LandPanel(String title, PApplet parent) {
    super(title, parent);
    //  ModButton mb = new ModButton(150, 50, "test button", "/string/test");
    // widgetContainer.addWidget(mb);

    buttonList.add( new ModToggle(20, 50, "Bay Doors", "/scene/launchland/dockingBay", true) );
    buttonList.add( new ModToggle(110, 50, "Grav", "/scene/launchland/bayGravity", false) );
    buttonList.add( new ModButton(170, 50, "Dock", "/scene/launchland/startDock") );

    buttonList.add( new ModButton(20, 150, "WIN THE GAME", "/game/gameWin") );

    for (APWidget w : buttonList) {
      widgetContainer.addWidget(w);
    }

    //map this tab to a scene number from the game
    setSceneNumber(4);
  }



  public  void initGui() {
  }

  public  void draw() {
  }


  public  void oscReceive(OscMessage message) {

  }
}



public class LaunchPanel extends ControlPanel {


  public LaunchPanel(String title, PApplet parent) {
    super(title, parent);
    //  ModButton mb = new ModButton(150, 50, "test button", "/string/test");
    // widgetContainer.addWidget(mb);

    buttonList.add( new ModToggle(20, 50, "Bay Doors", "/scene/launchland/dockingBay", false) );
    buttonList.add( new ModToggle(110, 50, "Grav", "/scene/launchland/bayGravity", true) );
    buttonList.add( new ModButton(170, 50, "Launch", "/scene/launchland/startLaunch") );
    ModToggle m =  new ModToggle(20, 100, "Clamp", "/system/misc/dockingClamp", true);
    m.setInverted(true);
    buttonList.add(m);
    buttonList.add( new ModToggle(80, 100, "Missiles?", "/scene/launchland/trainingMissiles", false) );

    buttonList.add( new ModButton(20, 250, "Launch NPC", "/scene/launchland/launchOtherShip") );
    buttonList.add( new ModButton(120, 250, "NPC to gate", "/scene/launchland/otherShipToGate") );
    buttonList.add( new ModButton(20, 300, "NPC hyper", "/scene/launchland/otherShipHyperspace") );

    for (APWidget w : buttonList) {
      widgetContainer.addWidget(w);
    }

    //map this tab to a scene number from the game
    setSceneNumber(0);
  }



  public  void initGui() {
  }

  public  void draw() {
  }


  public  void oscReceive(OscMessage message) {

    
  }
}


public class LightPanel extends ControlPanel {

  String[] lightingNames = {
    "idle", "warp", "red alert", "briefing"
  };
  int currentLightMode = 0;

  APRadioGroup lightGroup;
  APRadioButton[] radioList;
  ModToggle powerToggle;

  public LightPanel(String title, PApplet parent) {
    super(title, parent);
    lightGroup = new APRadioGroup(10, 100);
    lightGroup.setOrientation(APRadioGroup.VERTICAL);
    radioList = new APRadioButton[lightingNames.length];
    for (int i = 0; i < lightingNames.length; i++) {
      radioList[i] = new APRadioButton(lightingNames[i]);
      lightGroup.addRadioButton(radioList[i]);
    }
    radioList[0].setChecked(true);
    widgetContainer.addWidget(lightGroup);

    powerToggle = new ModToggle(10, 60, "lightpower", "/system/effect/lightingPower", false);
    buttonList.add(powerToggle);
    widgetContainer.addWidget(powerToggle);
  }


  public void onWidget(APWidget widget) {
    super.onWidget(widget);
    
    if (widget instanceof APRadioButton) {
      String t = ((APRadioButton)widget).getText();
      for (int i = 0; i < lightingNames.length; i++) {
        if (lightingNames[i].equals(t)) {
          OscMessage m = new OscMessage("/system/effect/lightingMode");
          m.add(i);
          new SendOSCTask().execute(m);
          break;
        }
      }
    }
  }

  public  void initGui() {
  }

  public  void draw() {
    text(lightingNames[currentLightMode], 10, 50);
  }

  public  void oscReceive(OscMessage message) {
  }
}



public class ShipControls extends ControlPanel {
  public boolean reactorState = false;
  public boolean autoPilotState = false;
  public boolean canJump = false;
  public float hull = 0;
  public float jumpCharge = 0;
  public float oxygenLevel = 0;
  public int undercarriageState = 0;
  public int failureCount = 0;
  private String[] undercarriageStrings = {
    "up", "down", "Lowering..", "Raising.."
  };


  APButton engDiffUp, engDiffDown, killButton;
  int engDiff = 0;

  public ShipControls(String title, PApplet parent) {
    super(title, parent);
    //control area at 280,20
    //annoyances
    buttonList.add( new ModButton(300, 50, "Damage\r\nShip", "/ship/damage") );
    buttonList.add( new ModButton(380, 50, "Reactor\r\nFail", "/system/reactor/fail") );
    buttonList.add( new ModButton(460, 50, "Self\r\nDestruct", "/system/reactor/overload") );
    buttonList.add( new ModButton(540, 50, "SD Cancel", "/system/reactor/overloadinterrupt") );
    killButton = new APButton(620, 50, "kill ship");
    buttonList.add( killButton);

    //ship systems
    buttonList.add( new ModToggle(300, 120, "Reactor\r\nstate", "/system/reactor/setstate", false));
    buttonList.add( new ModToggle(380, 120, "Prop\r\nstate", "/system/propulsion/state", false));
    buttonList.add( new ModToggle(460, 120, "Jump\r\nstate", "/system/jump/state", false));
    buttonList.add( new ModToggle(540, 120, "blast\r\nshield", "/system/misc/blastShield", true));
    buttonList.add( new ModToggle(620, 120, "Gear\r\nstate", "/system/undercarriage/state", true));
    buttonList.add( new ModToggle(680, 120, "eng\r\n puzzle", "/system/powerManagement/failureState", false));

    //eng difficulty  MOVE ME THESE ARE SHIT
    engDiffUp = new APButton(750, 120, 40, 40, "+");
    engDiffDown = new APButton(750, 170, 40, 40, "-");
    widgetContainer.addWidget(engDiffUp);
    widgetContainer.addWidget(engDiffDown);


    //vid calls
    buttonList.add( new ModButton(700, 280, "Vid Call", "/clientscreen/CommsStation/incomingCall") );
    buttonList.add( new ModButton(700, 340, "hang up", "/clientscreen/CommsStation/hangUp") );

    //screen power
    buttonList.add( new ModToggle(300, 210, "pilot", "/pilot/powerState", false));
    buttonList.add( new ModToggle(380, 210, "tactical", "/tactical/powerState", false));
    buttonList.add( new ModToggle(460, 210, "comms", "/comms/powerState", false));
    buttonList.add( new ModToggle(540, 210, "engineer", "/engineer/powerState", false));


    buttonList.add( new ModButton(620, 340, "Jump", "/system/jump/startJump") );
    buttonList.add( new ModToggle(540, 340, "autopilot", "/system/control/controlState", false));
    for (APWidget w : buttonList) {
      widgetContainer.addWidget(w);
    }
  }



  public void draw() {
    textFont(globalFont, 15);
    text("Annoyances", 290, 45);
    text("Systems", 290, 115);
    text("Screens", 290, 205);
    noFill();
    stroke(255, 255, 255);
    rect(690, 270, width-690, height-270);
    text("Diff: " + engDiff, 680, 250);

    text("failed reactor systems: " + failureCount + "/8", 280, 300);
    text("reactor On?: " + reactorState, 280, 320);
    text("Can jump? : " + canJump, 280, 340);
    if(canJump){
      noFill();
      stroke(0,255,0);
      rect(610,330, 60,50);
    }

    text("Hull Health: " + hull, 280, 360);
    text("o2 Level: " + oxygenLevel, 280, 380);
    text("Jump Charge: " + jumpCharge, 280, 400);
    text("Undercarriage: " + undercarriageStrings[undercarriageState], 280, 420);
    
    text("autopilot on?: " + autoPilotState, 500, 400);
  }

  public void onWidget(APWidget widget) {
    if (buttonList.contains(widget)) {
      super.onWidget(widget);
    }

    if (widget == engDiffUp) {
      engDiff++;
      if (engDiff > 10) {
        engDiff = 10;
      }
      OscMessage m = new OscMessage("/system/powerManagement/failureSpeed");
      m.add(engDiff);
      new SendOSCTask().execute(m);
    } 
    else if (widget == engDiffDown) {
      engDiff--;
      if (engDiff < 1) {
        engDiff = 1;
      }
      OscMessage m = new OscMessage("/system/powerManagement/failureSpeed");
      m.add(engDiff);
      new SendOSCTask().execute(m);
    } else if(widget == killButton){
      OscMessage m = new OscMessage("/game/KillPlayers");
      m.add("Dead");
      new SendOSCTask().execute(m);
    }
      
  }

  public void oscReceive(OscMessage message) {


    if (message.checkAddrPattern("/ship/jumpStatus") == true) {  
      canJump = message.get(0).intValue() == 1 ? true : false;
    } 
    else if (message.checkAddrPattern("/ship/stats") == true) {  
      hull = message.get(2).floatValue();
      jumpCharge = message.get(0).floatValue() * 100.0f;
      oxygenLevel = message.get(1).floatValue();
    } 
    else if (message.checkAddrPattern("/system/powerManagement/failureCount")) {
      failureCount = message.get(0).intValue();
    } 
    else if (message.checkAddrPattern("/ship/undercarriage")) {
      undercarriageState = message.get(0).intValue();
    } 
    else if (message.checkAddrPattern("/system/reactor/stateUpdate")==true) {
      int s = message.get(0).intValue();
      if (s == 0) {
        reactorState = false;
      } 
      else {
        reactorState = true;
      }
    }
    else if (message.checkAddrPattern("/system/control/controlState")==true) {
      autoPilotState = message.get(0).intValue() == 1 ? true : false;
    }
  }
}



public class TabStrip {

  HashMap<String, ControlPanel> tabMap = new HashMap();

  ControlPanel currentPanel;

  String[] tabNames = new String[0];
  int activeIndex = 0;

  public TabStrip() {
  }

  public void clickEvent(int x, int y) {
    if (y < 40) {
      textFont(globalFont, 13);
      int startX = 15;
      int ind = 0;
      for (String s : tabNames) {
        int width = (int)textWidth(s);
        if (x > startX && x < startX + width + 10) {
          switchToTab(s);
        }

        startX += 10 + width;
        ind++;
      }
    }
  }

  public void draw() {
    stroke(255, 255, 255);
    line(0, 25, width, 25);

    textFont(globalFont, 13);
    int startX = 15;
    int ind = 0;
    for (String s : tabNames) {
      int width = (int)textWidth(s);
      if (activeIndex == ind) {
        fill(255, 255, 0);
      } 
      else {
        fill(255, 255, 255);
      }
      text(s, startX + 10, 20);
      startX += 10 + width;
      ind++;
    }
    noStroke();
    currentPanel.draw();
  }

  public void switchToTab(int sceneId) {
    for (ControlPanel c : tabMap.values()) {
      if (c.getSceneNumber() == sceneId) {
        if ( currentPanel != null ) currentPanel.hide();
        currentPanel = c;
        currentPanel.show();
      }
    }
    int ind = 0;
    for (String s : tabNames) {
      if (s.equals(currentPanel.getTitle())) {
        activeIndex = ind;
      }
      ind++;
    }
  }

  public void switchToTab(String title) {
    ControlPanel c = tabMap.get(title);
    if (c != null) {
      if (currentPanel != null) {
        currentPanel.hide();
      }
      currentPanel = c;
      currentPanel.show();
    }
    int ind = 0;
    for (String s : tabNames) {
      if (s.equals(currentPanel.getTitle())) {
        activeIndex = ind;
      }
      ind++;
    }
  }

  public ControlPanel getActivePanel() {
    return currentPanel;
  }


  public void addPanel(ControlPanel panel) {
    tabMap.put(panel.getTitle(), panel);
    println("added tab: " + panel.getTitle());
    Set<String> keys = tabMap.keySet();
    tabNames = keys.toArray(new String[0]);
    panel.hide();
  }
}


public class UtilityPanel extends ControlPanel {

  APEditText edit;

  APButton setIpButton;


  public UtilityPanel(String title, PApplet parent) {
    super(title, parent);
    setIpButton = new APButton(150, 110, "Set Server IP"); 
    edit = new APEditText(10, 110, 100, 40);

    widgetContainer.addWidget(setIpButton); 
    widgetContainer.addWidget(edit);
  }


  public void onWidget(APWidget widget) {
    super.onWidget(widget);
    if (widget == setIpButton) { //if it was SetIpButton that was clicked
      //set server ip;
      serverIP = edit.getText();
      println("server ip set to: " + serverIP);
    }

  }

  public  void initGui() {
  }

  public  void draw() {
    textFont(globalFont, 15);
    text("IP: " + serverIP, 10, 180);
  }

  public  void oscReceive(OscMessage message) {
  }
}



public class WarzonePanel extends ControlPanel {


  String[] beamExcuses = { 
    "Beamed aboard, waiting for airlock..", "Beam blocked", "You broke in, prepare to shoot", "you were dumped out of airlock"
  };
  int currentExcuse = -1;

  long beamFailTime = 0;

  int missileDifficulty = 1;
  int beamDifficulty = 1;
  APButton diffUp, diffDown;
  APButton beamUp, beamDown;
  APButton beamButton;

  public WarzonePanel(String title, PApplet parent) {
    super(title, parent);


    buttonList.add( new ModButton(20, 50, "Start War", "/scene/warzone/warzonestart") );
    //buttonList.add( new ModButton(110, 50, "Beam Attempt", "/system/transporter/startBeamAttempt") );
    buttonList.add( new ModButton(20, 100, "Spawn Gate", "/scene/warzone/spawnGate") );
    buttonList.add( new ModButton(120, 100, "Shoot at ship", "/scene/warzone/createBastard") );

    buttonList.add( new ModToggle(20, 150, "Missiles?", "/scene/warzone/missileLauncherStatus", false) );

    /*
    buttonList.add( new ModToggle(80, 100, "Missiles?", "/scene/launchland/trainingMissiles", false) );
     
     buttonList.add( new ModButton(20, 250, "Launch NPC", "/scene/launchland/launchOtherShip") );
     buttonList.add( new ModButton(120, 250, "NPC to gate", "/scene/launchland/otherShipToGate") );
     buttonList.add( new ModButton(20, 300, "NPC hyper", "/scene/launchland/otherShipHyperspace") );*/

    for (APWidget w : buttonList) {
      widgetContainer.addWidget(w);
    }

    diffUp = new APButton(180, 200, 40, 40, "+");
    diffDown = new APButton(20, 200, 40, 40, "-");
    widgetContainer.addWidget(diffUp);
    widgetContainer.addWidget(diffDown);

    beamUp = new APButton(180, 300, 40, 40, "+");
    beamDown = new APButton(20, 300, 40, 40, "-");
    widgetContainer.addWidget(beamUp);
    widgetContainer.addWidget(beamDown);

    beamButton = new APButton(110, 340, "Beam Attempt");
    widgetContainer.addWidget(beamButton);

    //map this tab to a scene number from the game
    setSceneNumber(3);
  }

  public void show() {
    super.show();
    currentExcuse = -1;
  }


  public  void initGui() {
  }

  public  void draw() {
    textFont(globalFont, 13);
    text("Missile\r\nDifficulty: " + missileDifficulty, 60, 216);
    textFont(globalFont, 13);
    text("Beam\r\nDifficulty: " + beamDifficulty, 60, 320);


    text("Beam status:", 10, 260 );
    if (currentExcuse!=-1) {
      fill(255, 255, 255);


      if (currentExcuse == 2) {
        int ran = (int)random(255);
        fill(ran, 0, 0);
        text("SHOOT THE PLAYERS: " + (5 - (millis() - beamFailTime) / 1000), 10, 290);
        fill(255, 255, 255);
      } 
      else {
        text(beamExcuses[currentExcuse], 10, 290);
      }
    }
  }

  public void onWidget(APWidget widget) {
    super.onWidget(widget);
    if (widget == diffUp) {
      missileDifficulty += 1;
      if (missileDifficulty >= 10) {
        missileDifficulty = 10;
      }
      OscMessage m = new OscMessage("/scene/warzone/missileRate");
      m.add(missileDifficulty);
      new SendOSCTask().execute(m);
    } 
    else if (widget == diffDown) {
      missileDifficulty -= 1;
      if (missileDifficulty < 1) {
        missileDifficulty = 1;
      }
      OscMessage m = new OscMessage("/scene/warzone/missileRate");
      m.add(missileDifficulty);
      new SendOSCTask().execute(m);
    } 
    else if (widget == beamDown) {
      beamDifficulty -= 1;
      if (beamDifficulty < 1) {
        beamDifficulty = 1;
      }
    } 
    else if (widget == beamUp) {
      beamDifficulty += 1;
      if (beamDifficulty > 10) {
        beamDifficulty = 10;
      }
    }
    else if (widget == beamButton) {
      OscMessage m = new OscMessage("/system/transporter/startBeamAttempt");
      m.add(beamDifficulty);
      new SendOSCTask().execute(m);
    }
  }

  public  void oscReceive(OscMessage message) {



    if (message.checkAddrPattern("/system/transporter/beamAttemptResult")) {
      int p = message.get(0).intValue();
      currentExcuse = p;
      if (p == 2) {
        beamFailTime = millis();
      }
    }
  }
}


}
