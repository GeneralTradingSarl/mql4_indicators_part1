//+------------------------------------------------------------------+
//| CoeffofLine_v1.mq4 
//| Kalenzo - Conversion only
//| I added also second line
//| bartlomiej.gorski@gmail.com
//+------------------------------------------------------------------+

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Yellow
#property indicator_color2 Red
#property indicator_level1 Silver
#property indicator_level2 Silver 

extern int fastSeed = 5;
extern int slowSeed = 20;
//---- buffers
double cfl[];
double cfl2[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicator line
   IndicatorBuffers(2);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,cfl);
   SetLevelValue( 0, 0.4); 
   SetLevelValue( 1, -0.4); 
   

      
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,cfl2);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| CoeffofLine                                                              |
//+------------------------------------------------------------------+
int start()
  {
  
   int limit;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) counted_bars=0;
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   counted_bars=limit;
  
   int i,shift,cnt,ndot1,ndot=fastSeed,ndot2=slowSeed;
   double TYVar,ZYVar,TIndicatorVar,ZIndicatorVar,M,N,AY,AIndicator;
 
   for(shift = limit ;shift>=0;shift--)
   {
     
      TYVar=0;
	   ZYVar=0;
	   N=0;
	   M=0;
	   TIndicatorVar=0;
	   ZIndicatorVar=0;

	  for (cnt = ndot; cnt>=1; cnt--)  
	  {
		  ZYVar+=(High[shift+cnt-1]+Low[shift+cnt-1])/2*(6-cnt);
		  TYVar+=(High[shift+cnt-1]+Low[shift+cnt-1])/2;
	 
		  ZIndicatorVar=ZIndicatorVar+iMA(NULL,0,5,3,MODE_SMMA,PRICE_MEDIAN,shift+cnt-1)*(6-cnt);
		  TIndicatorVar=TIndicatorVar+iMA(NULL,0,5,3,MODE_SMMA,PRICE_MEDIAN,shift+cnt-1);
   
   	  AY=(TYVar+(55-2*ZYVar)*5/15)/15;
   	  AIndicator=(TIndicatorVar+(55-2*ZIndicatorVar)*5/15)/15;
     }
	
	cfl[shift]=(-1000)*MathLog(AY/AIndicator);
	
	
	
	   TYVar=0;
	   ZYVar=0;
	   N=0;
	   M=0;
	   TIndicatorVar=0;
	   ZIndicatorVar=0;

	  for (cnt = ndot2; cnt>=1; cnt--)  
	  {
		  ZYVar+=(High[shift+cnt-1]+Low[shift+cnt-1])/2*(6-cnt);
		  TYVar+=(High[shift+cnt-1]+Low[shift+cnt-1])/2;
	 
		  ZIndicatorVar=ZIndicatorVar+iMA(NULL,0,5,3,MODE_SMMA,PRICE_MEDIAN,shift+cnt-1)*(6-cnt);
		  TIndicatorVar=TIndicatorVar+iMA(NULL,0,5,3,MODE_SMMA,PRICE_MEDIAN,shift+cnt-1);
   
   	  AY=(TYVar+(55-2*ZYVar)*5/15)/15;
   	  AIndicator=(TIndicatorVar+(55-2*ZIndicatorVar)*5/15)/15;
     }
	
	  cfl2[shift]=(-1000)*MathLog(AY/AIndicator);
	
	


   }
   return(0);
  }
//+------------------------------------------------------------------+  return(0);
  }
//+------------------------------------------------------------------+
