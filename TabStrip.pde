import java.util.Set;

public class TabStrip {

  //HashMap<String, ControlPanel> tabMap = new HashMap();

  ArrayList<ControlPanel> tabMap = new ArrayList();

  ControlPanel currentPanel;

 
  int activeIndex = 0;

  public TabStrip() {
  }

  public void clickEvent(int x, int y) {
    if (y < 40) {
      textFont(globalFont, 13);
      int startX = 15;
      int ind = 0;
      for (ControlPanel c : tabMap) {
        String s = c.getTitle();
       
        int width = c.titleWidth;
        if (x > startX && x < startX + width + 10) {
          switchToTab(s);
           println(s);
        }

        startX += 10 + width;
        ind++;
      }
    }
  }

  public void draw() {
    stroke(255, 255, 255);
    line(0, 25, width, 25);

    textFont(globalFont, 13);
    int startX = 15;
    int ind = 0;
    for (ControlPanel c : tabMap) {
      String s = c.getTitle();
      
      int w = c.titleWidth;
      
      if (activeIndex == ind) {
        fill(255, 255, 0);
      } 
      else {
        fill(255, 255, 255);
      }
      text(s, startX + 10, 20);
      startX += 10 + w;
      ind++;
    }
    noStroke();
    if(currentPanel != null){
      currentPanel.draw();
    }
  }

  public void switchToTab(int sceneId) {
    int ind = 0;
    for (ControlPanel c : tabMap) {
      if (c.getSceneNumber() == sceneId) {
        if ( currentPanel != null ) currentPanel.hide();
        currentPanel = c;
        currentPanel.show();
        activeIndex = ind;
      }
      ind++;
    }
    
    
  }

  public void switchToTab(String title) {
    
    ControlPanel c = null;
     int ind = 0;
    for(ControlPanel p : tabMap){
      if(p.getTitle() == title){
        c = p;
        activeIndex = ind;
        break;
      }
      ind++;
    }
    if (c != null) {
      if (currentPanel != null) {
        currentPanel.hide();
      }
      currentPanel = c;
      currentPanel.show();
    } else {
       println("null");
    }
    
  }

  public ControlPanel getActivePanel() {
    return currentPanel;
  }


  public void addPanel(ControlPanel panel) {
    tabMap.add(panel);
    println("added tab: " + panel.getTitle());
    
    panel.hide();
  }
}

