
//=================================================================================================
//===DoubleDragon================================================================================
//=============================================================================================

#property   copyright "Copyright © 2010, Thomas Stutz"
#property   link      "t.s@my-sc.eu"

//=============================================================================================

#property   indicator_separate_window
#property   indicator_buffers 2
#property   indicator_color1 DarkOrange
#property   indicator_color2 RoyalBlue

//===Extern=Variables==========================================================================

extern      int         CCI1     =     14,
                        CCI2     =     34;

//===Variables=================================================================================

            int         i        =     0,
                        limit    =     0,
                        counter  =     0;

            double      cc1[],cc2[],levelU,levelD;

//===Init======================================================================================

int init()

   {

      SetIndexStyle(0, DRAW_LINE);
      SetIndexBuffer(0, cc1);
      SetIndexDrawBegin(0, CCI1);
      SetIndexStyle(1, DRAW_LINE);
      SetIndexBuffer(1, cc2);
      SetIndexDrawBegin(1, CCI2);

      return(0);

   }

//===Deinit====================================================================================

int deinit()

   {

      return(0);

   }

//===Start=====================================================================================

int start()

   {

      counter = IndicatorCounted();
      if    (counter < 0) return(-1);
      if    (counter > 0) counter--;
      limit = Bars - counter;

      for(i = 0; i < limit; i++)

         {

            cc1[i] = iMomentum(Symbol(),0,CCI1,PRICE_CLOSE,i);
            cc2[i] = iMomentum(Symbol(),0,CCI2,PRICE_CLOSE,i);
            if(cc2[i] > 100.6) {levelU = cc2[i] - 0.4;}
            else {levelU = 100.3;}
            if(cc2[i] < 99.6) {levelD = cc2[i] + 0.4;}
            else {levelD = 99.9;}

            SetLevelValue(0, levelU);
            SetLevelValue(1, levelD);

         }

      return(0);

   }

//===End=======================================================================================

