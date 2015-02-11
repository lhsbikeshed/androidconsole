

public class LaunchPanel extends ControlPanel {


  public LaunchPanel(String title, PApplet parent) {
    super(title, parent);
    sceneTag = "launch";
    //  ModButton mb = new ModButton(150, 50, "test button", "/string/test");
    // widgetContainer.addWidget(mb);
    buttonList.add( new ModButton(20, 50, "Launch", "/scene/launchland/startLaunch") );
    
    buttonList.add( new ModToggle(110, 50, "Grav\r\nOn", "Grav\r\nOff", "/scene/launchland/bayGravity", true) );
    buttonList.add( new ModToggle(170, 50, "Bay Doors\r\nOpen", "Bay Doors\r\nClosed", "/scene/launchland/dockingBay", false) );
    buttonList.add( new ModButton(20, 120, "clamp release", "/scene/launchland/releaseClamp") );

    buttonList.add( new ModToggle(110, 120, "Missiles\r\nOn", "Missiles\r\nOff", "/scene/launchland/trainingMissiles", false) );

    buttonList.add( new ModButton(20, 250, "Launch NPC", "/scene/launchland/launchOtherShip") );
    buttonList.add( new ModButton(120, 250, "NPC to gate", "/scene/launchland/otherShipToGate") );
    buttonList.add( new ModButton(20, 300, "NPC hyper", "/scene/launchland/otherShipHyperspace") );

    for (APWidget w : buttonList) {
      widgetContainer.addWidget(w);
    }

  
  }



  public  void initGui() {
  }

  public  void draw() {
  }


  public  void oscReceive(OscMessage message) {
  }
}

