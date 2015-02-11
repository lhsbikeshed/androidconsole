

public class PreloadPanel extends ControlPanel {
  

  public PreloadPanel(String title, PApplet parent) {
    super(title, parent);
    sceneTag = "preload";
    
     ModButton m =  new ModButton(2, 50, "START", "/scene/preload/start");
    buttonList.add( m );
    for (APWidget w : buttonList) {
      widgetContainer.addWidget(w);
    }
  }

  public void show() {
    super.show();
  }

  public  void initGui() {
   

  }

  public  void draw() {
    
  }

  public  void oscReceive(OscMessage msg) {

    
  }
}

