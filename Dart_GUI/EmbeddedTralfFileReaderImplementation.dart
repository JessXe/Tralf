/*Implementation of EmbeddedTralfFileReader Interface*/
class EmbeddedTralfFileReaderImplementation implements TralfFile {
//Instance Variables:
  /*Hidden DOM object containing history file frames.*/
  Element _tralfDOM;
  
  /*Current frame DOM Object.*/
  Element _cFrame;
  
  /*Previous frame DOM Object.*/
  Element _pFrame;
  
  /*Next frame DOM Object.*/
  Element _nFrame;
  
  /*ID num of [_cframe].*/
  int _curFrameNum;
  
  /*Total number of frames.*/
  int frameCount;
  
  //Contructor
  EmbeddedTralfFileReaderImplementation() {
    _curFrameNum = 0;
    _tralfDOM   = document.query("#tralf_data");
    _cFrame     = _tralfDOM.queryAll(".frame")[_curFrameNum];
    _pFrame     = _tralfDOM.queryAll(".frame")[_curFrameNum];
    _nFrame     = _tralfDOM.queryAll(".frame")[_curFrameNum];
    frameCount  = _tralfDOM.queryAll(".frame").length;
  }
  

//Getters and Setters for Virtual Variables:
  /*Current position in file history.*/
  int get curFrameID() => _curFrameNum;

  /*Jump to [frameNum].  Throws IndexOutOfRangeException if out of history range.*/
  void set curFrameID(int frameNum) {
    if(frameNum < 0 || frameNum >= frameCount) {throw new IndexOutOfRangeException(frameNum);}
    _curFrameNum = frameNum;
    _cFrame = _tralfDOM.queryAll(".frame")[_curFrameNum];
    if(!onFirstFrame()) {_pFrame = _tralfDOM.queryAll(".frame")[_curFrameNum - 1];}
    else {_pFrame = _tralfDOM.queryAll(".frame")[0];}
    if(!onLastFrame()) {_nFrame = _tralfDOM.queryAll(".frame")[_curFrameNum + 1];}
    else {_nFrame = _tralfDOM.queryAll(".frame")[0];}
  }


  //Current Frame:
  /*Line number of the edit for the current frame.*/
  int get editLoc() => Math.parseInt(_cFrame.queryAll(".edit_loc")[0].innerHTML);
  
  /*Date of the edit for current frame.  String with Format: YYYY-MM-DD*/
  String get editDate() => _cFrame.queryAll(".date")[0].innerHTML;
  
  /*Time of the edit for current frame. String with Format: HH:MM:SS*/
  String get editTime() => _cFrame.queryAll(".time")[0].innerHTML;
  
  /*Contents of the current frame as a string*/
  String get frame() => _cFrame.queryAll(".content")[0].innerHTML;

  
  //Previous Frame:
  /*Line number of the edit for the previous frame.*/
  int get prevEditLoc() => Math.parseInt(_pFrame.queryAll(".edit_loc")[0].innerHTML);
  
  /*Date of the edit for previous frame.  String with Format: YYYY-MM-DD*/
  String get prevEditDate() => _pFrame.queryAll(".date")[0].innerHTML;
  
  /*Time of the edit for previous frame. String with Format: HH:MM:SS*/
  String get prevEditTime() => _pFrame.queryAll(".time")[0].innerHTML;
  
  /*Contents of the previous frame as a string*/
  String get prevFrame() => _pFrame.queryAll(".content")[0].innerHTML;

  
  //Next Frame:
  /*Line number of the edit for the next frame.*/
  int get nxtEditLoc() => Math.parseInt(_nFrame.queryAll(".edit_loc")[0].innerHTML);
  
  /*Date of the edit for next frame.  String with Format: YYYY-MM-DD*/
  String get nxtEditDate() => _nFrame.queryAll(".date")[0].innerHTML;
  
  /*Time of the edit for next frame. String with Format: HH:MM:SS*/
  String get nxtEditTime() => _nFrame.queryAll(".time")[0].innerHTML;
  
  /*Contents of the next frame as a string*/
  String get nxtFrame() => _nFrame.queryAll(".content")[0].innerHTML;

  
//Methods:
  /*Checks if current frame is first frame*/
  bool onFirstFrame() {
    if(_curFrameNum == 0) {return true;}
    else {return false;}
  }
  
  /*Checks if current frame is last frame*/
  bool onLastFrame() {
    if(_curFrameNum == frameCount - 1) {return true;}
    else {return false;}
  }

  
}
