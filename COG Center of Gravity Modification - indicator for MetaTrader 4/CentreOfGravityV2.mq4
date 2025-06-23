//+------------------------------------------------------------------+
//|                                         Center of Gravity V2.mq4 |
//| Original Code from NG3110@latchess.com                           |                                    
//| Linuxser 2007 for TSD    http://www.forex-tsd.com/               |
//| Brooky-Indicators.com mod 2011                                   |
//+------------------------------------------------------------------+
#property  copyright "ANG3110@latchess.com"
//---------ang_PR (Din)--------------------
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 RoyalBlue
#property indicator_color2 Red
#property indicator_color3 LimeGreen
#property indicator_color4 Red
#property indicator_color5 LimeGreen

#property indicator_color6 Silver
#property indicator_color7 Silver

#property indicator_style1 2
#property indicator_style2 0
#property indicator_style3 0
#property indicator_style4 0
#property indicator_style5 0
#property indicator_style6 0
#property indicator_style7 0
#property indicator_style8 0

//-----------------------------------

extern string OrigCode = "NG3110 AT latchess.com";
extern string Mod1Code = "Linuxser AT www.forex-tsd.com";
extern string Mod2Code = "Brooky AT Brooky-Indicators.com";
extern bool See_Prices = true;
extern int bars_back=192;
extern int m = 5;
extern int i = 0;
extern double kstd=0.618;
extern double kstd_internal=0.8;
extern int sName=1102;
//-----------------------
double fx[],sqh[],sql[],stdh[],stdl[],stdh2[],stdl2[];
double ai[10,10],b[10],x[10],sx[20];
double sum;
int    ip,p,n,f;
double qq,mm,tt;
int    ii,jj,kk,ll,nn;
double sq,std;

string p1name="",p2name="",p3name="",p4name="",p5name="",p6name="",p7name="",p8name="";

bool ready_flag=false;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Prepare_Object()
  {
   if(ready_flag==true) return;

   p=MathRound(bars_back);
   nn=m+1;
   ObjectCreate("pr"+sName,22,0,Time[p],fx[p]);
   ObjectSet("pr"+sName,14,159);

   ready_flag=true;
  }
//*******************************************
int init()
  {
   IndicatorShortName("Center of Gravity");
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,fx);
   SetIndexBuffer(1,sqh);
   SetIndexBuffer(2,sql);
   SetIndexBuffer(3,stdh);
   SetIndexBuffer(4,stdl);
   SetIndexBuffer(5,stdh2);
   SetIndexBuffer(6,stdl2);

   return(0);
  }
//----------------------------------------------------------
int deinit()
  {
   ObjectDelete("pr"+sName);
   ObjectDelete("p1n");
   ObjectDelete("p2n");
   ObjectDelete("p3n");
   ObjectDelete("p4n");
   ObjectDelete("p5n");
   ObjectDelete("p6n");
   ObjectDelete("p7n");
   ObjectDelete("p8n");
   return(0);
  }
