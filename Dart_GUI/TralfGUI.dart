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
    var cframe = tralf_data.queryAll(".frame")[i];
    var cont = cframe.queryAll(".content")[0].innerHTML;
    var formatted = "";
    var lines = cont.split("<br>"); 
    int lnum;
    int cedit = Math.parseInt(cframe.queryAll(".edit_loc")[0].innerHTML);
    int pedit = 0;
    int nedit = 0;
    if(i > 0) {
      pedit = Math.parseInt(tralf_data.queryAll(".frame")[i-1].queryAll(".edit_loc")[0].innerHTML);
    }
    if (i < frame_count-1) {
      nedit = Math.parseInt(tralf_data.queryAll(".frame")[i+1].queryAll(".edit_loc")[0].innerHTML);
    }
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
    document.query("#focus").scrollIntoView();
  }
  
  get frame() => cur_frame;
  
  get frame_count() => tralf_data.queryAll(".frame").length;
  
  
  void load() {
    message = "Buffering . . .";
    frame = 0;
  }
  
  void play() {
    message = "trying";
    var sw = new StopWatch();
    sw.start();
    for(var i = 0; i < 10; i++) {
      message = "In loop";
      message = sw.elapsedInMS;
      while (sw.elapsedInMS() < 100) {
        message = sw.elapsedInMS();
      }
      sw.stop();
      frame = i;
      sw.elapsed = 0;
      sw.start();
    }
   
    
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

    document.on.keyDown.add((e) {
      if (e.which == 39) {next();}
      if (e.which == 37) {prev();}
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