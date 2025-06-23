//+------------------------------------------------------------------------------------+
//| Din_fibo_Next.mq4                                                                  |
//| unknown author, get from kaizer, conversed by Rosh                                 |
//| link to kaizer: http://forum.alpari-idc.ru/profile.php?mode=viewprofile&u=4196161  |
//| http://forexsystems.ru/phpBB/index.php                                             |
//+------------------------------------------------------------------------------------+
#property copyright "unknown author, get from kaizer, conversed by Rosh"
#property link      "http://fx.winm.ru/book.htm"
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Red
//---- input parameters
extern int       Fibo_Channel_Period=3;
extern double    Ratio=0.786;
extern bool      SetAllBars=false;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double tvBuffer[];
int hh,ll,first,counterPeriod;
double tv,MaH,MaL;
//+------------------------------------------------------------------+
//| Получим следующий период                                         |
//+------------------------------------------------------------------+
string GetNextPeriod(int period)
  {
   string nextPeriod="";
//---- 
   switch(period)
     {
      case 5: nextPeriod="H1"; break;
      case 15: nextPeriod="H1"; break;
      case 30: nextPeriod="H4"; break;
      case 60: nextPeriod="H4"; break;
      case 240: nextPeriod="D1"; break;
      case 1440: nextPeriod="W1"; break;
      case 10080: nextPeriod="M"; break;
      default: Print("Недопустимый период!!!");
     }
//----
   return(nextPeriod);
  }
//+------------------------------------------------------------------+
//| Проверим - разделитель диапазона или нет                         |
//+------------------------------------------------------------------+
bool isDelimeter(int period, int _shift)
  {
   bool result=false;
//---- 
   switch(period)
     {
      case 5:result=(TimeMinute(Time[_shift])==0); break;
      case 15:result=(TimeMinute(Time[_shift])==0); break;
      case 30:result=(TimeMinute(Time[_shift])==0)&& MathMod(TimeHour(Time[_shift]),4.0)==0.0; break;
      case 60:result=(TimeMinute(Time[_shift])==0)&& MathMod(TimeHour(Time[_shift]),4.0)==0.0;break;
      case 240:result=(TimeMinute(Time[_shift])==0)&&(TimeHour(Time[_shift])==0); break;
      case 1440:result=(TimeDayOfWeek(Time[_shift])==1)&&(TimeHour(Time[_shift])==0); break;
      case 10080:result=(TimeDay(Time[_shift])==1)||((TimeDay(Time[_shift])==2 && TimeDay(Time[_shift+1])!=1))||((TimeDay(Time[_shift])==3 && TimeDay(Time[_shift+1])!=2)); break;
      default: Print("Недопустимый период!!!");
     }
//----
   return(result);
  }
//+------------------------------------------------------------------+
//| Установим MaH и MaL на границе диапазона                         |
//+------------------------------------------------------------------+
void SetHnL(int _shift)
  {
//---- 
   int i=_shift+1;
   counterPeriod=0;
   first=0;
   while(counterPeriod<Fibo_Channel_Period)
     {
      while(i<Bars && tvBuffer[i]==0.0) i++;
      if (first==0) first=i;
      counterPeriod++;
      i++;
     }
   i-=Fibo_Channel_Period;
   hh=Highest(NULL,0,MODE_HIGH,i-_shift,_shift+1);
   ll=Lowest(NULL,0,MODE_LOW,i-_shift,_shift+1);
   tv=NormalizeDouble((High[hh]+Low[ll]+Close[_shift+1])/3.0,Digits);
   MaH=tv+NormalizeDouble((High[hh]-Low[ll])/2.0*Ratio,Digits);
   MaL=tv-NormalizeDouble((High[hh]-Low[ll])/2.0*Ratio,Digits);
   tvBuffer[_shift]=tv;
   ExtMapBuffer1[_shift]=MaH;
   ExtMapBuffer2[_shift]=MaL;
   if (SetAllBars) SetMovingHnL(first, _shift);
//----
   return;
  }
//+------------------------------------------------------------------+
//| Установим MaH и MaL внутри диапазона                             |
//+------------------------------------------------------------------+
void SetMovingHnL(int _DelimeterBar,int CurBar)
  {
   int m_cnt;
   double deltaH,deltaL;
//---- 
   deltaH=(ExtMapBuffer1[_DelimeterBar]-ExtMapBuffer1[CurBar])/(_DelimeterBar-CurBar);
   deltaL=(ExtMapBuffer2[_DelimeterBar]-ExtMapBuffer2[CurBar])/(_DelimeterBar-CurBar);
   for(m_cnt=_DelimeterBar-1;m_cnt>CurBar;m_cnt--)
     {
      ExtMapBuffer1[m_cnt]=ExtMapBuffer1[m_cnt+1]-deltaH;
      ExtMapBuffer2[m_cnt]=ExtMapBuffer2[m_cnt+1]-deltaL;
     }
   for(m_cnt=_DelimeterBar-1;m_cnt>CurBar;m_cnt--)
     {
      ExtMapBuffer1[m_cnt]=NormalizeDouble(ExtMapBuffer1[m_cnt],Digits);
      ExtMapBuffer2[m_cnt]=NormalizeDouble(ExtMapBuffer2[m_cnt],Digits);
     }
//----
   return;
  }
