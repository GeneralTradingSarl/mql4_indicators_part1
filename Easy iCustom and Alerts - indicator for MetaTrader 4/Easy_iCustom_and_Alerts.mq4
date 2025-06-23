//+------------------------------------------------------------------+
//|                                      Easy iCustom and Alerts.mq4 |
//|                                                       Codersguru |
//|                                         http://www.forex-tsd.com |
//+------------------------------------------------------------------+

#property copyright "Codersguru and cockeyedcowboy"
#property link      "http://www.forex-tsd.com"

#property indicator_chart_window

#property indicator_buffers 3
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_color3 Yellow

double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];

extern bool Alert_On_Crossing=true;

extern string Pair_1="EURUSD";
extern string Indicator_Name_1="Moving Averages";
extern int TimeFrame_1=0;
extern int Line_1=0;
extern double Parameter1_1=12;
extern double Parameter2_1=0;
extern double Parameter3_1=1;
extern double Parameter4_1=-100;
extern double Parameter5_1=-100;

extern string Pair_2="EURUSD";
extern string Indicator_Name_2="Moving Averages";
extern int TimeFrame_2=0;
extern int Line_2=0;
extern double Parameter1_2=144;
extern double Parameter2_2=0;
extern double Parameter3_2=1;
extern double Parameter4_2=-100;
extern double Parameter5_2=-100;

