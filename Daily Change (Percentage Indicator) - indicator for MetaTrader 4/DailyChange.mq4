     
      /*##############################################################
      #  DAILY CHANGE INDICATOR                                      #
      #                                                              #
      #  This Indicator shows the percentage change between          #
      #  yesterday day close and today actual Price (Bid).           #
      #  It works on any time frame.                                 #
      #                                                              #
      #  Copyright: BLACKHAWK                                        #
      ##############################################################*/

/*
------------------------------------------------------------------------------------------------

Description:
 
This indicator shows the % Daily Change of yesterday close with respect to actual price (Bid). 

It calculates the percentage change between yesterday close price and the actual bid price. 

It works on any timeframe.

External Modifications:


You can modify the following settings:

Label_Color       = DarkBlue     // You can change the font color
Font_Size         = 14           // You can modify the font size

X_Position        = 3            // You can modify X position (distance) from corner
Y_Position        = 3            // You can modify Y position (distance) from corner
Corner_Position   = 2            // You cna select the corner position (0: Top Left / 1: Top Right / 2: Bottom Left / 3: Bottom Right)

------------------------------------------------------------------------------------------------
*/


#property indicator_chart_window

extern color   Label_Color       = DarkBlue;
extern int     Font_Size         = 14;

extern int     X_Position        = 3;
extern int     Y_Position        = 3;
extern int     Corner_Position   = 2;

#define OBJECT "DailyChange"



int start()
{
   PerChangeInfo(); // Execute function
}


//--- FUNCTION 1 ------------------------------------------ //
 
   // Function 1 calculates Percentage change between Yesterday Close and actual Bid.

void PerChangeInfo()
   
   {

   double ClPrice_D1  = iClose(NULL, PERIOD_D1, 1);
   double ActualBid   = Bid;
   double PercChange  = ((ActualBid - ClPrice_D1)/ClPrice_D1)*100;
   
   CreateLabel(PercChange);
   
   }

//--- FUNCTION 2 ------------------------------------------ //
 
   // Function 2 creates the label containing the information of Daily Change.


void CreateLabel(double PercChange)

   {
   
   string PerChg = "Daily Change: "+DoubleToStr(PercChange, 2) + " %";
   
   if(ObjectFind(OBJECT) < 0)
      
      {
      ObjectCreate   (OBJECT, OBJ_LABEL, 0, 0, 0);
      ObjectSet      (OBJECT, OBJPROP_CORNER, Corner_Position);
      ObjectSet      (OBJECT, OBJPROP_YDISTANCE, X_Position);
      ObjectSet      (OBJECT, OBJPROP_XDISTANCE, Y_Position);
      ObjectSetText  (OBJECT, PerChg, Font_Size, "Verdana", Label_Color);
      }
   
   ObjectSetText(OBJECT, PerChg);
   
   WindowRedraw();
   
   }


//--- INIT AND DEINIT ------------------------------------- //

int init()
{
   PerChangeInfo();
}


int deinit()
{
   ObjectDelete(OBJECT);
}

