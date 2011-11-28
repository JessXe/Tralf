class TralfGUI {
  var tralf_data;
  var screenDOM;
  var cur_frame;
  
  TralfGUI() {
    screenDOM = document.query("#screen");
    tralf_data = document.query("#tralf_data");
    cur_frame = 0;
  }
  
  set screen(mes) => screenDOM.innerHTML = "<div id=\"frame\">" + mes + "</div>";
  set message(mes) => screen = "<div class=\"message\">" + mes + "</div>";

  set frame(i) {//will need to check for out of bounds etc
    var cframe;
    cur_frame = i;
    cframe = tralf_data.queryAll(".frame")[i].queryAll(".content")[0].innerHTML;
    screen = cframe;
  }
  
  get frame() => cur_frame;
  
  get frame_count() => tralf_data.queryAll(".frame").length;
  
  
  void load() {
    message = "Buffering . . .";
    frame = 0;
  }
  
  void play() {
    message = "Oh Sheesh I'msoexcitedit'splaying!!";
  }
  
  void first() {
    frame = 0;
  }
  
  void last() {//Need to check for exceptions
    frame = frame_count-1;
  }
  
  void prev() {//Need to check for exceptions
    frame -= 1;
  }
  
  void next() {//Need to check for exceptions
    frame += 1;
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
    
  }
}

void main() {
  
  Dom.ready(() { new TralfGUI().ready(); });
  
}