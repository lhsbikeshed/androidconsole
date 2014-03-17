

public class LandPanel extends ControlPanel {


  public LandPanel(String title, PApplet parent) {
    super(title, parent);
    //  ModButton mb = new ModButton(150, 50, "test button", "/string/test");
    // widgetContainer.addWidget(mb);
    buttonList.add( new ModToggle(20, 50, "AutoDock", "/scene/launchland/autodock", true) );
    buttonList.add( new ModToggle(20, 90, "Bay Doors", "/scene/launchland/dockingBay", true) );
    buttonList.add( new ModToggle(110, 90, "Grav", "/scene/launchland/bayGravity", false) );
    buttonList.add( new ModButton(170, 90, "Dock", "/scene/launchland/startDock") );

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

