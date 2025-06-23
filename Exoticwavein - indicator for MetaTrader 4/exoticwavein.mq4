//+------------------------------------------------------------------+
//|                  Copyright © 2005, FX Waves  :)
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, Sprrite&Lemon"
#property link      "wladimir447@yandex.ru"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Blue

//---- input parameters
int              Bar;
extern int       LastBar=0;
extern int       cnttik = 3 ;
double           ExtMapBuffer1[];

// ???????  ????  ?  ??  ?????? N-?  ??? ?????????  ???? ????????? 
int tick = 0 ; 
int init()
  {
  
  
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
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
   string sName="",ss1=" ",ss2=" ";
   int file=0, NumBar=0, shift=0; 
   int Ye=0,Mo=0,Da=0,Ho=0,Mi=0,Se=0,Ti=0; 
   int    counted_bars=IndicatorCounted();
   

   //---- check for possible errors
   if (counted_bars<0) return(-1);

   // ???????  ????   ;
    tick++; 
    if  ( tick <= cnttik  ) 
      {
        Print(" Tick  =  ", tick);
        Comment( tick ,"/", cnttik ," |  " , Bars);
        // ????? ????  ! -  ????????? 
        return(0) ; 
       }
    else
    { 
       tick =  0 ;
       // ??????? ??????????? ???? 
       //int rfile = FileOpen("sprrite.csv",FILE_CSV|FILE_WRITE,",");
       //FileWrite(rfile,"yes");
       //FileClose(rfile); 
       
    }   
       

    //int  filesh = FileOpen("zag.csv",FILE_CSV|FILE_READ);
   // string sh = FileReadString(filesh);
  //  FileClose( filesh ); 

//---- 
 if ( 1 == 1)  
	{
     //  ???
     if (Period()==10080) sName="monthly"+"\\"+Symbol()+Period()+".csv";
     if (Period()==43200) sName="weekly"+"\\"+Symbol()+Period()+".csv";
     if (Period()==1440) sName="daily"+"\\"+Symbol()+Period()+".csv";
     if (Period()==240) sName="4_hour"+"\\"+Symbol()+Period()+".csv";
     if (Period()==60) sName="1_hour"+"\\"+Symbol()+Period()+".csv";
     if (Period()==30) sName="half_hour"+"\\"+Symbol()+Period()+".csv";
     if (Period()==15) sName="quarter_hour"+"\\"+Symbol()+Period()+".csv";
     if (Period()==5) sName="5_min"+"\\"+Symbol()+Period()+".csv";
     if (Period()==1) sName="1_min"+"\\"+Symbol()+Period()+".csv";

     // ??????? ?????????? 
     FileDelete(sName);
     file =FileOpen(sName,FILE_CSV|FILE_WRITE,",");


    // FileWrite(file,sh);
 
    shift=Bars+LastBar-1;
     while(shift>=0)
    
     {	
				Ti=Time[shift]; 
				Ye=TimeYear(Ti);
				Mo=TimeMonth(Ti);
				Da=TimeDay(Ti);
	
				Ho=TimeHour(Ti);
				Mi=TimeMinute(Ti);
				if ( Ho == 0 && Mi == 0  ) Mi = 1 ;
				Se=TimeSeconds(Ti);
				ss1=Ye;
				if (Mo<10) ss1=ss1+"0"+Mo; else ss1=ss1+Mo;
				if (Da<10) ss1=ss1+"0"+Da; else ss1=ss1+Da; 
				if (Ho<10) ss2="0"+Ho; else ss2=Ho;
				if (Mi<10) ss2=ss2+"0"+Mi; else ss2=ss2+Mi;
            
       FileWrite(file,ss1,ss2,Open[shift],High[shift],Low[shift],Close[shift],Volume[shift]); 
     shift--;
     }   
     Comment( "  Save of "+ss1+" "+ss2+" is ok" ,  "  === " , Bars);
     
     NumBar=counted_bars;   
     FileClose(file);  
     Print(" ????????  " , Bars);
   }
//----
   return(0);
  }


