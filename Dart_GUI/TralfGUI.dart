/**GUI for tralfplayer*/
class TralfGUI {
  
  
//Instance variables
  Element screenDOM;   //DOM object representing the player's display-area.
  TralfPlayer tPlayer; //Tralf Player Object takes display code and plays the file.
  bool displnum;       //Display Line Numbers Option
  bool autoscroll;     //Autoscroll Option
  
//Contructors:
  /**Generic constructor*/
  TralfGUI() {
    screenDOM = document.query("#screen");
    tPlayer = new TralfPlayer();
    displnum = false;
    autoscroll = true;
  }

//Getters and Setters for Virtual Instance Variables
  
  /**Current HTML contents of [screenDOM].*/
  get screen()    => screenDOM.innerHTML;
  
  /**Update contents of screen.*/
  set screen(mes) => screenDOM.innerHTML = "<div id=\"frame\">" + mes + "</div>";
  
  /**Current value of message DOM Object.*/
  get message()    => document.query("#mes").innerHTML;
  
  /**Update message and display on screen*/ //TODO:Make message hover over screen rather than replacing contents.
  set message(mes) => screen = "<div class=\"message\" id=\"mes\">" + mes + "</div>";

  /**Total number of frames in file history.*/
  get frame_count() => tPlayer.frameCount;

  /**Current frame ID number.*/
  get frame() => tPlayer.curFrameID;
  
  /**Jumpt to frame number [i].*/
  set frame(i) {
      tPlayer.jumpTo((frameI) {
        updateGUICode(frameI);
    }, i);
  }
  
//Methods:
  //Handlers:
  /**
   * Handler for when the frame number is clicked on
   * displays pop-up for user to enter a frame to jump to.
   */
  void input_frame_num() {//TODO:Would rather this not be a pop-up, but it works for now; commented code is closer to what desired, just need to figure out how to get input
    frame = Math.parseInt(document.window.prompt("Jump to Frame:", frame.toString()));
/*    document.query("#fnum").innerHTML = "<input id=\"fin\" value=\"" + frame + "\"></input>";
    var fin = document.query("#fin");
    fin.focus();
    fin.on.keyDown.add((e) {
      if(e.which == 13) {jump_to();}
    });
*/  }

  /**
   * Handler for when big play button pressed, doesn't do much
   * right now, more for when we have a need for buffering.
   */ 
  void load() {
    message = "Buffering . . .";
    frame = 0;
    play();
  }
  
  /**Iterates through frames till end.*/
  void play() {
    tPlayer.play((frameI) {updateGUICode(frameI);}, (paused) {playButtonGUICode(paused);});
  }
  
  /**Pauses playback.*/
  void pause() {
    tPlayer.pause((paused) {playButtonGUICode(paused);});
  }
  
  /**Handler to toggle linumbers.*/
  void toggle_lnum() {
    if(displnum) {displnum = false;}
    else {displnum = true;}
  }
  
  /**Handler to toggle autoscroll.*/
  void toggle_ascroll() {
    if(autoscroll) {autoscroll = false;}
    else {autoscroll = true;}
  }
  
  /**Handler to jump to first frame.*/
  void first() {
    tPlayer.first((frameI) {updateGUICode(frameI);});
  }
  
  /**Handler to jump to last frame.*/
  void last() {
    tPlayer.last((frameI) {updateGUICode(frameI);});
  }
  
  /**Handler to move to previous frame.*/
  void prev() {
    tPlayer.prev((frameI) {updateGUICode(frameI);});
  }
  
  /**Handler to move to next frame.*/
  void next() {
    tPlayer.next((frameI) {updateGUICode(frameI);});
  }
  
  //Methods to pass to TralfPlayer:
  /**
   * This code is passed to the TralfPlayer so that it
   * may update the screen as it does it's job.
   */
  void updateGUICode(List frameI) {
    String cont = frameI[4];
    String formatted = "";
    List lines = cont.split("<br>"); 
    int lnum;
    String lnum_el = "-";
    int cedit = frameI[1];
    int pedit = frameI[5];
    int nedit = frameI[6];
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
    document.query("#fnum").innerHTML = frameI[0];
    document.query("#fdate").innerHTML = frameI[2];
    document.query("#ftime").innerHTML = frameI[3];
    if(cedit > 0 && autoscroll) {document.query("#focus").scrollIntoView();} //TODO:Need to write function so it also check if outside of upper frame range

  }

  /**
   * This code is passed to the TralfPlayer so that it
   * may update the play/pause button as it does it's job.
   */
  void playButtonGUICode(bool paused) {
      if(paused) {
        var pb = document.query("#play");
        pb.classes.remove("play_button");
        pb.classes.add("pause_button");
      }
      else {
        var pb = document.query("#play");
        pb.classes.remove("pause_button");
        pb.classes.add("play_button");
      } 
    }

  /**Sets up EventListeners and sets initial [message] to a big play button.*/
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