extern string Pair_3="EURUSD";
extern string Indicator_Name_3="Moving Averages";
extern int TimeFrame_3=0;
extern int Line_3=0;
extern double Parameter1_3=169;
extern double Parameter2_3=0;
extern double Parameter3_3=1;
extern double Parameter4_3=-100;
extern double Parameter5_3=-100;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Crossed_1 (double line1 , double line2)
  {
   static int last_direction=0;
   static int current_direction=0;

   static bool first_time=true;
   if(first_time==true)
     {
      first_time=false;
      return(0);
     }

   if(line1>line2)current_direction=1; //up
   if(line1<line2)current_direction=2; //down

   if(current_direction!=last_direction) //changed 
     {
      last_direction=current_direction;
      return(last_direction);
     }
   else
     {
      return(0); //not changed
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Crossed_2 (double line1 , double line2)
  {
   static int last_direction=0;
   static int current_direction=0;

   static bool first_time=true;
   if(first_time==true)
     {
      first_time=false;
      return(0);
     }

   if(line1>line2)current_direction=1; //up
   if(line1<line2)current_direction=2; //down

   if(current_direction!=last_direction) //changed 
     {
      last_direction=current_direction;
      return(last_direction);
     }
   else
     {
      return(0); //not changed
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Crossed_3 (double line1 , double line2)
  {
   static int last_direction=0;
   static int current_direction=0;

   static bool first_time=true;
   if(first_time==true)
     {
      first_time=false;
      return(0);
     }

   if(line1>line2)current_direction=1; //up
   if(line1<line2)current_direction=2; //down

   if(current_direction!=last_direction) //changed 
     {
      last_direction=current_direction;
      return(last_direction);
     }
   else
     {
      return(0); //not changed
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {

   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);

   if (Pair_1=="NULL") Pair_1=NULL;
   if (Pair_2=="NULL") Pair_2=NULL;
   if (Pair_3=="NULL") Pair_3=NULL;

   return(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {

   int    counted_bars=IndicatorCounted();
   if (counted_bars>0) counted_bars--;
   int    pos=Bars-counted_bars;

   while(pos>=0)
     {

      ExtMapBuffer1[pos]= GetIcustomValue(1,pos);
      ExtMapBuffer2[pos]= GetIcustomValue(2,pos);
      ExtMapBuffer3[pos]= GetIcustomValue(3,pos);
      pos--;
     }

   static int isCrossed_1 =0;
   static int isCrossed_2 =0;
   static int isCrossed_3 =0;

   if (Alert_On_Crossing)
     {
      if(Parameter1_1!=-100 && Parameter2_1!=-100 && Parameter3_1!=-100) //1 - 2 - 3
        {
         isCrossed_1=Crossed_1(GetIcustomValue(1,0),GetIcustomValue(2,0));
         if (isCrossed_1==1) Alert (Pair_1 + ": " + Indicator_Name_1 + " (" + Parameter1_1 + ") has been crossed " + Indicator_Name_2 + " (" + Parameter1_2 + ") Upward!" );
         if (isCrossed_1==2) Alert (Pair_1 + ": " + Indicator_Name_1 + " (" + Parameter1_1 + ") has been crossed " + Indicator_Name_2 + " (" + Parameter1_2 + ") Downward!" );
         isCrossed_2=Crossed_2(GetIcustomValue(2,0),GetIcustomValue(3,0));
         if (isCrossed_2==1) Alert (Pair_1 + ": " + Indicator_Name_2 + " (" + Parameter1_2 + ") has been crossed " + Indicator_Name_3 + " (" + Parameter1_3 + ") Upward!" );
         if (isCrossed_2==2) Alert (Pair_1 + ": " + Indicator_Name_2 + " (" + Parameter1_2 + ") has been crossed " + Indicator_Name_3 + " (" + Parameter1_3 + ") Upward!" );
         isCrossed_3=Crossed_3(GetIcustomValue(1,0),GetIcustomValue(3,0));
         if (isCrossed_3==1) Alert (Pair_1 + ": " + Indicator_Name_1 + " (" + Parameter1_1 + ") has been crossed " + Indicator_Name_3 + " (" + Parameter1_3 + ") Upward!" );
         if (isCrossed_3==2) Alert (Pair_1 + ": " + Indicator_Name_1 + " (" + Parameter1_1 + ") has been crossed " + Indicator_Name_3 + " (" + Parameter1_3 + ") Upward!" );
        }

      if(Parameter1_1!=-100 && Parameter2_1!=-100 && Parameter3_1==-100) // 1 - 2
        {
         isCrossed_1=Crossed_1(GetIcustomValue(1,0),GetIcustomValue(2,0));
         if (isCrossed_1==1) Alert (Pair_1 + ": " + Indicator_Name_1 + " (" + Parameter1_1 + ") has been crossed " + Indicator_Name_2 + " (" + Parameter1_2 + ") Upward!" );
         if (isCrossed_1==2) Alert (Pair_1 + ": " + Indicator_Name_1 + " (" + Parameter1_1 + ") has been crossed " + Indicator_Name_2 + " (" + Parameter1_2 + ") Upward!" );
        }

      if(Parameter1_1!=-100 && Parameter2_1==-100 && Parameter3_1!=-100) // 1 - 3
        {
         isCrossed_1=Crossed_1(GetIcustomValue(1,0),GetIcustomValue(3,0));
         if (isCrossed_1==1) Alert (Pair_1 + ": " + Indicator_Name_1 + " (" + Parameter1_1 + ") has been crossed " + Indicator_Name_3 + " (" + Parameter1_3 + ") Upward!" );
         if (isCrossed_1==2) Alert (Pair_1 + ": " + Indicator_Name_1 + " (" + Parameter1_1 + ") has been crossed " + Indicator_Name_3 + " (" + Parameter1_3 + ") Upward!" );
        }

      if(Parameter1_1==-100 && Parameter2_1!=-100 && Parameter3_1!=-100) // 2 - 3
        {
         isCrossed_1=Crossed_1(GetIcustomValue(2,0),GetIcustomValue(3,0));
         if (isCrossed_1==1) Alert (Pair_2 + ": " + Indicator_Name_2 + " (" + Parameter1_2 + ") has been crossed " + Indicator_Name_3 + " (" + Parameter1_3 + ") Upward!" );
         if (isCrossed_1==2) Alert (Pair_2 + ": " + Indicator_Name_2 + " (" + Parameter1_2 + ") has been crossed " + Indicator_Name_3 + " (" + Parameter1_3 + ") Upward!" );
        }
     }

   return(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  double GetIcustomValue(int level ,int shift)
  {
   double value =0;

   switch(level)
     {
      case 1 :
        {
         if(Parameter1_1!=-100 && Parameter2_1==-100 && Parameter3_1==-100 && Parameter4_1==-100 && Parameter5_1==-100)
            value=iCustom(Pair_1,TimeFrame_1,Indicator_Name_1,Parameter1_1,Line_1,shift);
         if(Parameter1_1!=-100 && Parameter2_1!=-100 && Parameter3_1==-100 && Parameter4_1==-100 && Parameter5_1==-100)
            value=iCustom(Pair_1,TimeFrame_1,Indicator_Name_1,Parameter1_1,Parameter2_1,Line_1,shift);
         if(Parameter1_1!=-100 && Parameter2_1!=-100 && Parameter3_1!=-100 && Parameter4_1==-100 && Parameter5_1==-100)
            value=iCustom(Pair_1,TimeFrame_1,Indicator_Name_1,Parameter1_1,Parameter2_1,Parameter3_1,Line_1,shift);
         if(Parameter1_1!=-100 && Parameter2_1!=-100 && Parameter3_1!=-100 && Parameter4_1!=-100 && Parameter5_1==-100)
            value=iCustom(Pair_1,TimeFrame_1,Indicator_Name_1,Parameter1_1,Parameter2_1,Parameter3_1,Parameter4_1,Line_1,shift);
         if(Parameter1_1!=-100 && Parameter2_1!=-100 && Parameter3_1!=-100 && Parameter4_1!=-100 && Parameter5_1!=-100)
            value=iCustom(Pair_1,TimeFrame_1,Indicator_Name_1,Parameter1_1,Parameter2_1,Parameter3_1,Parameter4_1,Parameter5_1,Line_1,shift);
         break;
        }

      case 2 :
        {
         if(Parameter1_2!=-100 && Parameter2_2==-100 && Parameter3_2==-100 && Parameter4_2==-100 && Parameter5_2==-100)
            value=iCustom(Pair_2,TimeFrame_2,Indicator_Name_2,Parameter1_2,Line_2,shift);
         if(Parameter1_2!=-100 && Parameter2_2!=-100 && Parameter3_2==-100 && Parameter4_2==-100 && Parameter5_2==-100)
            value=iCustom(Pair_2,TimeFrame_2,Indicator_Name_2,Parameter1_2,Parameter2_2,Line_2,shift);
         if(Parameter1_2!=-100 && Parameter2_2!=-100 && Parameter3_2!=-100 && Parameter4_2==-100 && Parameter5_2==-100)
            value=iCustom(Pair_2,TimeFrame_2,Indicator_Name_2,Parameter1_2,Parameter2_2,Parameter3_2,Line_2,shift);
         if(Parameter1_2!=-100 && Parameter2_2!=-100 && Parameter3_2!=-100 && Parameter4_2!=-100 && Parameter5_2==-100)
            value=iCustom(Pair_2,TimeFrame_2,Indicator_Name_2,Parameter1_2,Parameter2_2,Parameter3_2,Parameter4_2,Line_2,shift);
         if(Parameter1_2!=-100 && Parameter2_2!=-100 && Parameter3_2!=-100 && Parameter4_2!=-100 && Parameter5_2!=-100)
            value=iCustom(Pair_2,TimeFrame_2,Indicator_Name_2,Parameter1_2,Parameter2_2,Parameter3_2,Parameter4_2,Parameter5_2,Line_2,shift);
         break;
        }

      case 3 :
        {
         if(Parameter1_3!=-100 && Parameter2_3==-100 && Parameter3_3==-100 && Parameter4_3==-100 && Parameter5_3==-100)
            value=iCustom(Pair_3,TimeFrame_3,Indicator_Name_3,Parameter1_3,Line_3,shift);
         if(Parameter1_3!=-100 && Parameter2_3!=-100 && Parameter3_3==-100 && Parameter4_3==-100 && Parameter5_3==-100)
            value=iCustom(Pair_3,TimeFrame_3,Indicator_Name_3,Parameter1_3,Parameter2_3,Line_3,shift);
         if(Parameter1_3!=-100 && Parameter2_3!=-100 && Parameter3_3!=-100 && Parameter4_3==-100 && Parameter5_3==-100)
            value=iCustom(Pair_3,TimeFrame_3,Indicator_Name_3,Parameter1_3,Parameter2_3,Parameter3_3,Line_3,shift);
         if(Parameter1_3!=-100 && Parameter2_3!=-100 && Parameter3_3!=-100 && Parameter4_3!=-100 && Parameter5_3==-100)
            value=iCustom(Pair_3,TimeFrame_3,Indicator_Name_3,Parameter1_3,Parameter2_3,Parameter3_3,Parameter4_3,Line_3,shift);
         if(Parameter1_3!=-100 && Parameter2_3!=-100 && Parameter3_3!=-100 && Parameter4_3!=-100 && Parameter5_3!=-100)
            value=iCustom(Pair_3,TimeFrame_3,Indicator_Name_3,Parameter1_3,Parameter2_3,Parameter3_3,Parameter4_3,Parameter5_3,Line_3,shift);
         break;
        }
     }

   return(value);

  }

/*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»««««««««««««««««««««««««««««««««««««««««««««««««««««
//»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»    DOCUMENTATION DIVISION    ««««««««««««««««««««««««««««««««««
//»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»««««««««««««««««««««««««««««««««««««««««««««««««««««

    ««« PURPOSE, SCOPE, AND FUNCTION: »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

        I know very much the pain of using iCustom function and thousand of requests asking me
        about Alerts on crossing an indicator another indicator.

        If you get tired of iCustom usage and Alerts embedding, this indicator for you!
        You can use this indicator to load the indicators you want using iCustom function but
        you will not write a line of code. All what will you do is entering the inputs of the
        indicators you want to load in the Easy iCustom and Alerts input window and when the
        indicator alerts you.


    ««« DESCRIPTION OF PROGRAM USAGE: »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

    Parameters:


        Alert_On_Crossing
            Set this option to true if you want the indicator alerts you when any of the loaded
            indicators has been crossed.


        Pair_1
            Set here the currency pair string you want to use with the first indicator. Use "NULL"
            if you want to work with the current currency.

                EXAMPLE: "EURUSD".


        Indicator_Name_1
            The name of the first indicator you want to load. This name must be the same as the
            file name of the indicator without the .ex4 extension.

                EXAMPLE: "Moving Averages" (the original file name is Moving Averages.ex4)


        TimeFrame_1
            The timeframe (in minutes) of the first indicator you want to load. use 0 if you want
            to work with the current time frame.

                EXAMPLE:   30



                            PERIOD_M1       1
                            PERIOD_M5       5
                            PERIOD_M15     15
                            PERIOD_M30     30 
                            PERIOD_H1      60
                            PERIOD_H4     240
                            PERIOD_D1    1440
                            PERIOD_W1   10080
                            PERIOD_MN1  43200


        Line_1
            The line of the indicator you are loading that you want to use. It's zero based
            number which means the first line is 0 and the second line is 1 and the last line
            is 7 (The maximum value of lines allowed in any indicator are 8 and starts from 0,
            then the last line is 7). The most of the indicator uses only one line, so you will
            use 0 here.


        Parameter1_1
            Set the first parameter of the indicator you want to load as the first line. The
            parameters of the indicator are any values declared as external variables. For
            example the Moving Averages indicator accepts three parameters:

                    extern int   MA_Period
                    extern int   MA_Shift
                    extern int   MA_Method

            So, you have to enter the MA_Period here as the first parameter.


        Parameter2_1
            The second parameter of the indicator you want to load as the first line.


        Parameter3_1
            The third parameter of the indicator you want to load as the first line.


        Parameter4_1
            The fourth parameter of the indicator you want to load as the first line.


        Parameter5_1
            The fifth parameter of the indicator you want to load as the first line.


        Pair_2
            Set here the currency pair string you want to use with the second line.


        Indicator_Name_2
            The name of the second line you want to load.


        TimeFrame_2
            The timeframe (in minutes) of the second line you want to load.


        Line_2
            The line of the second indicator you are loading that you want to use.


        Parameter1_2
            Set the first parameter of the indicator you want to load as the second line.


        Parameter2_2
            The second parameter of the indicator you want to load as the second line.


        Parameter3_2
            The third parameter of the indicator you want to load as the second line.


        Parameter4_2
            The fourth parameter of the indicator you want to load as the second line.


        Parameter5_2
            The fifth parameter of the indicator you want to load as the second line.


        Pair_3
            Set here the currency pair string you want to use with the third line.


        Indicator_Name_3
            The name of the third line you want to load.


        TimeFrame_3
            The timeframe (in minutes) of the third line you want to load.


        Line_3
            The line of the second line you are loading that you want to use.


        Parameter1_3
            Set the first parameter of the indicator you want to load as the third line.


        Parameter2_3
            The second parameter of the indicator you want to load as the third line.


        Parameter3_3
            The third parameter of the indicator you want to load as the third line.


        Parameter4_3
            The fourth parameter of the indicator you want to load as the third line.


        Parameter5_3
            The fifth parameter of the indicator you want to load as the third line.


    ««« FILES DISCRIPTIONS: »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»


    ««« TESTING AND SCRIP DEBUGING: »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»


    ««« VERSION UPDATES: »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

        Current Revisions:

            Version 1.00.01 		KTL		00-00-2006
                *	

        Future Enhancement:
                -	


    ««« CODING, SCRIPT NOTES: »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

        NOTE 1: 
            How to know how many lines (buffers) in an indicator?

        Just open the source code of the indicator in MetaTrader and check the line:
        #property indicator_buffers 1
        The number 1 means 1 line and 2 means 2 line etc (up to 8 lines).

        NOTE 2:
            How to know how many parameters the indicator accept?

        AS I told you before the parameters are the external functions that the indicator uses. 
        So, Open the indicator source code and check how many external functions it uses.

        NOTE 3:
            The order of the external functions declaration in the source code of the indicator
            are the order of the parameters the indicator accept.
        
            EXAMPLE:
                extern int    MA_Period = 13;  <-- Parameter 1
                extern int    MA_Shift  =  0;  <-- Parameter 2
                extern int    MA_Method =  0;  <-- Parameter 3


    ««« CODE STORAGE AREA: »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»


//»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»«««««««««««««««««««««««««««««««««««««««««««««««««««««
//»»»»»»»»»»»»»»»»»    END PROGRAM SCRIPT;        MetaQuote Source Code [ mq4 ]    ««««««««««««««««
//»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»««««««««««««««««««««««««««««««««« [rev.09-20-05] «««*/
//+------------------------------------------------------------------+
»


//»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»«««««««««««««««««««««««««««««««««««««««««««««««««««««
//»»»»»»»»»»»»»»»»»    END PROGRAM SCRIPT;        MetaQuote Source Code [ mq4 ]    ««««««««««««««««
//»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»««««««««««««««««««««««««««««««««« [rev.09-20-05] «««*/
//+------------------------------------------------------------------+
