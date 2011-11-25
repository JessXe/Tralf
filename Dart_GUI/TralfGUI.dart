class TralfGUI {
  var frame;
  
  TralfGUI() {
    frame = "<p id=\"frame\">Oh, Gosh!<br>It's totally playing!</p>";
  }

  void play() {
    document.query("#screen").innerHTML = frame;
  }
  
  void stop() {
    document.query("#screen").innerHTML = "<p id=\"frame\">Stopped</p>";
  }
  
  void ready() {
    document.query("#screen").innerHTML = "<p id=\"frame\">Not Playing</p>";
    
    document.query("#play").on.click.add((e) {
      play();
    });
    
    document.query("#stop").on.click.add((e) {
      stop();
    });
  }
}

void main() {
  
  Dom.ready(() { new TralfGUI().ready(); });
  
}