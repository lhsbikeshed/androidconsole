

public abstract class ControlPanel{
  
  String title = "";
  PApplet parent;
  APWidgetContainer widgetContainer;
  ArrayList<APWidget> buttonList = new ArrayList<APWidget>();
   
  boolean isVisible = false;
  protected int sceneId = -1;
  
  public ControlPanel(String title, PApplet parent){
    this.title = title;
    this.parent = parent;
    widgetContainer = new APWidgetContainer(parent);
  }
  
  public void setSceneNumber(int id){
    sceneId = id;
  }
  
  public int getSceneNumber(){
    return sceneId;
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
     println("Clickbase");
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
