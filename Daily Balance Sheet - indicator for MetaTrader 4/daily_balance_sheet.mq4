//+------------------------------------------------------------------+
//|                                          daily_balance_sheet.mq4 |
//|                                                            Kabul |
//|                                               panji_xx@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Kabul"
#property link      "panji_xx@yahoo.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//---
extern int Tahun=2015;
extern int Bulan=4;
extern int x_axis=10;
extern int y_axis=30;
extern color BackGrnCol=clrAqua;
extern color SaturdayCol=clrYellow;
extern color SundayCol=clrCrimson;
extern color LineColor=clrBlack;
extern color TextColor=clrBlack;
//---
string txt[36][5];
int week[5],weekday,addweek;
double profweek[6],lotweek[6],losweek[6];
string v[36];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   EventSetTimer(1);
   string s;
   datetime t;
//---
   s=IntegerToString(Tahun)+"."+IntegerToString(Bulan)+".01";
   t=StringToTime(s);
   weekday=TimeDayOfWeek(t);
   addweek=6-weekday;
   week[0]=1+addweek;
   week[1]=week[0]+7;
   week[2]=week[1]+7;
   week[3]=week[2]+7;
   week[4]=week[3]+7;
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//---
   for(int hh=1;hh<32;hh++)
     {
      v[hh]=IntegerToString(hh);
     }
//---
   double ttllot[32],prof[32],loss[32],akum[32],total,jumlot,prhrini,lshrini,akumhrini;
   int hist,bulan,j,i;
   hist=OrdersHistoryTotal();
   total=0.0;
   jumlot=0.0;
   ArrayFill(ttllot,0,32,0.0);
   ArrayFill(prof,0,32,0.0);
   ArrayFill(loss,0,32,0.0);
   ArrayFill(akum,0,32,0.0);
   prhrini=0.0;
   lshrini=0.0;
   akumhrini=0.0;
//---
   for(j=0;j<hist;j++)
     {
      if(OrderSelect(j,SELECT_BY_POS,MODE_HISTORY))
        {
         if((TimeYear(OrderCloseTime())==Tahun) && (TimeMonth(OrderCloseTime())==Bulan) && ((OrderType()==OP_BUY) || (OrderType()==OP_SELL)))
           {
            bulan=TimeDay(OrderCloseTime());
            if(OrderProfit()>0)
              {
               prof[bulan]=prof[bulan]+OrderProfit()+OrderSwap()+OrderCommission();
               ttllot[bulan]=ttllot[bulan]+OrderLots();
               if((TimeDay(OrderCloseTime())==TimeDay(TimeCurrent())) && 
                  (TimeMonth(OrderCloseTime())==TimeMonth(TimeCurrent())))
                 {prhrini=prhrini+OrderProfit();}
              }
            else
              {
               //---
               loss[bulan]=loss[bulan]+OrderProfit()+OrderSwap()+OrderCommission();
               ttllot[bulan]=ttllot[bulan]+OrderLots();

               if((TimeDay(OrderCloseTime())==TimeDay(TimeCurrent())) && 
                  (TimeMonth(OrderCloseTime())==TimeMonth(TimeCurrent())))
                 {lshrini=lshrini+OrderProfit();}
              }
            akum[bulan]=prof[bulan]+loss[bulan];
            akumhrini=prhrini+lshrini;
           }
        }

     }
//---
   txt[0][0]="Tanggal";txt[0][1]="Total Lot";txt[0][2]="Profit";txt[0][3]="Loss";txt[0][4]="Akumulasi";
//---
   for(int bbh=0;bbh<5;bbh++)
     {
      if(week[bbh]>31) {week[bbh]=32;}
      profweek[bbh]=0;
      lotweek[bbh]=0;
      losweek[bbh]=0;
      for(int jjl=week[bbh]-1;jjl>week[bbh]-6;jjl--)
        {
         if(jjl<1) {break;}
         profweek[bbh]=profweek[bbh]+prof[jjl];
         lotweek[bbh]=lotweek[bbh]+ttllot[jjl];
         losweek[bbh]=losweek[bbh]+loss[jjl];
        }

     }
//---
   for(i=1;i<32;i++)
     {

      for(j=0;j<5;j++)
        {
         if(j==0) {txt[i,j]=v[i];}
         if(j==1) {txt[i,j]=DoubleToString(ttllot[i],2);jumlot=jumlot+ttllot[i];}
         if(j==2) {txt[i,j]=DoubleToString(prof[i],2);}
         if(j==3) {txt[i,j]=DoubleToString(loss[i],2);}
         if(j==4) {txt[i,j]=DoubleToString(akum[i],2);total=total+akum[i];}
         if(txt[i,j]=="0.00"){txt[i,j]="";}
        }
      //---
      for(int bbh=0;bbh<5;bbh++)
        {
         if(week[bbh]==StringToInteger(v[i]))
           {
            txt[i,0]=v[i];
            txt[i,1]=DoubleToString(lotweek[bbh],2);if(txt[i,1]=="0.00"){txt[i,1]="";}
            txt[i,2]=DoubleToString(profweek[bbh],2);if(txt[i,2]=="0.00"){txt[i,2]="";}
            txt[i,3]=DoubleToString(losweek[bbh],2);if(txt[i,3]=="0.00"){txt[i,3]="";}
            txt[i,4]=DoubleToString(profweek[bbh]+losweek[bbh],2);if(txt[i,4]=="0.00"){txt[i,4]="";}
           }
        }

     }
