//*****************************************************************************
// Disp_Ask_Bid_01.mq4 2011-06-22
//
// This code display ask-bid value.
// indicator
// Create by artsurf
//*****************************************************************************

#property indicator_chart_window
extern int word_size = 14;
extern color word_color = White;
extern bool right_left = false;
extern int x_distance = 5;
extern int y_distance = 15;


//-----------------------------------------------------------------------------

int init(){
	return(0);
}


//-----------------------------------------------------------------------------

int deinit(){
	ObjectsDeleteAll(0, OBJ_LABEL);
	return(0);
}


//-----------------------------------------------------------------------------

int start(){
	string disp_price;
	double ask_price = MarketInfo(Symbol(), MODE_ASK);
	double bid_price = MarketInfo(Symbol(), MODE_BID);

	disp_price = StringConcatenate(DoubleToStr(ask_price, Digits)," - ",DoubleToStr(bid_price, Digits));

	ObjectCreate("word", OBJ_LABEL, 0, 0, 0);
	ObjectSetText("word", disp_price, word_size, "Arial", word_color);
	ObjectSet("word", OBJPROP_CORNER, right_left);
	ObjectSet("word", OBJPROP_XDISTANCE, x_distance);
	ObjectSet("word", OBJPROP_YDISTANCE, y_distance);

	return(0);
}


