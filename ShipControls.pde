

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


  APButton engDiffUp, engDiffDown;
  int engDiff = 0;

  public ShipControls(String title, PApplet parent) {
    super(title, parent);
    //control area at 280,20
    //annoyances
    buttonList.add( new ModButton(300, 50, "Damage\r\nShip", "/ship/damage") );
    buttonList.add( new ModButton(380, 50, "Reactor\r\nFail", "/system/reactor/fail") );
    buttonList.add( new ModButton(460, 50, "Self\r\nDestruct", "/system/reactor/overload") );
    buttonList.add( new ModButton(540, 50, "SD Cancel", "/system/reactor/overloadinterrupt") );

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
    text("Diff: " + engDiff, 680, 100);

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

