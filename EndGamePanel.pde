

public class EndGamePanel extends ControlPanel {


  
  public EndGamePanel(String title, PApplet parent) {
    super(title, parent);
    sceneTag = "dead";

    buttonList.add( new ModButton(20, 50, "Reset", "/game/reset") );
    

    for (APWidget w : buttonList) {
      widgetContainer.addWidget(w);
    }

   

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

