

public class LandPanel extends ControlPanel {


  public LandPanel(String title, PApplet parent) {
    super(title, parent);
    //  ModButton mb = new ModButton(150, 50, "test button", "/string/test");
    // widgetContainer.addWidget(mb);

    buttonList.add( new ModToggle(20, 50, "Bay Doors", "/scene/launchland/dockingBay", true) );
    buttonList.add( new ModToggle(110, 50, "Grav", "/scene/launchland/bayGravity", false) );
    buttonList.add( new ModButton(170, 50, "Dock", "/scene/launchland/startDock") );
    
   
   
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

