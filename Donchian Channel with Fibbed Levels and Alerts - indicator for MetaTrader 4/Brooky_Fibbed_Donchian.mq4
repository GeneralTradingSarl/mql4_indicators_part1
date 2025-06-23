//+------------------------------------------------------------------+
//|                                       Brooky_Fibbed_Donchian.mq4 |
//|                     Copyright © 2010, www.Brooky-Indicators.com. |
//|                             http://www.www.Brooky-Indicators.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, www.Brooky-Indicators.com."
#property link      "http://www.www.Brooky-Indicators.com"
extern string Hello_From = " www.Brooky-Indicators.com ";

//---- indicator settings
#property  indicator_chart_window
#property  indicator_buffers 7
#property  indicator_color1  Red
#property  indicator_color2  Blue
#property  indicator_width1  1
#property  indicator_width2  1

#property  indicator_color3  Orange
#property  indicator_color4  DodgerBlue
#property  indicator_width3  1
#property  indicator_width4  1

#property  indicator_color5  Yellow
#property  indicator_color6  Aqua
#property  indicator_width5  1
#property  indicator_width6  1

#property  indicator_color7  Aqua
#property  indicator_width7  2
//---- indicator parameters

extern string Setting_1 = "+-- Bars Back between Peaks and Troughs --+";
extern int    periods=96;
extern string Setting_1a = "+-- Use Hi Lo or Close Prices --+";
extern bool   use_closes = false;
extern int    shift_ahead =0;
extern string Setting_2 = "+-- % change: Reduces by % value  --+";
extern int    percent_range_change=50;
extern string Setting_3 = "+-- Inner Line Fib Levels  --+";
extern double fib1 = 0.236;
extern double fib2 = 0.382;
extern string Setting_4 = "+-- Fib Line Style 0 to 4  --+";
extern string Setting_4a = "+ 0=Solid, 1=Dash, 2=DashDot, 3=DashDotDot +";
extern int    line_style = 2;
extern string Setting_5 = "+-- Centre Line Style 0 to 4  --+";
extern int    mean_line_style = 0;
extern string Setting_6 = "+-- See Line Prices  --+";
extern bool   see_all_prices = false;
extern bool   see_main_prices = true;
extern int    label_size = 2;
extern string Setting_7 = "+-- Sound Alert  --+";
extern bool   alerts_on =true;
extern bool   alert_mean_line_cross = true;
extern bool   alert_channel_line_cross = true;
//---- indicator buffers
double     upper[];
double     lower[];
double     inupper[];
double     inlower[];
double     in2upper[];
double     in2lower[];
double     mean[];

int init()
  {
 
//---- indicator buffers 
   SetIndexBuffer(0,upper);
      SetIndexStyle(0,DRAW_LINE,line_style);
         SetIndexLabel(0,"Upper");
            SetIndexShift(0,shift_ahead);
   SetIndexBuffer(1,lower);
      SetIndexStyle(1,DRAW_LINE,line_style);
         SetIndexLabel(1,"Lower");
            SetIndexShift(1,shift_ahead);
   SetIndexBuffer(2,inupper);
      SetIndexStyle(2,DRAW_LINE,line_style);
         SetIndexLabel(2,"Upper Less"+DoubleToStr(fib1*1000,0));
            SetIndexShift(2,shift_ahead);
   SetIndexBuffer(3,inlower);
      SetIndexStyle(3,DRAW_LINE,line_style);
         SetIndexLabel(3,"Lower Plus"+DoubleToStr(fib1*1000,0));
            SetIndexShift(3,shift_ahead);  
   SetIndexBuffer(4,in2upper);
      SetIndexStyle(4,DRAW_LINE,line_style);
         SetIndexLabel(4,"Upper Less"+DoubleToStr(fib2*1000,0));
            SetIndexShift(4,shift_ahead);
   SetIndexBuffer(5,in2lower); 
      SetIndexStyle(5,DRAW_LINE,line_style);
         SetIndexLabel(5,"Lower Plus"+DoubleToStr(fib2*1000,0));
            SetIndexShift(5,shift_ahead);
   SetIndexBuffer(6,mean); 
      SetIndexStyle(6,DRAW_LINE,mean_line_style);
         SetIndexLabel(6,"Mean");
            SetIndexShift(6,shift_ahead);

//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Brooky Fibbed Donchian("+periods+")");

   return(0);
  }
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete("Price1");
   ObjectDelete("Price2");
   ObjectDelete("Price3");
   ObjectDelete("Price4");
   ObjectDelete("Price5"); 
   ObjectDelete("Price6"); 
   ObjectDelete("Price7"); 
