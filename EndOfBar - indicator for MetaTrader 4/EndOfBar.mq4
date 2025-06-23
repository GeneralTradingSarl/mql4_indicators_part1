//+------------------------------------------------------------------+
//|                                                    EndingBar.mq4 |
//|                                                    karceWZROKIEM | 
//+------------------------------------------------------------------+

#property copyright "Copyright © 2010, karceWZROKIEM"
#property link      "http://kampno.pl/"

#property indicator_chart_window

extern bool  ShowComment = true;
extern int   EndingTimeM1  = 10;
extern int   EndingTimeM5  = 30;
extern int   EndingTimeM15 = 60;
extern int   EndingTimeM30 = 120;
extern int   EndingTimeH1  = 300;
extern int   EndingTimeH4  = 600;
extern int   EndingTimeD1  = 1800;
extern color ClockColor = Black;
extern color EndingColor = Red;


string comm, ending;

//+------------------------------------------------------------------+

string TimeLeft(int period)
{
	return (TimeToStr( (iTime(NULL,period,0)+period*60-TimeCurrent( )), TIME_MINUTES|TIME_SECONDS) );
}

bool isEnding(int period, int endingtime)
{
	return ( (iTime(NULL,period,0)+period*60-TimeCurrent( )) < endingtime );
}

void Clear()
{
	ObjectDelete("timeCurr");
	ObjectDelete("timeEnding");
}

void Generate(int period)
{
	ending = "";
   int indent=10, i;

   for(i=0; i<indent; i++)  ending = StringConcatenate(" ", ending);
   ObjectCreate("timeCurr", OBJ_TEXT, 0, Time[0], Close[0]);
	ObjectSetText("timeCurr", StringConcatenate(ending,TimeLeft(Period())), 8, "fixedsys", ClockColor);
	
	indent += 21;
   for(i=0; i<indent; i++)  ending = StringConcatenate(" ", ending);
   
   if(isEnding(PERIOD_M1, EndingTimeM1))   ending = StringConcatenate(ending," M1");
   else                     indent+=2;
   if(isEnding(PERIOD_M5, EndingTimeM5))   ending = StringConcatenate(ending," M5");
   else                     indent+=2;
   if(isEnding(PERIOD_M15, EndingTimeM15)) ending = StringConcatenate(ending," M15");
   else                     indent+=3;
   if(isEnding(PERIOD_M30, EndingTimeM30)) ending = StringConcatenate(ending," M30");
   else                     indent+=3;
   if(isEnding(PERIOD_H1, EndingTimeH1))   ending = StringConcatenate(ending," H1");
   else                     indent+=2;
   if(isEnding(PERIOD_H4, EndingTimeH4))   ending = StringConcatenate(ending," H4");
   else                     indent+=2;
   if(isEnding(PERIOD_D1, EndingTimeD1))   ending = StringConcatenate(ending," D1");
   else                     indent+=2;

   for(i=0; i<indent; i++)  ending = StringConcatenate(ending," ");
   
   if (indent < 41+18)
   {
      ObjectCreate("timeEnding", OBJ_TEXT, 0, Time[0], Close[0]);
	   ObjectSetText("timeEnding", ending, 8, "fixedsys", EndingColor);
   }
}

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

int init()
{
	return(0);
}

int deinit()
{
	ObjectDelete("time");
	Comment("");
	return(0);
}
//void deinit() 
//  {
//   Comment("");
//  }


//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
	comm = ""; 

	//---
	//   comm =   
	//"Current TF:  " +  h + " hour(s) "+  (m-(h*60)) + " min. " + s + " sec. left to bar end;\n";
	if(ShowComment)
      Comment( StringConcatenate(
         "  D1: ", TimeLeft(PERIOD_D1), ", warn: ", EndingTimeD1, "s\n",
         "  H4: ", TimeLeft(PERIOD_H4), ", warn: ", EndingTimeH4, "s\n",
         "  H1: ", TimeLeft(PERIOD_H1), ", warn: ", EndingTimeH1, "s\n",
         "M30: ", TimeLeft(PERIOD_M30), ", warn: ", EndingTimeM30, "s\n",
         "M15: ", TimeLeft(PERIOD_M15), ", warn: ", EndingTimeM15, "s\n",
         "  M5: ", TimeLeft(PERIOD_M5), ", warn: ", EndingTimeM5, "s\n",
         "  M1: ", TimeLeft(PERIOD_M1), ", warn: ", EndingTimeM1, "s\n") 
      );

	Clear();
	Generate(Period());

	return(0);
}
//+------------------------------------------------------------------+


