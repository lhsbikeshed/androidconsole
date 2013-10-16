
public class UtilityPanel extends ControlPanel {

  APEditText edit;

  APButton setIpButton;


  public UtilityPanel(String title, PApplet parent) {
    super(title, parent);
    setIpButton = new APButton(150, 110, "Set Server IP"); 
    edit = new APEditText(10, 110, 100, 40);

    widgetContainer.addWidget(setIpButton); 
    widgetContainer.addWidget(edit);
  }


  public void onWidget(APWidget widget) {
    super.onWidget(widget);
    if (widget == setIpButton) { //if it was SetIpButton that was clicked
      //set server ip;
      serverIP = edit.getText();
      println("server ip set to: " + serverIP);
    }

  }

  public  void initGui() {
  }

  public  void draw() {
    textFont(globalFont, 15);
    text("IP: " + serverIP, 10, 180);
  }

  public  void oscReceive(OscMessage message) {
  }
}

