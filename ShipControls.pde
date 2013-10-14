

public class ShipControls extends ControlPanel {

  ArrayList<APWidget> buttonList = new ArrayList<APWidget>();

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
    buttonList.add( new ModToggle(380, 120, "Prop\r\nstate", "/system/propulsion/setstate", false));
    buttonList.add( new ModToggle(460, 120, "Jump\r\nstate", "/system/jump/setstate", false));
    buttonList.add( new ModToggle(540, 120, "blast\r\nshield", "/system/misc/blastShield", false));
    buttonList.add( new ModToggle(620, 120, "Gear\r\nstate", "/system/undercarriage/setstate", false));
    buttonList.add( new ModToggle(680, 120, "eng\r\n puzzle", "/system/powerManagement/failureState", false));
    
    //eng difficulty  MOVE ME THESE ARE SHIT
    engDiffUp = new APButton(750, 120, 40, 40, "+");
    engDiffDown = new APButton(750, 170, 40, 40, "-");
    widgetContainer.addWidget(engDiffUp);
    widgetContainer.addWidget(engDiffDown);


    //vid calls
    buttonList.add( new ModButton(700, 280, "Vid Call", "") );
    buttonList.add( new ModButton(700, 340, "hang up", "") );

    //screen power
    buttonList.add( new ModToggle(300, 210, "pilot", "/pilot/powerState", false));
    buttonList.add( new ModToggle(380, 210, "tactical", "/tactical/powerState", false));
    buttonList.add( new ModToggle(460, 210, "comms", "/comms/powerState", false));
    buttonList.add( new ModToggle(540, 210, "engineer", "/engineer/powerState", false));



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
  }



  public void oscReceive(OscMessage message) {
  }
}