//--- isi line 13    
   txt[32,1]=DoubleToString(lotweek[4],2);if(txt[i,1]=="0.00"){txt[32,1]="";}
   txt[32,2]=DoubleToString(profweek[4],2);if(txt[i,2]=="0.00"){txt[32,2]="";}
   txt[32,3]=DoubleToString(losweek[4],2);if(txt[i,3]=="0.00"){txt[32,3]="";}
   txt[32,4]=DoubleToString(profweek[4]+losweek[4],2);if(txt[i,4]=="0.00"){txt[32,4]="";}
//---
   txt[34][0]="Total";txt[34][1]=DoubleToString(jumlot,2);txt[34][2]="";txt[34][3]="";txt[34][4]=DoubleToString(total,2);
   txt[35][0]="Hari ini";txt[35][1]="";txt[35][2]=DoubleToString(prhrini,2);txt[35][3]=DoubleToString(lshrini,2);txt[35][4]=DoubleToString(akumhrini,2);
//---
   return(0);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrBlack);
   ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrBlack);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrBlack);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrBlack);
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrBlack);
   ChartSetInteger(0,CHART_COLOR_CHART_LINE,clrBlack);
   ChartSetInteger(0,CHART_COLOR_CHART_UP,clrBlack);
   ChartSetInteger(0,CHART_COLOR_ASK,clrBlack);
   ChartSetInteger(0,CHART_COLOR_BID,clrBlack);
   ChartSetInteger(0,CHART_COLOR_GRID,clrBlack);
   ChartSetInteger(0,CHART_COLOR_STOP_LEVEL,clrBlack);
   ChartSetInteger(0,CHART_COLOR_VOLUME,clrBlack);
   ChartSetInteger(0,CHART_SHOW_GRID,0,0);
   ChartSetInteger(0,CHART_SHOW_LAST_LINE,0,0);
   ChartSetInteger(0,CHART_SHOW_ASK_LINE,0,0);
   ChartSetInteger(0,CHART_SHOW_BID_LINE,0,0);
   ChartSetInteger(0,CHART_SHOW_OHLC,0,0);
   ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,0,0);
   ChartSetInteger(0,CHART_SHOW_PERIOD_SEP,0,0);
   ChartSetInteger(0,CHART_SHOW_VOLUMES,0,0);
   ObjectsDeleteAll();
   for(int hh=0;hh<3;hh++)
     {
      for(int i=0;i<12;i++)
        {
         for(int j=0;j<5;j++)
           {
            //---
            SetPanel("Panel"+IntegerToString((hh*12)+i)+IntegerToString(j),0,(j*50)+(hh*300)+x_axis,(i*25)+y_axis,65,25,BackGrnCol,LineColor,1);
            //---
            if((StringToInteger(v[(hh*12)+i])==week[0]) || (StringToInteger(v[(hh*12)+i])==week[1]) || (StringToInteger(v[(hh*12)+i])==week[2]) || (StringToInteger(v[(hh*12)+i])==week[3]) || (StringToInteger(v[(hh*12)+i])==week[4]) || ((i==8) && (hh==2)))
              {
               SetPanel("Panel"+IntegerToString((hh*12)+i)+IntegerToString(j),0,(j*50)+(hh*300)+x_axis,(i*25)+y_axis,65,25,SaturdayCol,LineColor,1);
              }
            //---
            if((StringToInteger(v[(hh*12)+i])==week[0]+1) || (StringToInteger(v[(hh*12)+i])==week[1]+1) || (StringToInteger(v[(hh*12)+i])==week[2]+1) || (StringToInteger(v[(hh*12)+i])==week[3]+1) || (StringToInteger(v[(hh*12)+i])==week[4]+1))
              {
               SetPanel("Panel"+IntegerToString((hh*12)+i)+IntegerToString(j),0,(j*50)+(hh*300)+x_axis,(i*25)+y_axis,65,25,SundayCol,LineColor,1);
              }
           }
        }
     }
//---
   for(int hh=0;hh<3;hh++)
     {
      for(int i=0;i<12;i++)
        {
         for(int j=0;j<5;j++)
           {
            SetText("Text"+IntegerToString((hh*12)+i)+IntegerToString(j),txt[(hh*12)+i][j],(j*50)+(hh*300)+x_axis+2,(i*25)+y_axis+2,TextColor,8);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetText(string name,string text,int x,int y,color colour,int fontsize=12)
  {
   if(ObjectCreate(0,name,OBJ_LABEL,0,0,0))
     {
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(0,name,OBJPROP_COLOR,colour);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,fontsize);
      ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
     }
   ObjectSetString(0,name,OBJPROP_TEXT,text);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetPanel(string name,int sub_window,int x,int y,int width,int height,color bg_color,color border_clr,int border_width)
  {
   if(ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,sub_window,0,0))
     {
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,height);
      ObjectSetInteger(0,name,OBJPROP_COLOR,border_clr);
      ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
      ObjectSetInteger(0,name,OBJPROP_WIDTH,border_width);
      ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);
      ObjectSetInteger(0,name,OBJPROP_BACK,false);
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
      ObjectSetInteger(0,name,OBJPROP_SELECTED,0);
      ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
      ObjectSetInteger(0,name,OBJPROP_ZORDER,0);
     }
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,bg_color);
  }
//+------------------------------------------------------------------+
