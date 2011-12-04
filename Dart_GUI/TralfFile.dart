
/*An interface to interprit Tralf data files.*/
interface TralfFile factory EmbeddedTralfFileReaderImplementation{

//Instance Variables:
  /*Total number of frames*/
  int frameCount;
  

//Getters and Setters for Virtual Variables:
  /*Current position in file history.*/
  int get curFrameID();

  /*Jump to [frameNum].  Throws IndexOutOfRangeException if out of history range.*/
  void set curFrameID(int frameNum);


  //Current Frame:
  /*Line number of the edit for the current frame.*/
  int get editLoc();
  
  /*Date of the edit for current frame.  String with Format: YYYY-MM-DD*/
  String get editDate();
  
  /*Time of the edit for current frame. String with Format: HH:MM:SS*/
  String get editTime();
  
  /*Contents of the current frame as a string*/
  String get frame();

  
  //Previous Frame:
  /*Line number of the edit for the previous frame.*/
  int get prevEditLoc();
  
  /*Date of the edit for previous frame.  String with Format: YYYY-MM-DD*/
  String get prevEditDate();
  
  /*Time of the edit for previous frame. String with Format: HH:MM:SS*/
  String get prevEditTime();
  
  /*Contents of the previous frame as a string*/
  String get prevFrame();

  
  //Next Frame:
  /*Line number of the edit for the next frame.*/
  int get nxtEditLoc();
  
  /*Date of the edit for next frame.  String with Format: YYYY-MM-DD*/
  String get nxtEditDate();
  
  /*Time of the edit for next frame. String with Format: HH:MM:SS*/
  String get nxtEditTime();
  
  /*Contents of the next frame as a string*/
  String get nxtFrame();

//Methods:
  /*Checks if current frame is first frame*/
  bool onFirstFrame();
  
  /*Checks if current frame is last frame*/
  bool onLastFrame();
  
}
