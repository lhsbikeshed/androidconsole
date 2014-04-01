

public class ShipControls extends ControlPanel {
  public boolean reactorState = false;
  public boolean autoPilotState = false;
  public boolean canJump = false;
  public float hull = 0;
  public float jumpCharge = 0;
  public float oxygenLevel = 0;
  public int undercarriageState = 0;
  public int failureCount = 0;
  public int maxFailures = 0;
  private String[] undercarriageStrings = {
    "up", "down", "Lowering..", "Raising.."
  };

  long lastCommsKA = 0;

  APButton engDiffUp, engDiffDown, killButton;
  int engDiff = 0;
  long missionStartTime = 0;

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
    buttonList.add( new ModToggle(300, 120, "Reactor", "/system/reactor/setstate", false));
    buttonList.add( new ModToggle(380, 120, "Prop", "/system/propulsion/state", false));
    buttonList.add( new ModToggle(460, 120, "Jump", "/system/jump/state", false));
    buttonList.add( new ModToggle(540, 120, "Blast\r\nShield\r\nDown", "Blast\r\nShield\r\nUp", "/system/misc/blastShield", true));
    buttonList.add( new ModToggle(610, 120, "Land\r\nGear\r\nDown", "Land\r\nGear\r\nUp", "/system/undercarriage/state", true));
    buttonList.add( new ModToggle(680, 120, "Eng\r\nPuzzle\r\nOn", "Eng\r\nPuzzle\r\nOff", "/system/powerManagement/failureState", true));

    //eng difficulty  MOVE ME THESE ARE SHIT
    engDiffUp = new APButton(750, 120, 40, 40, "+");
    engDiffDown = new APButton(750, 170, 40, 40, "-");
    widgetContainer.addWidget(engDiffUp);
    widgetContainer.addWidget(engDiffDown);


    //vid calls
    buttonList.add( new ModButton(700, 280, "Vid Call", "/clientscreen/CommsStation/incomingCall") );
    buttonList.add( new ModButton(700, 340, "hang up", "/clientscreen/CommsStation/hangUp") );

    //screen power
    buttonList.add( new ModToggle(300, 210, "Pilot", "/pilot/powerState", false));
    buttonList.add( new ModToggle(380, 210, "Tactical", "/tactical/powerState", false));
    buttonList.add( new ModToggle(460, 210, "Comms", "/comms/powerState", false));
    buttonList.add( new ModToggle(540, 210, "Engineer", "/engineer/powerState", false));


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
    
    //rectangle around comms buttons
    stroke(255, 255, 255);
    int c = 255 - (int)map(millis() - lastCommsKA, 0, 500, 0, 255);
    if(c < 0) { c = 0; }
    
    fill(c,c, 0);
    rect(690, 270, width-690, height-270);
    fill(255);
    
    
    text("Diff: " + engDiff, 680, 210);

    text("failed reactor systems: " + failureCount + " / " + maxFailures, 280, 300);
    text("reactor On?: " + reactorState, 280, 320);
    text("Can jump? : " + canJump, 280, 340);
    if(canJump){
      noFill();
      strokeWeight(3);
      stroke(255,255,0);
      rect(610,330, 60,50);
      strokeWeight(1);
    }

    text("Hull Health: " + hull, 280, 360);
    text("o2 Level: " + oxygenLevel, 280, 380);
    text("Jump Charge: " + jumpCharge, 280, 400);
    text("Undercarriage: " + undercarriageStrings[undercarriageState], 280, 420);
    
    text("AP?: " + autoPilotState, 530, 400);
    
    long t = millis() - missionStartTime;
    int min = (int)((t / 1000 / 60) % 60);
    int sec = (int)((t / 1000) % 60);
    
    text("T: " + (min < 10 ? "0" + min : min) + ":" + (sec < 10 ? "0" + sec : sec), 630, 230);
    
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
      jumpCharge = message.get(0).floatValue() * 100.0;
      oxygenLevel = message.get(1).floatValue();
    } 
    else if (message.checkAddrPattern("/system/powerManagement/failureCount")) {
      failureCount = message.get(0).intValue();
      maxFailures = message.get(1).intValue();
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
    } else if (message.checkAddrPattern("/game/reset")) {
      missionStartTime = millis();
    } else if (message.checkAddrPattern("/display/captain/inCall")){
      lastCommsKA = millis();
    }
  }
}

