class TralfGUI {
  var tralf_data;
  var screenDOM;
  var cur_frame;
  var paused;
  var displnum;
  var autoscroll;
  
  TralfGUI() {
    screenDOM = document.query("#screen");
    tralf_data = document.query("#tralf_data");
    cur_frame = -1;
    paused = true;
    displnum = false;
    autoscroll = true;
  }

  set screen(mes) => screenDOM.innerHTML = "<div id=\"frame\">" + mes + "</div>";
  set message(mes) => screen = "<div class=\"message\">" + mes + "</div>";

  set frame(i) {//will need to check for out of bounds etc
    var cframe = tralf_data.queryAll(".frame")[i];
    var cont = cframe.queryAll(".content")[0].innerHTML;
    var formatted = "";
    var lines = cont.split("<br>"); 
    int lnum;
    var lnum_el = "-";
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
      if(displnum) {lnum_el = "<span class=\"lnum\">" + lnum.toString() + "</span>|";}
      if(lnum == cedit) {
        formatted += "<span class=\"cchange\" id=\"focus\">" + lnum_el + lines[j] + "</span><br>";
      }
      else {
        if(lnum == pedit){
          formatted += "<span class=\"pchange\">" + lnum_el + lines[j] + "</span><br>";
        }
        else {
          if(lnum == nedit){
            formatted += "<span class=\"nchange\">" + lnum_el + lines[j] + "</span><br>";
          }
          else {formatted += lnum_el + lines[j] + "<br>";}
        }
      }
    }
    screen = formatted;
    document.query("#fnum").innerHTML = i;
    document.query("#fdate").innerHTML = cframe.queryAll(".date")[0].innerHTML;
    document.query("#ftime").innerHTML = cframe.queryAll(".time")[0].innerHTML;
    if(cedit > 0 && autoscroll) {document.query("#focus").scrollIntoView();} //Need to write function so it also check if outside of upper frame range
  }
  
  get frame() => cur_frame;
  
  get frame_count() => tralf_data.queryAll(".frame").length;
  
  
  void input_frame_num() {//Would rather this not be a pop-up, but it works for now; commented code is closer to what wanted, just need to figure out how to get input
    frame = Math.parseInt(document.window.prompt("Jump to Frame:", frame.toString()));
/*    document.query("#fnum").innerHTML = "<input id=\"fin\" value=\"" + frame + "\"></input>";
    var fin = document.query("#fin");
    fin.focus();
    fin.on.keyDown.add((e) {
      if(e.which == 13) {jump_to();}
    });
*/  }
  
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
      pb.classes.remove("play_button");
      pb.classes.add("pause_button");
      auto_next();
    }
    else {pause();}
  }
  
  void auto_next() {
    document.window.setTimeout(() {
      if(frame < frame_count-1 && !paused) {
        next();
        auto_next();
      }
      else {pause();}
    }, 300);
  }
  
  void pause() {
    var pb = document.query("#play");
    pb.classes.remove("pause_button");
    pb.classes.add("play_button");
    paused = true;
  }
  
  void toggle_lnum() {
    if(displnum) {displnum = false;}
    else {displnum = true;}
  }
  
  void toggle_ascroll() {
    if(autoscroll) {autoscroll = false;}
    else {autoscroll = true;}
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
    message = "<div class=\"play_button\" id=\"bplay\"></div></div></div>";

    document.on.keyDown.add((e) {
      if (e.which == 39) {next();}
      if (e.which == 37) {prev();}
      if (e.which == 32) {play();}
      if (e.which == 36) {first();}
      if (e.which == 35) {last();}
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
    
    document.query("#fnum").on.click.add((e) {
      input_frame_num();
    });
    
    document.query("#toggle_lnum").on.click.add((e) {
      toggle_lnum();
    });
    
    document.query("#toggle_ascroll").on.click.add((e) {
      toggle_ascroll();
    });
    
  }
}

void main() {
  
  Dom.ready(() { new TralfGUI().ready(); });
  
}
