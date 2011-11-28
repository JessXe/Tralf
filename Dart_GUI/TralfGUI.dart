class TralfGUI {
  var pref;
  var suff;
  
  TralfGUI() {
    pref = "<div id=\"frame\"><div class=\"message\">";
    suff = "</div></div>";
  }
  
  set message(mes) => document.query("#screen").innerHTML = pref + mes + suff;

  void load() {
    message = "Buffering . . .";
  }
  
  void play() {
    message = "Oh Sheesh I'msoexcitedit'splaying!!";
  }
  
  void first() {
    message = "First Frame!";
  }
  
  void last() {
    message = "Last Frame!?!";
  }
  
  void prev() {
    message = "prev";
  }
  
  void next() {
    message = "neXt!";
  }
  
  void stop() {
    message = "STOPPPPPP";
  }
  
  void ready() {
    message = "<div class=\"play_button\" id=\"bplay\">></div></div></div>";

    
    document.query("#bplay").on.click.add((e) {
      load();
    });
    
    document.query("#fframe").on.click.add((e) {
      first();
    });
    
    document.query("#pframe").on.click.add((e) {
      prev();
    });
    
    document.query("#play").on.click.add((e) {
      play();
    });
    
    document.query("#stop").on.click.add((e) {
      stop();
    });
    
    document.query("#nframe").on.click.add((e) {
      next();
    });
    
    document.query("#lframe").on.click.add((e) {
      last();
    });
    
    for(int i = 0; i < 10; i++) {
      message = i;
    }
    
    var tralf;
    tralf = document.query("#traf_data");
    message = tralf.length;
  }
}

void main() {
  
  Dom.ready(() { new TralfGUI().ready(); });
  
}