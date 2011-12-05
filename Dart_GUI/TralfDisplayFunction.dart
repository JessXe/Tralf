
/**
 * Abstract function.  Used to pass GUI display code to TralfPlayers
 * List must contain:
 * Current:
 * int frameID, int editLoc, String date, String time, String frame
 * followed by int prevEditLoc, int nxtEditLoc
 * 
 */
//TODO: When Map or dictionary objects work, should use them here.
typedef void TralfDisplayFunction(List frameInfo);