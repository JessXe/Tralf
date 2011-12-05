interface TralfPlayer factory TralfPlayerImplementation{
//Instance Variable:
  /**Interfaces with the tralf data*/
  TralfFile tFile;
  
  /** true if playback is paused */
  bool paused;
  
  
//Constructors:
  /**Generic Constructor.*/
  TralfPlayer();
  
  
//Getter and Setters for Virtual Instance Variables:
  /**Current position in file history.*/
  int get curFrameID();

  /**Jump to [frameNum]. Returns true if successful.*/
  bool set curFrameID(int frameNum);
  
  /**Total number of frames.*/
  int get frameCount();
  
//Methods:
  /**
   * Continuously iterate through frames til end of history.
   * Accepts a function to display the output,
   * and a function to toggle play and pause GUI elements.
   * Returns true if successful.
   */
  bool play(TralfDisplayFunction disp, TralfPBGUIFunction playb);
  
  /**
   * Pauses playback.
   * Accepts a function to update GUI elements related to playback status.
   */
  void pause(TralfPBGUIFunction playb);

  /**
   * Jump to frame number [frameNum].
   * Accepts a function to toggle play and pause GUI elements.
   * Returns true if successful.
   */
  bool jumpTo(TralfDisplayFunction disp, int frameNum); 
  
  /**
   * Move to next frame.
   * Accepts a function to display the output
   * Returns true if successful.
   */
  bool next(TralfDisplayFunction disp);
    
  /**
   * Move to previous frame.
   * Accepts a function to display the output
   * Returns true if successful.
   */
  bool prev(TralfDisplayFunction disp);
  
  /**
   * Move to first frame.
   * Accepts a function to display the output
   * Returns true if successful.
   */
  bool first(TralfDisplayFunction disp);
  
  /**
   * Move to last frame.
   * Accepts a function to display the output
   * Returns true if successful.
   */
  bool last(TralfDisplayFunction disp);
  
  void _runGUICode(TralfDisplayFunction disp);

}
