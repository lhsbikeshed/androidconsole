

public abstract class ControlPanel{
  
  String title = "";
  public String sceneTag = "";  //scene name sent by game 
  PApplet parent;
  APWidgetContainer widgetContainer;
  ArrayList<APWidget> buttonList = new ArrayList<APWidget>();
   
  boolean isVisible = false;
  public int titleWidth = 70;
  
  public ControlPanel(String title, PApplet parent){
    this.title = title;
    this.parent = parent;
    widgetContainer = new APWidgetContainer(parent);
    
    
  }
  
 
  
  public void show(){
    if(widgetContainer != null){
      widgetContainer.show();
      isVisible = true;
    }
  }
  public void hide(){
    if(widgetContainer != null){
      widgetContainer.hide();
      isVisible = false;
    }
  }
  
  public String getTitle(){
    return title;
  }
  
  
  public abstract void draw();
  
  public void onWidget(APWidget widget){
    if(!buttonList.contains(widget)){
      return;
    }
     
     //check to see if its an OSC sending control
    try {
      ModButton mb = (ModButton)widget;
      new SendOSCTask().execute(mb.getOscMessages());
    } 
    catch (ClassCastException e) {
    }
    try {
      ModToggle mb = (ModToggle)widget;
      new SendOSCTask().execute(mb.getOscMessages());
    } 
    catch (ClassCastException e) {
    }
  }

  public abstract void oscReceive(OscMessage message);
}
