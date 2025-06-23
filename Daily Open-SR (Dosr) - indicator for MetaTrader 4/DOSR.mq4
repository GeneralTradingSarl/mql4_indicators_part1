//+------------------------------------------------------------------+
//|                  Daily Open-SR Technique                         |
//|                                                         DOSR.mq4 |
//|                                              Developed by mqldev |
//|                                            http://www.mqldev.com |
//+------------------------------------------------------------------+
#property link      "http://www.mqldev.com"
#property indicator_chart_window
//----
extern color   ResistanceColor=Red;
extern color   SupportColor   =Blue;
extern color   TodayOpenColor =Yellow;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   DelObjs();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   DelObjs();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void start()
  {
   double c=iClose(NULL,PERIOD_D1,1);
   double o=iOpen(NULL,PERIOD_D1,1);
   double h=iHigh(NULL,PERIOD_D1,1);
   double l=iLow(NULL,PERIOD_D1,1);
   double to=iOpen(NULL,PERIOD_D1,0);
//----
   Print("close:",c," open:",o," high:",h," low:",l);
   if (c>=o)
     {
      DrawLine(h,"Resistance",ResistanceColor);
      DrawLine(o,"Support",SupportColor);
     }
   else
     {
      DrawLine(o,"Resistance",ResistanceColor);
      DrawLine(l,"Support",SupportColor);
     }
   DrawLine(to,"Today Open",TodayOpenColor);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int DrawLine(double price  , string Obj , color clr)
  {
   int objs=ObjectsTotal();
   string name;
   for(int cnt=ObjectsTotal()-1;cnt>=0;cnt--)
     {
      name=ObjectName(cnt);
      if (StringFind(name,Obj,0)>-1)
        {
         ObjectMove(Obj,0,Time[0],price);
         ObjectsRedraw();
         return(1);
        }
     }
   ObjectCreate(Obj,OBJ_HLINE,0,0,price);
   ObjectSet(Obj,OBJPROP_COLOR,clr);
   WindowRedraw();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DelObjs()
  {
   int objs=ObjectsTotal();
   string name;
   for(int cnt=ObjectsTotal()-1;cnt>=0;cnt--)
     {
      name=ObjectName(cnt);
      if (StringFind(name,"L",0)>-1) ObjectDelete(name);
      WindowRedraw();
     }
  }
//+------------------------------------------------------------------+