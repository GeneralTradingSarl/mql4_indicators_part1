//+------------------------------------------------------------------+
//|                                              candles_01.mq4 |
//|                                 |
//+------------------------------------------------------------------+

//---- indicator settings
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Red
#property indicator_color2 Green
#property indicator_color3 White
#property indicator_color4 Black
#property indicator_width1 3
#property indicator_width2 3
#property indicator_width3 2
#property indicator_minimum 0

//---- indicator parameters
extern int MA=13;
extern int t=20;
//---- indicator buffers
double Buf1[];
double Buf2[];
double Buf3[];
double Buf4[];

int init()	
{  
   IndicatorShortName("Candles");
   
   SetIndexStyle(0,DRAW_HISTOGRAM);   SetIndexBuffer(0,Buf1);
   SetIndexStyle(1,DRAW_HISTOGRAM);   SetIndexBuffer(1,Buf2);
   SetIndexStyle(2,DRAW_HISTOGRAM);   SetIndexBuffer(2,Buf3);
   SetIndexStyle(3,DRAW_LINE);        SetIndexBuffer(3,Buf4);
   
      ObjectDelete("Time_Timer2");
         ObjectDelete("Candles_n");

      
   return(0);
}
int deinit()
{	

      ObjectDelete("Time_Timer2");
         ObjectDelete("Candles_n");

   return(0);  
}

int start()
{  
   int id=WindowFind("Candles");
   int nu=0;
   int nd=0;
	
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int lim = Bars - counted_bars;
   if(counted_bars==0) lim--;	
	
	double HL1, HL2, OC;
	
	for(int i=0; i<lim; i++)
		{
   	if ((Open[i]-Close[i])>0) HL1=High[i]-Low[i];// длина свечей с тенями красных
   	else HL1=0;
		Buf1[i]=HL1;
      }

	for(i=0; i<lim; i++)
		{
		if ((Open[i]-Close[i])>0) HL2=0;// длина свечей с тенями зеленых
		else HL2=High[i]-Low[i];
		Buf2[i]=HL2;  
      }

	for(i=0; i<lim; i++)
		{  
 		OC=MathAbs(Open[i]-Close[i]);// длина тела свечи
		Buf3[i]=OC;     
      }
      
	for(i=0; i<lim; i++)
		{       
      Buf4[i]=iMAOnArray(Buf3,0,MA,0,MODE_SMA,i);// средняя длина тела свечей
      }

     //отношение количества полных зеленых свечей к красным
 	for(i=0; i<t; i++)
		{       
      if ((Open[i]-Close[i])>0) nu=nu+1;
		else nd=nd+1;
      }  
      
      ObjectDelete("Candles_n");
      ObjectCreate("Candles_n", OBJ_LABEL,id,0,0);
      ObjectSet("Candles_n", OBJPROP_CORNER,1);
      ObjectSet("Candles_n", OBJPROP_XDISTANCE,5);
      ObjectSet("Candles_n", OBJPROP_YDISTANCE,20);
      if (nu < nd) ObjectSetText("Candles_n",nu+" / "+nd, 8, "Arial", Green);
      if (nu == nd) ObjectSetText("Candles_n",nu+" / "+nd, 8, "Arial", Gray);
      if (nu > nd) ObjectSetText("Candles_n",nu+" / "+nd, 8, "Arial", Red);
      

     
     // <-timer
      ObjectDelete("Time_Timer2");

      int tmp1=Period()*60-TimeCurrent()+Time[0];
      int tmpm=MathFloor(tmp1/60),tmps=tmp1-tmpm*60;
      string strm=DoubleToStr(tmpm,0);
      string strs=DoubleToStr(tmps,0);
      if(StringLen(strs)==1) strs="0"+strs;

      int tmp2=TimeCurrent()-Time[0];
      int tmpm2=MathFloor(tmp2/60),tmps2=tmp2-tmpm2*60;
      string strm2=DoubleToStr(tmpm2,0);
      string strs2=DoubleToStr(tmps2,0);
      if(StringLen(strs2)==1) strs2="0"+strs2;
   
      ObjectCreate("Time_Timer2", OBJ_LABEL,id,0,0);
      ObjectSet("Time_Timer2", OBJPROP_CORNER,1); //0
      ObjectSet("Time_Timer2", OBJPROP_XDISTANCE,5); //550
      ObjectSet("Time_Timer2", OBJPROP_YDISTANCE,0);
      ObjectSetText("Time_Timer2",strm+" : "+strs, 8, "Arial", Blue);
      
	return(0);
}
//+------------------------------------------------------------------+