

public class RefuelPanel extends ControlPanel {
  

  public RefuelPanel(String title, PApplet parent) {
    super(title, parent);
    sceneTag = "refuelScene";

  }

  public void show() {
    super.show();
   
  }

  public  void initGui() {
  }

  public  void draw() {
    textFont(globalFont, 15);
    
  }

  public  void oscReceive(OscMessage msg) {

  }
}

