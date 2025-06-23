/*///+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
Indicator shows a vertical lines at last week bar .
Counted_Bars - number of bars in the calculation, 0 means all bars.
type_line - type line.
Color - color line.
Indicator runs once, to run again make reinitialization.
Indicator deletes only its own lines, the lines are names using the bar dates.
/*///+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
//+------------------------------------------------------------------+
//|                                                 Friday_Lines.mq4 |
//|                                                            Urain |
//+------------------------------------------------------------------+
#property copyright "Urain"
#property link      ""
 
#property indicator_chart_window
extern int   Counted_Bars=0;
extern int   type_line=0;
extern color Color=Red;
string Name[]; int j=0;
bool f=1;
//+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
 
int init()
{//+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
 if(Counted_Bars==0)Counted_Bars=Bars-1;
return(0);
}//+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
 
int deinit()
{//+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
 for(int i=0;i<j;i++)ObjectDelete(Name[i]); 
return(0);
}//+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
 
int start()
{//+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
 if(!f)return(0); f=0;
 for(int i=Counted_Bars;i>0;i--)
    if(TimeDayOfWeek(Time[i])-TimeDayOfWeek(Time[i-1])>1)
       VLine(i);
         
return(0);
}//+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
 
void VLine(int ls)
{//+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 string name= Times( ls);
 j++; ArrayResize(Name,j); Name[j-1]= name;
 if(ObjectFind( name)==-1)ObjectCreate(name, OBJ_VLINE,0,Time[ls],0);
 ObjectSet(name, OBJPROP_BACK,1);
 ObjectSet(name, OBJPROP_TIME1, Time[ls]);
 ObjectSet(name, OBJPROP_COLOR, Color);
 ObjectSet(name, OBJPROP_STYLE, type_line);
return(0);
}//+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 
string Times(int Sdvig, bool time=false)
{//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       string YEAR   = TimeYear( Time[Sdvig]);
       string DAY    = TimeDay( Time[Sdvig]);
       string HOUR   = TimeHour( Time[Sdvig]);
       string MINUTE = TimeMinute( Time[Sdvig]);
       int month = TimeMonth( Time[Sdvig]);
       string MONTH;
       switch(month)
             {case 1: MONTH = "jan";break;
              case 2: MONTH = "feb";break;
              case 3: MONTH = "mar";break;
              case 4: MONTH = "apr";break;
              case 5: MONTH = "may";break;
              case 6: MONTH = "jun";break;
              case 7: MONTH = "jul";break;
              case 8: MONTH = "aug";break;
              case 9: MONTH = "sep";break;
              case 10: MONTH = "oct";break;
              case 11: MONTH = "nov";break;
              case 12: MONTH = "dec";break;              
              default: MONTH = "---";break;
             }
        if(TimeHour( Time[Sdvig])<10) HOUR= "0"+HOUR;     
        if(MINUTE=="0")MINUTE="00";
 if(time)return(HOUR+":"+MINUTE);                   
 else return(YEAR+"   "+MONTH+" "+DAY+"   "+HOUR+":"+MINUTE);
}//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~






