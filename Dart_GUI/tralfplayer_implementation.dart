class TralfPlayerImplementation implements TralfPlayer {
//Instance Variable:
  /**Interfaces with the tralf data*/
  TralfFile tFile;
  
  /** true if playback is paused */
  bool paused;
  
  
//Constructors:
  /**Generic Constructor.*/
  TralfPlayerImplementation() { //Might need a named constructor in order to pass variables
    tFile = new TralfFile();
    paused = true;
  }
  
  
//Getter and Setters for Virtual Instance Variables:
  /**Current position in file history.*/
  int get curFrameID() => tFile.curFrameID;

  /**Jump to [frameNum]. Returns true if successful.*/
  bool set curFrameID(int frameNum) {
    try {
      tFile.curFrameID = frameNum;
      return true;
    }
    catch (IndexOutOfRangeException e) {
      return false;
    }
  }
  
  /**Total number of frames.*/
  int get frameCount() => tFile.frameCount;
  
//Methods:
  /**
   * Continuously iterate through frames til end of history.
   * Accepts a function to display the output,
   * and a function to toggle play and pause GUI elements.
   * Returns true if successful.
   */
  bool play(TralfDisplayFunction disp, TralfPBGUIFunction playb) {
    if(paused) {
      playb(paused);
      paused = false;
      _auto_next(disp, playb);
    }
    else {pause(playb);}
  }
  
  /**
   * Pauses playback.
   * Accepts a function to update GUI elements related to playback status.
   */
  void pause(TralfPBGUIFunction playb) {
    playb(paused);
    paused = true;
  }
  
  
  void _auto_next(TralfDisplayFunction disp, TralfPBGUIFunction playb) {
    document.window.setTimeout(() {
      if(!tFile.onLastFrame()) {
        if(!paused) {
          next(disp);
          _auto_next(disp, playb); 
        }
      }
      else {pause(playb);}
    }, 300);
  }

  /**
   * Jump to frame number [frameNum].
   * Accepts a function to display the output
   * Returns true if successful.
   */
  bool jumpTo(TralfDisplayFunction disp, int frameNum) {
    if (curFrameID = frameNum) { //Don't get confused here, not testing for equality; see [curFrameID] setter. 
      _runGUICode(disp);
      return true;
    }
    else {return false;}
  }
  
  /**
   * Move to next frame.
   * Accepts a function to display the output
   * Returns true if successful.
   */
  bool next(TralfDisplayFunction disp) {
    return jumpTo(disp, curFrameID + 1);
  }
  
  /**
   * Move to previous frame.
   * Accepts a function to display the output
   * Returns true if successful.
   */
  bool prev(TralfDisplayFunction disp) {
    return jumpTo(disp, curFrameID - 1);
  }
  
  /**
   * Move to first frame.
   * Accepts a function to display the output
   * Returns true if successful.
   */
  bool first(TralfDisplayFunction disp) {//TODO:Had to put a workaround for jumping to zero, investigate this later.
    curFrameID = 0;
    _runGUICode(disp);
    return true;
//    return prev(disp);
  }
  
  /**
   * Move to last frame.
   * Accepts a function to display the output, needs play button gui stuff too
   * Returns true if successful.
   */
  bool last(TralfDisplayFunction disp) {
    return jumpTo(disp, frameCount - 1);
  }

  void _runGUICode(TralfDisplayFunction disp) {
    List frameInfo = new List();
    
    frameInfo.add(tFile.curFrameID);
    frameInfo.add(tFile.editLoc);
    frameInfo.add(tFile.editDate);
    frameInfo.add(tFile.editTime);
    frameInfo.add(tFile.frame);
    frameInfo.add(tFile.prevEditLoc);
    frameInfo.add(tFile.nxtEditLoc);
    

    disp(frameInfo);
    
  }

}
