//+------------------------------------------------------------------+
//|                                                          DRP.mq4 |
//|                                                     Yuriy Tokman |
//|                                            yurietokman@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman"
#property link      "yurietokman@gmail.com"

#property indicator_chart_window
extern color     colir = Red;
extern int       barsToProcess=1000;
       int       total=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   string name;
   for(int i=0;;i++) {
       name=StringConcatenate("drp",DoubleToStr(i,0));
       if(!ObjectDelete(name)) break;
      }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int      counted_bars=IndicatorCounted(),
            per=Period()*60,
            limit=0,
            i=0;
   string   name;
   datetime time=0;
   
   limit=Bars-counted_bars;
   
   if(limit>barsToProcess)
      limit=barsToProcess;

   i=limit-1;
   while (i>=0)
    {
     double x=0.0,
            h = iHigh(NULL,0,i),
            l = iLow(NULL,0,i),
            o = iOpen(NULL,0,i),
            c = iClose(NULL,0,i);
     if(c<o)       x=(h+l+c+l)/2;
     else if(c>o)  x=(h+l+c+h)/2;
     else if(c==o) x=(h+l)/2;
     if(ObjectGet(StringConcatenate("drp",DoubleToStr(total-1,0)),
                                    OBJPROP_TIME1)==Time[0]) {
        ObjectSet(StringConcatenate("drp",DoubleToStr(total-1,0)),
                                    OBJPROP_PRICE1,x-l);
        ObjectSet(StringConcatenate("drp",DoubleToStr(total-1,0)),
                                    OBJPROP_PRICE2,x-h);
        break;
       }
     time=Time[i]+per;
     while(iBarShift(0,0,time,true)==-1 && time<Time[0])
           time+=per; // если "дыра" в истории
     name=StringConcatenate("drp",DoubleToStr(total,0));
     ObjectCreate(name,OBJ_RECTANGLE,0,
                  Time[i],x-l,time,x-h);
     ObjectSet(name,OBJPROP_COLOR,colir);
     total++;
     i--;
    }
   return(0);
  }
//+------------------------------------------------------------------+