//**********************************************************************************************
int start()
  {
   if(ready_flag==false) Prepare_Object();

   int mi;
//-------------------------------------------------------------------------------------------
   ip= iBarShift(Symbol(),Period(),ObjectGet("pr"+sName,OBJPROP_TIME1));
   p = bars_back;
   sx[1]=p+1;
   SetIndexDrawBegin(0,Bars-p-1);
   SetIndexDrawBegin(1,Bars-p-1);
   SetIndexDrawBegin(2,Bars-p-1);
   SetIndexDrawBegin(3,Bars-p-1);
   SetIndexDrawBegin(4,Bars-p-1);
   SetIndexDrawBegin(5,Bars-p-1);
   SetIndexDrawBegin(6,Bars-p-1);
//----------------------sx-------------------------------------------------------------------
   for(mi=1; mi<=nn*2-2; mi++)
     {
      sum=0;
      for(n=i; n<=i+p; n++)
        {
         sum+=MathPow(n,mi);
        }
      sx[mi+1]=sum;
     }
//----------------------syx-----------
   for(mi=1; mi<=nn; mi++)
     {
      sum=0.00000;
      for(n=i; n<=i+p; n++)
        {
         if(mi==1)
            sum+=Close[n];
         else
            sum+=Close[n] *MathPow(n,mi-1);
        }
      b[mi]=sum;
     }
//===============Matrix=======================================================================================================
   for(jj=1; jj<=nn; jj++)
     {
      for(ii=1; ii<=nn; ii++)
        {
         kk=ii+jj-1;
         ai[ii,jj]=sx[kk];
        }
     }
//===============Gauss========================================================================================================
   for(kk=1; kk<=nn-1; kk++)
     {
      ll=0; mm=0;
      for(ii=kk; ii<=nn; ii++)
        {
         if(MathAbs(ai[ii,kk])>mm)
           {
            mm = MathAbs(ai[ii, kk]);
            ll = ii;
           }
        }
      if(ll==0)
         return(0);

      if(ll!=kk)
        {
         for(jj=1; jj<=nn; jj++)
           {
            tt=ai[kk,jj];
            ai[kk, jj] = ai[ll, jj];
            ai[ll, jj] = tt;
           }
         tt=b[kk]; b[kk]=b[ll]; b[ll]=tt;
        }
      for(ii=kk+1; ii<=nn; ii++)
        {
         qq=ai[ii,kk]/ai[kk,kk];
         for(jj=1; jj<=nn; jj++)
           {
            if(jj==kk)
               ai[ii,jj]=0;
            else
               ai[ii,jj]=ai[ii,jj]-qq*ai[kk,jj];
           }
         b[ii]=b[ii]-qq*b[kk];
        }
     }
   x[nn]=b[nn]/ai[nn,nn];
   for(ii=nn-1; ii>=1; ii--)
     {
      tt=0;
      for(jj=1; jj<=nn-ii; jj++)
        {
         tt=tt+ai[ii,ii+jj] *x[ii+jj];
         x[ii]=(1/ai[ii,ii]) *(b[ii]-tt);
        }
     }
//===========================================================================================================================
   for(n=i; n<=i+p; n++)
     {
      sum=0;
      for(kk=1; kk<=m; kk++)
        {
         sum+=x[kk+1] *MathPow(n,kk);
        }
      fx[n]=x[1]+sum;
     }
//-----------------------------------Std-----------------------------------------------------------------------------------
   sq=0.0;
   for(n=i; n<=i+p; n++)
     {
      sq+=MathPow(Close[n]-fx[n],2);
     }
   sq=MathSqrt(sq/(p+1))*kstd;
   std=iStdDev(NULL,0,p,MODE_SMA,0,PRICE_CLOSE,i)*kstd;
   for(n=i; n<=i+p; n++)
     {
      stdh[n] = fx[n] + std;
      stdl[n] = fx[n] - std;

      sqh[n] = fx[n] + sq;
      sql[n] = fx[n] - sq;


      stdh2[n] = fx[n] + (kstd_internal*std);
      stdl2[n] = fx[n] - (kstd_internal*std);

      if(See_Prices)
        {
         p1name="p1n";
         ObjectDelete(p1name);
         ObjectCreate(p1name,OBJ_ARROW,0,Time[0],stdh[0]);
         ObjectSet(p1name,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(p1name,OBJPROP_ARROWCODE,6);
         ObjectSet(p1name,OBJPROP_COLOR,Red);

         p2name="p2n";
         ObjectDelete(p2name);
         ObjectCreate(p2name,OBJ_ARROW,0,Time[0],sqh[0]);
         ObjectSet(p2name,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(p2name,OBJPROP_ARROWCODE,6);
         ObjectSet(p2name,OBJPROP_COLOR,Red);

         p3name="p3n";
         ObjectDelete(p3name);
         ObjectCreate(p3name,OBJ_ARROW,0,Time[0],stdh2[0]);
         ObjectSet(p3name,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(p3name,OBJPROP_ARROWCODE,6);
         ObjectSet(p3name,OBJPROP_COLOR,Silver);

         p4name="p4n";
         ObjectDelete(p4name);
         ObjectCreate(p4name,OBJ_ARROW,0,Time[0],fx[0]);
         ObjectSet(p4name,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(p4name,OBJPROP_ARROWCODE,6);
         ObjectSet(p4name,OBJPROP_COLOR,Blue);

         p5name="p5n";
         ObjectDelete(p5name);
         ObjectCreate(p5name,OBJ_ARROW,0,Time[0],stdl2[0]);
         ObjectSet(p5name,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(p5name,OBJPROP_ARROWCODE,6);
         ObjectSet(p5name,OBJPROP_COLOR,Silver);

         p6name="p6n";
         ObjectDelete(p6name);
         ObjectCreate(p6name,OBJ_ARROW,0,Time[0],sql[0]);
         ObjectSet(p6name,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(p6name,OBJPROP_ARROWCODE,6);
         ObjectSet(p6name,OBJPROP_COLOR,LimeGreen);


         p7name="p7n";
         ObjectDelete(p7name);
         ObjectCreate(p7name,OBJ_ARROW,0,Time[0],fx[0]);
         ObjectSet(p7name,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(p7name,OBJPROP_ARROWCODE,6);
         ObjectSet(p7name,OBJPROP_COLOR,LimeGreen);

         p8name="p8n";
         ObjectDelete(p8name);
         ObjectCreate(p8name,OBJ_ARROW,0,Time[0],stdl[0]);
         ObjectSet(p8name,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(p8name,OBJPROP_ARROWCODE,6);
         ObjectSet(p8name,OBJPROP_COLOR,LimeGreen);
        }
     }
//-------------------------------------------------------------------------------
   ObjectMove("pr"+sName,0,Time[p],fx[p]);
//----------------------------------------------------------------------------------------------------------------------------
   return(0);
  }
//==========================================================================================================================   