//----
   return(0);
  }
//+------------------------------------------------------------------+ 
  
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   double up,lo,hilo,newup,newlo,newhilo,hnow,lnow;
//---- calculate values
   for(int i=0; i<limit; i++) 
   {
      if(use_closes)
      {
      up=iClose(NULL,0,iHighest(NULL,0,MODE_HIGH,periods,i));
      lo=iClose(NULL,0,iLowest(NULL,0,MODE_LOW,periods,i));
      }else
      {
      up=iHigh(NULL,0,iHighest(NULL,0,MODE_HIGH,periods,i));
      lo=iLow(NULL,0,iLowest(NULL,0,MODE_LOW,periods,i));
      }
      
      hilo = (up-lo)*(100-percent_range_change)/100;
      
      newup = (up-((up-lo)/2))+(hilo/2);
      newlo = (lo+(up-lo)/2)-(hilo/2);
      
      newhilo = (newup-newlo)*(100-percent_range_change)/100;
      
      upper[i]=newup;
      lower[i]=newlo;      
      
      inupper[i]=newup-(newhilo*fib1);
      inlower[i]=newlo+(newhilo*fib1);
      in2upper[i]=newup-(newhilo*fib2);
      in2lower[i]=newlo+(newhilo*fib2);    
      mean[i]=(newup+newlo)/2;
      
      if(see_all_prices)
      {
       DrawPrice1(Time[i-1],upper[i], indicator_color1);
       DrawPrice2(Time[i-1],lower[i], indicator_color2);
       DrawPrice3(Time[i-1],inupper[i], indicator_color3);
       DrawPrice4(Time[i-1],inlower[i], indicator_color4);
       DrawPrice5(Time[i-1],in2upper[i], indicator_color5);
       DrawPrice6(Time[i-1],in2lower[i], indicator_color6);
       DrawPrice7(Time[i-1],mean[i], indicator_color7);
       WindowRedraw();
      }
      
      if(see_main_prices)
      {
       DrawPrice1(Time[i-1],upper[i], indicator_color1);
       DrawPrice2(Time[i-1],lower[i], indicator_color2);
       DrawPrice7(Time[i-1],mean[i], indicator_color7);
       WindowRedraw();
      } 
      //--alerts

      if(alerts_on)
         {
         datetime sigtime = iTime(NULL,0,i); 
         int sighr = TimeHour(sigtime);
         int sigmin = TimeMinute(sigtime);
         int sigday = TimeDay(sigtime);
         int sigmth = TimeMonth(sigtime);
         int sigyr = TimeYear(sigtime); 
         string tdisplay = sigday+"/"+sigmth+"/"+sigyr+": "+sighr+":"+sigmin;
         
         
         string tf = "Tf:"+Period();
         if(Period()==1)tf = "M1";
         if(Period()==5)tf = "M5";
         if(Period()==15)tf = "M15";
         if(Period()==30)tf = "M30";
         if(Period()==60)tf = "H1";
         if(Period()==240)tf = "H4";
         if(Period()==1440)tf = "Daily";
         if(Period()==10080)tf = "Weekly";
         if(Period()==43200)tf = "Monthly";
         
         string prealertcom = "( "+Symbol()+" )"+tf+"( "+tdisplay+" )";
         
         hnow= iHigh(NULL,0,i);
         lnow= iLow(NULL,0,i);
            
            if(alert_mean_line_cross)
             {
               string mcom = "Mean Cross";
               if(hnow>mean[i] && lnow<mean[i])
                {
                  int alertname = 1;
                  AlertOnce (mcom+prealertcom,alertname);
                }
              }
            if(alert_channel_line_cross)
            {
             string ucom = "Upper Cross";
             string lcom = "Lower Cross";
             
             if(hnow>upper[i] && lnow<upper[i])
             {
               int alertname2 = 2;
               AlertOnce (ucom+prealertcom,alertname2);
             } 
                
             if(hnow>lower[i] && lnow<lower[i])
             {
               int alertname3 = 3;
               AlertOnce (lcom+prealertcom,alertname3);
             }  
            }
        
         }
      }
  //---- done
     return(0);
     }
  //----------------------------------------------------------------------+
  

      
  void DrawPrice1(datetime x1,  double y1, color PriceColor1) 
                        
      {
      string label1 = "Price1";
      ObjectDelete(label1);
      ObjectCreate(label1,OBJ_ARROW, 0, x1,y1);
      ObjectSet(label1, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(label1, OBJPROP_ARROWCODE, 6);
      ObjectSet(label1, OBJPROP_COLOR,PriceColor1);
      ObjectSet(label1, OBJPROP_WIDTH,label_size);
      }     
      
      
      
  void DrawPrice2(datetime x2,  double y2, color PriceColor2) 
                        
      {
      string label2 = "Price2";
      ObjectDelete(label2);
      ObjectCreate(label2,OBJ_ARROW, 0, x2,y2);
      ObjectSet(label2, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(label2, OBJPROP_ARROWCODE, 6);
      ObjectSet(label2, OBJPROP_COLOR,PriceColor2);
      ObjectSet(label2, OBJPROP_WIDTH,label_size); 
      }
  void DrawPrice3(datetime x3,  double y3, color PriceColor3) 
                        
      {
      string label3 = "Price3";
      ObjectDelete(label3);
      ObjectCreate(label3,OBJ_ARROW, 0, x3,y3);
      ObjectSet(label3, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(label3, OBJPROP_ARROWCODE, 6);
      ObjectSet(label3, OBJPROP_COLOR,PriceColor3);
      ObjectSet(label3, OBJPROP_WIDTH,label_size); 
      }
  void DrawPrice4(datetime x4,  double y4, color PriceColor4) 
                        
      {
      string label4 = "Price4";
      ObjectDelete(label4);
      ObjectCreate(label4,OBJ_ARROW, 0, x4,y4);
      ObjectSet(label4, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(label4, OBJPROP_ARROWCODE, 6);
      ObjectSet(label4, OBJPROP_COLOR,PriceColor4);
      ObjectSet(label4, OBJPROP_WIDTH,label_size); 
      } 
  void DrawPrice5(datetime x5,  double y5, color PriceColor5) 
                        
      {
      string label5 = "Price5";
      ObjectDelete(label5);
      ObjectCreate(label5,OBJ_ARROW, 0, x5,y5);
      ObjectSet(label5, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(label5, OBJPROP_ARROWCODE, 6);
      ObjectSet(label5, OBJPROP_COLOR,PriceColor5);
      ObjectSet(label5, OBJPROP_WIDTH,label_size); 
      } 
  void DrawPrice6(datetime x6,  double y6, color PriceColor6) 
                        
      {
      string label6 = "Price6";
      ObjectDelete(label6);
      ObjectCreate(label6,OBJ_ARROW, 0, x6,y6);
      ObjectSet(label6, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(label6, OBJPROP_ARROWCODE, 6);
      ObjectSet(label6, OBJPROP_COLOR,PriceColor6); 
      ObjectSet(label6, OBJPROP_WIDTH,label_size);
      } 
  void DrawPrice7(datetime x7,  double y7, color PriceColor7) 
                        
      {
      string label7 = "Price7";
      ObjectDelete(label7);
      ObjectCreate(label7,OBJ_ARROW, 0, x7,y7);
      ObjectSet(label7, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(label7, OBJPROP_ARROWCODE, 6);
      ObjectSet(label7, OBJPROP_COLOR,PriceColor7);
      ObjectSet(label7, OBJPROP_WIDTH,label_size);
      }
      
//------------------------------------------------------------+
bool AlertOnce(string alert_msg, int ref)
{  
   int barcheck = Bars;
   static int LastAlert_1 = 0;
   static int LastAlert_2 = 0;
   static int LastAlert_3 = 0;
      
   switch(ref)
   {
      case 1:
         if( LastAlert_1 == 0 || LastAlert_1 < barcheck )
         {
            Alert(alert_msg);
            LastAlert_1 = barcheck;
            return (1);
         }
      break;
      case 2:
         if( LastAlert_2 == 0 || LastAlert_2 < barcheck )
         {
            Alert(alert_msg);
            LastAlert_2 = barcheck;
            return (1);
         }
      break;
      case 3:
         if( LastAlert_3 == 0 || LastAlert_3 < barcheck )
         {
            Alert(alert_msg);
            LastAlert_3 = barcheck;
            return (1);
         }
      break;


   }
}

