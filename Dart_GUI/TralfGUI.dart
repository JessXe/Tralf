class TralfGUI {
  var tralf_data;
  var screenDOM;
  var cur_frame;
  var paused;
  
  TralfGUI() {
    screenDOM = document.query("#screen");
    tralf_data = document.query("#tralf_data");
    cur_frame = 0;
    paused = true;
  }

  set screen(mes) => screenDOM.innerHTML = "<div id=\"frame\">" + mes + "</div>";
  set message(mes) => screen = "<div class=\"message\">" + mes + "</div>";

  set frame(i) {//will need to check for out of bounds etc
    var cframe = tralf_data.queryAll(".frame")[i];
    var cont = cframe.queryAll(".content")[0].innerHTML;
    var formatted = "";
    var lines = cont.split("<br>"); 
    int lnum;
    int cedit = Math.parseInt(cframe.queryAll(".edit_loc")[0].innerHTML);
    int pedit;
    int nedit;
    if(i > 0) {
      pedit = Math.parseInt(tralf_data.queryAll(".frame")[i-1].queryAll(".edit_loc")[0].innerHTML);
    }
    else {pedit = 0;}
    if (i < frame_count-1) {
      nedit = Math.parseInt(tralf_data.queryAll(".frame")[i+1].queryAll(".edit_loc")[0].innerHTML);
    }
    else {nedit = 0;}
    cur_frame = i;
    for(int j = 0; j < lines.length; j++) {//Need to optimize this later
      lnum = j+1;
      if(lnum == cedit) {
        formatted += "<div class=\"cchange\" id=\"focus\">" + lnum.toString() + " |" + lines[j] + "</div>";
      }
      else {
        if(lnum == pedit){
          formatted += "<div class=\"pchange\">" + lnum.toString() + " |" + lines[j] + "</div>";
        }
        else {
          if(lnum == nedit){
            formatted += "<div class=\"nchange\">" + lnum.toString() + " |" + lines[j] + "</div>";
          }
          else {formatted += lnum.toString() + " |" + lines[j] + "<br>";}
        }
      }
    }
    screen = formatted;
    document.query("#fnum").innerHTML = i;
    document.query("#fdate").innerHTML = cframe.queryAll(".date")[0].innerHTML;
    document.query("#ftime").innerHTML = cframe.queryAll(".time")[0].innerHTML;
    if(cedit > 0) {document.query("#focus").scrollIntoView();} //Need to write function so it also check if outside of upper frame range
  }
  
  get frame() => cur_frame;
  
  get frame_count() => tralf_data.queryAll(".frame").length;
  
  
  void load() {
    message = "Buffering . . .";
    frame = 0;
    play();
  }
  
  int _MSSinceThen(then) {
    return ((Clock.now() - then)* 1000) ~/ Clock.frequency();
  }
  
  void play() {
    if(paused) {
      paused = false;
      var pb = document.query("#play");
      pb.innerHTML = "||";
      pb.classes.remove("play_button");
      pb.classes.add("pause_button");
      auto_next();
    }
    else {pause();}
  }
  
  void auto_next() {
    document.window.setTimeout(() {
      if(!paused) {
        next();
        if (frame < frame_count-1){
          auto_next();
        }
        else {pause();}
      }
      else {pause();}
    }, 300);
  }
  
  void pause() {
    var pb = document.query("#play");
    pb.innerHTML = ">";
    pb.classes.remove("pause_button");
    pb.classes.add("play_button");
    paused = true;
  }
  
  void first() {
    frame = 0;
  }
  
  void last() {//Need to check for exceptions
    pause();
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

    document.on.keyDown.add((e) {
      if (e.which == 39) {next();}
      if (e.which == 37) {prev();}
      if (e.which == 32) {play();}
    });
    
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
