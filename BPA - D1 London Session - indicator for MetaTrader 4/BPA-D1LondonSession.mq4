//+------------------------------------------------------------------+
//| BPA - D1 London Session.mq4.mq4
//| © Ricky.Ricx @ BrooksPriceAction.com
//| http://www.brookspriceaction.com/
//+------------------------------------------------------------------+
#property copyright "© Ricky.Ricx @ BrooksPriceAction.com"
#property link      "http://www.brookspriceaction.com"

#property indicator_chart_window

extern string  London_Open="03:00";
extern string  London_Close="11:55"; //since this use M5 data to find OHLC D1 candle so london close is 11:55 is the same as 12:00
extern int     Show_How_Many_Bars=108;
extern string  To_Change_DST_Bars_Insert_Below="OR If All bars are in DST just change London Open & Close";
extern string  Please_NOTE="If no change insert -1 to both";
extern int     From_Bar=-1,
               To_Bar=-1;

int init()
  {

   int   n,
         addonehour;
      for(n=Show_How_Many_Bars; n!=0; n--)
      {
         if(From_Bar>-1)
         {
            if(From_Bar>=n && n<=To_Bar) addonehour=3600;
         }
            else addonehour=0;
         candle(n,addonehour);
      }
   return(0);
  }

int deinit()
  {
   int      totalobjects;
   totalobjects=ObjectsTotal();

   ObjectsDeleteAll();
   return(0);
  }

int start()
  {
   int      counted_bars=IndicatorCounted(),
            addonehour=0;

   //if time is not greater than open time it will do nothing
   if(TimeHour(TimeCurrent())>=StrToDouble(London_Open))
   {
      if(To_Bar>-1)
      {
         if(From_Bar>=0 && 0<=To_Bar) addonehour=3600;
      }
      candle(0, addonehour);
   }
   return(0);
  }

void candle(int n, int addonehour)
  {
   int      openbar=0,
            closebar=0,
            highestbar=0,
            lowestbar=0;
   double   openprice=0,
            openhigh=0,
            openlow=0,
            closeprice=0,
            closelow=0,
            closehigh=0,
            highestprice=0,
            lowestprice=0;
   datetime candledate,
            opentime,
            closetime,
            hightime,
            lowtime;
   string   candledatestr,
            opentimestr,
            closetimestr,
            hightimestr,
            lowtimestr;

   //find this bar date
   candledate=iTime(Symbol(), PERIOD_D1, n);
   candledatestr=TimeToStr(candledate, TIME_DATE);
   
   //find this bar open date & time
      opentimestr=candledatestr+" "+London_Open;
      opentime=StrToTime(opentimestr)+addonehour;
   //find open bar number at lower timeframe
      openbar=iBarShift(Symbol(), 5, opentime, false);
   openprice=iOpen(Symbol(), 5, openbar);

   //find this bar close date & time
      closetimestr=candledatestr+" "+London_Close;
      closetime=StrToTime(closetimestr)+addonehour;
   //find close bar number at lower timeframe
      closebar=iBarShift(Symbol(), 5, closetime, false);
   closeprice=iClose(Symbol(), 5, closebar);

   //when current bar is [0] show how many bars should be recalculated
      if(n==0) Show_How_Many_Bars=openbar-closebar;

   //find highest and lowest bar number
      highestbar=iHighest(Symbol(), 5, MODE_HIGH, Show_How_Many_Bars, closebar);
      lowestbar=iLowest(Symbol(), 5, MODE_LOW, Show_How_Many_Bars, closebar);

   //find highest and lowest price
      highestprice=iHigh(Symbol(), 5, highestbar);
      openhigh=iHigh(Symbol(), 5, openbar);
      closehigh=iHigh(Symbol(), 5, closebar);
   if(openhigh>=highestprice) highestprice=openhigh;
   if(closehigh>=highestprice) highestprice=closehigh;
      lowestprice=iLow(Symbol(), 5, lowestbar);
      openlow=iLow(Symbol(), 5, openbar);
      closelow=iLow(Symbol(), 5, closebar);
   if(openlow<=lowestprice) lowestprice=openlow;
   if(closelow<=lowestprice) lowestprice=closelow;

   //plot candle body
   if(ObjectFind(candledatestr+" candlebody")==-1) ObjectCreate(candledatestr+" candlebody", OBJ_TREND, 0, 0, 0);
   ObjectSet(candledatestr+" candlebody", OBJPROP_PRICE1, openprice);
   ObjectSet(candledatestr+" candlebody", OBJPROP_PRICE2, closeprice);
   ObjectSet(candledatestr+" candlebody", OBJPROP_TIME1, candledate);
   ObjectSet(candledatestr+" candlebody", OBJPROP_TIME2, candledate);
   ObjectSet(candledatestr+" candlebody", OBJPROP_RAY, false);
   ObjectSet(candledatestr+" candlebody", OBJPROP_BACK, true);
   ObjectSet(candledatestr+" candlebody", OBJPROP_WIDTH, 5);
   ObjectSet(candledatestr+" candlebody", OBJPROP_COLOR, Black);

   //plot bull candle body
   if(openprice<closeprice)
   {
      if(ObjectFind(candledatestr+" bull candlebody")==-1) ObjectCreate(candledatestr+" bull candlebody", OBJ_TREND, 0, 0, 0);
      ObjectSet(candledatestr+" bull candlebody", OBJPROP_PRICE1, openprice);
      ObjectSet(candledatestr+" bull candlebody", OBJPROP_PRICE2, closeprice);
      ObjectSet(candledatestr+" bull candlebody", OBJPROP_TIME1, candledate);
      ObjectSet(candledatestr+" bull candlebody", OBJPROP_TIME2, candledate);
      ObjectSet(candledatestr+" bull candlebody", OBJPROP_RAY, false);
      ObjectSet(candledatestr+" bull candlebody", OBJPROP_WIDTH, 3);
      ObjectSet(candledatestr+" bull candlebody", OBJPROP_COLOR, White);
   }

   //plot candle shadows
   if(ObjectFind(candledatestr+" candleshadow")==-1) ObjectCreate(candledatestr+" candleshadow", OBJ_TREND, 0, 0, 0);
   ObjectSet(candledatestr+" candleshadow", OBJPROP_PRICE1, highestprice);
   ObjectSet(candledatestr+" candleshadow", OBJPROP_PRICE2, lowestprice);
   ObjectSet(candledatestr+" candleshadow", OBJPROP_TIME1, candledate);
   ObjectSet(candledatestr+" candleshadow", OBJPROP_TIME2, candledate);
   ObjectSet(candledatestr+" candleshadow", OBJPROP_RAY, false);
   ObjectSet(candledatestr+" candleshadow", OBJPROP_BACK, true);
   ObjectSet(candledatestr+" candleshadow", OBJPROP_WIDTH, 1);
   ObjectSet(candledatestr+" candleshadow", OBJPROP_COLOR, Black);

   return(0);
  }