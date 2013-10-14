

public class LaunchPanel extends ControlPanel {

  ArrayList<APWidget> buttonList = new ArrayList<APWidget>();

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

    //loop through togglelist to see if the osc message appears there, if it does set the controls state
    for (APWidget w : buttonList) {
      try {
        ModToggle b = (ModToggle)w;
        if (b.getServerMessage().equals(message.addrPattern())) {
          int val = message.get(0).intValue();
          if (val == 0) {
            b.setChecked(false & !b.isInverted());
          } 
          else {
            b.setChecked(true & !b.isInverted());
          }
          break;
        }
      } 
      catch (ClassCastException e) {
      }
    }
  }
}

