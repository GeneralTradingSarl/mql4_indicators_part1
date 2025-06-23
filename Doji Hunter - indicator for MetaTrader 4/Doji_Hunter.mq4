//+------------------------------------------------------------------+
//|                                                      Doji Hunter |
//|                                Copyright © 2010, Investors Haven |
//|                                    http://www.InvestorsHaven.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, Investors Haven"
#property link      "http://www.InvestorsHaven.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 clrNONE
#property indicator_width1 0

extern int       RangeOfBars = 100;
extern bool      ShowCandleBox=true; //false to hide the candle box
extern color     BoxColor=MistyRose; //add your fav color 
extern bool      UseECNExecution = true; // Whether or not to set SL when creating the order.


//---- input parameters for regular doji
extern bool         FindRegularDoji=true; //false to disable
extern double       MinLengthOfUpTail=0.1; //candle with upper tail equal or more than this will show up
extern double       MinLengthOfLoTail=0.1; //candle with lower tail equal or more than this will show up
extern double       MaxLengthOfBody=0.2; //candle with body less or equal with this will show up
     
//---- input parameters for dragonfly doji
extern bool         FindDragonflyDoji=true; //false to disable
extern double       MaxLengthOfUpTail1=0; //candle with upper tail equal or more than this will show up
extern double       MinLengthOfLoTail1=0.1; //candle with lower tail equal or more than this will show up
extern double       MaxLengthOfBody1=0.2; //candle with body less or equal with this will show up

//---- input parameters for gravestone doji
extern bool         FindGravestoneDoji=true; //false to disable
extern double       MinLengthOfUpTail2=0.1; //candle with upper tail equal or more than this will show up
extern double       MaxLengthOfLoTail2=0; //candle with lower tail equal or more than this will show up
extern double       MaxLengthOfBody2=0.2; //candle with body less or equal with this will show up

//---- initialization for variables
int counter1=1, counter2=1, counter3=1;
double                        PipPoints = 0.0;
double dis=0;

//---- buffers                               
double Doji[];                         

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
  
   if (Digits < 4)
   {
      PipPoints = 0.01;
   }
   else 
   {
      PipPoints = 0.0001;
   }  
   
   if(UseECNExecution) 
   {
      switch (Period())
      {
         case 1:
         {
            dis=10*PipPoints;
            break;
         }
         case 5:
         {
            dis=15*PipPoints;
            break;
         }
         case 15:
         {
            dis=25*PipPoints;
            break;
         }
         case 30:
         {
            dis=35*PipPoints;
            break;
         }
         case 60:
         {
            dis=45*PipPoints;
            break;
         }
         case 240:
         {
            dis=75*PipPoints;
            break;
         }
         case 1440:
         {
            dis=175*PipPoints;
            break;
         }
         case 10080:
         {
            dis=230*PipPoints;
            break;
         }
         case 43200:
         {
            dis=350*PipPoints;
            break;
         }
      }
   }
   else 
   {
      switch (Period())
      {
         case 1:
         {
            dis=20*PipPoints;
            break;
         }
         case 5:
         {
            dis=30*PipPoints;
            break;
         }
         case 15:
         {
            dis=50*PipPoints;
            break;
         }
         case 30:
         {
            dis=75*PipPoints;
            break;
         }
         case 60:
         {
            dis=90*PipPoints;
            break;
         }
         case 240:
         {
            dis=150*PipPoints;
            break;
         }
         case 1440:
         {
            dis=350*PipPoints;
            break;
         }
         case 10080:
         {
            dis=460*PipPoints;
            break;
         }
         case 43200:
         {
            dis=700*PipPoints;
            break;
         }
      }
  }
  
   SetIndexBuffer(0,Doji);  
  return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- delete all object 
   // ObjectsDeleteAll(0, OBJ_RECTANGLE);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i, counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   
   if (counter1 > 1 || counter2 > 1 || counter3 > 1)
   {
      ObjectsDeleteAll(0, OBJ_RECTANGLE);
      counter1 = 0;
      counter2 = 0;
      counter3 = 0;
   }
   
      for(i=1;i<=RangeOfBars;i++)            
      {                                    
         Doji[RangeOfBars-i]=0;         
      }
        
      for(i=RangeOfBars; i>0; i--)
      {

       if(FindRegularDoji)
         {
          if(High[i]-Close[i]>=MinLengthOfUpTail*PipPoints && Close[i]-Low[i]>=MinLengthOfLoTail*PipPoints  && MathAbs(Close[i]-Open[i])<=MaxLengthOfBody*PipPoints) 
            {
               Doji[i] = 1;
             if(ShowCandleBox) 
               {
                if(ObjectFind("box 1"+counter1)==-1)
                  {
                   ObjectCreate("box 1"+counter1, OBJ_RECTANGLE, 0, Time[i+1], High[i]+(MathMin(Open[i], Close[i])-Low[i])/2, Time[i-1], Low[i]-(MathMin(Open[i], Close[i])-Low[i])/2);
                   ObjectSet("box 1"+counter1, OBJPROP_COLOR, BoxColor);
                  }
               } 

              counter1++;
            }
         } 
       if(FindDragonflyDoji)
         {
            Doji[i] = 1;
          if(High[i]-Close[i]<=MaxLengthOfUpTail1*PipPoints && Close[i]-Low[i]>=MinLengthOfLoTail1*PipPoints  && MathAbs(Close[i]-Open[i])<=MaxLengthOfBody1*PipPoints)
            {
             counter2++;
             if(ShowCandleBox) 
               {
                if(ObjectFind("box 2"+counter2)==-1)
                  {
                   ObjectCreate("box 2"+counter2, OBJ_RECTANGLE, 0, Time[i+1], High[i]+(MathMin(Open[i], Close[i])-Low[i])/2, Time[i-1], Low[i]-(MathMin(Open[i], Close[i])-Low[i])/2);
                   ObjectSet("box 2"+counter2, OBJPROP_COLOR, BoxColor);
                  }
               } 
             }
         } 
       if(FindGravestoneDoji)
         {
            Doji[i] = 1;
          if(High[i]-Close[i]>=MinLengthOfUpTail2*PipPoints && Close[i]-Low[i]<=MaxLengthOfLoTail2*PipPoints  && MathAbs(Close[i]-Open[i])<=MaxLengthOfBody2*PipPoints)
            {
             counter3++;
             if(ShowCandleBox) 
               {
                if(ObjectFind("box 3"+counter3)==-1)
                  {
                   ObjectCreate("box 3"+counter3, OBJ_RECTANGLE, 0, Time[i+1], High[i]+(MathMin(Open[i], Close[i])-Low[i])/2, Time[i-1], Low[i]-(High[i]-MathMax(Open[i], Close[i]))/2);
                   ObjectSet("box 3"+counter3, OBJPROP_COLOR, BoxColor);
                  }
               } 
            }
         } 
      } 
          
   return(0);
  } //end of file 
//+------------------------------------------------------------------+