//+------------------------------------------------------------------+
//| Установим MaH и MaL на правом краю                               |
//+------------------------------------------------------------------+
void SetValuesNullBar(int _shift)
  {
//---- 
   int i=_shift;
   while(tvBuffer[i]==0.0) i++;
   for(int j=i-1;j>_shift;j--)
     {
      ExtMapBuffer1[j]=0.0;
      ExtMapBuffer2[j]=0.0;
     }
   first=0;
   i=_shift;
   counterPeriod=0;
   while(counterPeriod<Fibo_Channel_Period)
     {
      while(tvBuffer[i]==0.0 && i<Bars) i++;
      if (first==0) first=i;
      counterPeriod++;
      i++;
     }
   i--;
   hh=Highest(NULL,0,MODE_HIGH,i-_shift,_shift);
   ll=Lowest(NULL,0,MODE_LOW,i-_shift,_shift);
   tv=NormalizeDouble((High[hh]+Low[ll]+Close[_shift])/3.0,Digits);
   MaH=tv+NormalizeDouble((High[hh]-Low[ll])/2.0*Ratio,Digits);
   MaL=tv-NormalizeDouble((High[hh]-Low[ll])/2.0*Ratio,Digits);
   ExtMapBuffer1[_shift]=MaH;
   ExtMapBuffer2[_shift]=MaL;
   if (SetAllBars) SetMovingHnL(first,_shift);
//----
   return;
  }//-------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(3);
   string label;
   if (SetAllBars)
     {
      SetIndexStyle(0,DRAW_LINE);
      SetIndexBuffer(0,ExtMapBuffer1);
      label="DFC Next "+GetNextPeriod(Period())+"("+Fibo_Channel_Period+") MaH";
      SetIndexLabel(0,label);
      SetIndexEmptyValue(0,0.0);
//----
      SetIndexStyle(1,DRAW_LINE);
      SetIndexBuffer(1,ExtMapBuffer2);
      label="DFC Next "+GetNextPeriod(Period())+"("+Fibo_Channel_Period+") MaL";
      SetIndexLabel(1,label);
      SetIndexEmptyValue(1,0.0);
     }
   else
     {
      SetIndexStyle(0,DRAW_SECTION);
      SetIndexBuffer(0,ExtMapBuffer1);
      label="DFC Next "+GetNextPeriod(Period())+"("+Fibo_Channel_Period+") MaH";
      SetIndexLabel(0,label);
      SetIndexEmptyValue(0,0.0);
//----
      SetIndexStyle(1,DRAW_SECTION);
      SetIndexBuffer(1,ExtMapBuffer2);
      label="DFC Next "+GetNextPeriod(Period())+"("+Fibo_Channel_Period+") MaL";
      SetIndexLabel(1,label);
      SetIndexEmptyValue(1,0.0);
     }
   SetIndexBuffer(2,tvBuffer);
   SetIndexEmptyValue(2,0.0);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   int cnt,limit;
//---- 
   if (Period()==10080 || Period()==1) return(0);
   if (counted_bars<0) return(-1);
   if (counted_bars>0) limit=Bars-counted_bars;
   if (counted_bars==0)
     {
      // найти первый и второй разделитель и установить limit
      cnt=Bars-1;
      while(!isDelimeter(Period(),cnt)) cnt--;
      first=cnt;
      cnt--;
      counterPeriod=0;
      while(counterPeriod<Fibo_Channel_Period)
        {
         while(!isDelimeter(Period(),cnt)) cnt--;
         cnt--;
         counterPeriod++;
        }
      cnt++;
      hh=Highest(NULL,0,MODE_HIGH,first-cnt,cnt+1);
      ll=Lowest(NULL,0,MODE_LOW,first-cnt,cnt+1);
      tv=NormalizeDouble((High[hh]+Low[ll]+Close[cnt+1])/3.0,Digits);
      MaH=tv+NormalizeDouble((High[hh]-Low[ll])/2.0*Ratio,Digits);
      MaL=tv-NormalizeDouble((High[hh]-Low[ll])/2.0*Ratio,Digits);
      tvBuffer[cnt]=tv;
      ExtMapBuffer1[cnt]=MaH;
      ExtMapBuffer2[cnt]=MaL;
      limit=cnt-1;
     }
//----
   for(int shift=limit;shift>=0;shift--)
     {
      if (isDelimeter(Period(),shift)) SetHnL(shift);// else SetMovingHnL(shift);
      if (shift==0) SetValuesNullBar(shift);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+