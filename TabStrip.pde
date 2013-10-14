import java.util.Set;

public class TabStrip {

  HashMap<String, ControlPanel> tabMap = new HashMap();

  ControlPanel currentPanel;

  String[] tabNames = new String[0];
  int activeIndex = 0;

  public TabStrip() {
  }

  public void clickEvent(int x, int y) {
    if (y < 40) {
      textFont(globalFont, 13);
      int startX = 15;
      int ind = 0;
      for (String s : tabNames) {
        int width = (int)textWidth(s);
        if (x > startX && x < startX + width + 10) {
          switchToTab(s);
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
    for (String s : tabNames) {
      int width = (int)textWidth(s);
      if (activeIndex == ind) {
        fill(255, 255, 0);
      } 
      else {
        fill(255, 255, 255);
      }
      text(s, startX + 10, 20);
      startX += 10 + width;
      ind++;
    }
    noStroke();
    currentPanel.draw();
  }

  public void switchToTab(int sceneId) {
    for (ControlPanel c : tabMap.values()) {
      if (c.getSceneNumber() == sceneId) {
        if ( currentPanel != null ) currentPanel.hide();
        currentPanel = c;
        currentPanel.show();
      }
    }
    int ind = 0;
    for (String s : tabNames) {
      if (s.equals(currentPanel.getTitle())) {
        activeIndex = ind;
      }
      ind++;
    }
  }

  public void switchToTab(String title) {
    ControlPanel c = tabMap.get(title);
    if (c != null) {
      if (currentPanel != null) {
        currentPanel.hide();
      }
      currentPanel = c;
      currentPanel.show();
    }
    int ind = 0;
    for (String s : tabNames) {
      if (s.equals(currentPanel.getTitle())) {
        activeIndex = ind;
      }
      ind++;
    }
  }

  public ControlPanel getActivePanel() {
    return currentPanel;
  }


  public void addPanel(ControlPanel panel) {
    tabMap.put(panel.getTitle(), panel);
    println("added tab: " + panel.getTitle());
    Set<String> keys = tabMap.keySet();
    tabNames = keys.toArray(new String[0]);
    panel.hide();
  }
}

