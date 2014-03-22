

public class LandPanel extends ControlPanel {

    boolean grabberState = false;
    

  public LandPanel(String title, PApplet parent) {
    super(title, parent);
    //  ModButton mb = new ModButton(150, 50, "test button", "/string/test");
    // widgetContainer.addWidget(mb);
    
    buttonList.add( new ModToggle(20, 190, "Bay Doors", "/scene/launchland/dockingBay", true) );
    buttonList.add( new ModToggle(110, 190, "Grav", "/scene/launchland/bayGravity", false) );
    buttonList.add( new ModButton(170, 190, "Dock", "/scene/launchland/startDock") );

    buttonList.add( new ModButton(20, 250, "WIN THE GAME", "/game/gameWin") );
    
    
    
    buttonList.add( new ModButton(20, 40, "AutoDock", "/scene/launchland/autodock") );
    buttonList.add( new ModToggle(110, 40, "DockingComp", "/scene/launchland/dockingCompState", false) );
    
    
    ModButton m3 =  new ModButton(10, 390, "JumpHere", "/game/takeMeTo");
    m3.setValue(5);
    buttonList.add( m3 );

    for (APWidget w : buttonList) {
      widgetContainer.addWidget(w);
    }

    //map this tab to a scene number from the game
    setSceneNumber(4);
  }



  public  void initGui() {
  }

  public  void draw() {
    text("Can Docks?: " + grabberState, 20, 180);
  }


  public  void oscReceive(OscMessage message) {
    if (message.checkAddrPattern("/scene/launchland/grabberState") == true) {
      grabberState = message.get(0).intValue() == 1 ? true : false;
    }

  }
}

