//KurlFX 23/6/09
//+------------------------------------------------------------------+
//| TADX.mq4 |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009,KurlFX"
#define Alvl 35.0
#define Alvl2 30.0
#property  indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 Red
#property indicator_color2 SteelBlue
#property indicator_width1 2
#property indicator_width2 2
#property indicator_color3 Indigo
#property indicator_color4 Indigo
#property indicator_color5 Indigo
#property indicator_width3 1
#property indicator_width4 1
//---- indicator parameters
extern int ADXperiod1 = 10;
extern int ADXperiod2 = 14;
extern int ADXperiod3 = 20;
//--
string Unq="TASSKlT",Label;
int MxP,MnP,MdP;
//---- buffers
double To[];
double Tc[];
double ADX1[];
double ADX2[];
double ADX3[];
double Up[];
double Dn[];
double Ex[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
//---- name for DataWindow and indicator subwindow label
	MxP=MathMax(MathMax(ADXperiod1,ADXperiod2),ADXperiod3);
	MnP=MathMin(MathMin(ADXperiod1,ADXperiod2),ADXperiod3);
	if(MxP==ADXperiod1)MdP=MathMax(ADXperiod2,ADXperiod3);
	else if(MxP==ADXperiod2)MdP=MathMax(ADXperiod1,ADXperiod3);	
	else MdP=MathMax(ADXperiod2,ADXperiod1);
	Label=Unq+"("+MnP+"/"+MdP+"/"+MxP+")";
	IndicatorBuffers(8);
	SetIndexBuffer(0,To);
	SetIndexBuffer(1,Tc);
	SetIndexBuffer(2,Up);
	SetIndexBuffer(3,Dn);
	SetIndexBuffer(4,Ex);
	SetIndexBuffer(5,ADX1);
	SetIndexBuffer(6,ADX2);
	SetIndexBuffer(7,ADX3);
	SetIndexLabel(0,NULL);
	SetIndexLabel(1,NULL);
	SetIndexStyle(0,DRAW_HISTOGRAM);
	SetIndexStyle(1,DRAW_HISTOGRAM);	
	SetIndexLabel(2,"Up");
	SetIndexLabel(3,"Dn");
	SetIndexLabel(4,"end");
	SetIndexStyle(2,DRAW_ARROW);
	SetIndexStyle(3,DRAW_ARROW);
	SetIndexStyle(4,DRAW_LINE);
	SetIndexArrow(2,225);
	SetIndexArrow(3,226);
	Comment(Label);
//---- initialization done
	return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
	Comment("");
	return(0);
}
//+------------------------------------------------------------------+
//| main                                    |
//+------------------------------------------------------------------+
int start()
{
	int cntbar=IndicatorCounted();
	int limit=Bars-cntbar;
	if(cntbar==0)limit-=MxP;
	for(int i=limit-1;i>=0;i--)
	{
		ADX1[i]=iADX(NULL,0,MnP,PRICE_CLOSE,MODE_MAIN,i);
		ADX2[i]=iADX(NULL,0,MdP,PRICE_CLOSE,MODE_MAIN,i);
		ADX3[i]=iADX(NULL,0,MxP,PRICE_CLOSE,MODE_MAIN,i);
	}
	if(cntbar==0)limit--;
	for(i=limit-1; i>=0; i--)
	{
		bool f1=false,f2=false,f3=false;
		To[i]=EMPTY_VALUE;Tc[i]=EMPTY_VALUE;
		Up[i]=EMPTY_VALUE;Dn[i]=EMPTY_VALUE;Ex[i]=EMPTY_VALUE;
		if(ADX1[i+1]<ADX1[i])f1=true;
		if(ADX2[i+1]<ADX2[i])f2=true;
		if(ADX3[i+1]<ADX3[i])f3=true;
		if(f1&&f2&&f3&&ADX1[i]>Alvl&&ADX2[i]>Alvl2)
		{
			double di=iADX(NULL,0,MnP,PRICE_CLOSE,MODE_PLUSDI,i)
						-iADX(NULL,0,MnP,PRICE_CLOSE,MODE_MINUSDI,i);
			double hi=MathMax(Open[i],Close[i]);
			double lo=MathMin(Open[i],Close[i]);
			double op=Open[i];
			if(di>0)
			{
				To[i]=lo;Tc[i]=hi;
				if(To[i+1]==EMPTY_VALUE)Up[i]=op;
			}
			else
			{
				To[i]=hi;Tc[i]=lo;
				if(To[i+1]==EMPTY_VALUE)Dn[i]=op;
			}
		}
		else
		{
			if(To[i+1]!=EMPTY_VALUE)Ex[i]=Close[i+1];
			else Ex[i]=Ex[i+1];
		}
	}
	return(0);
}
//+------------------------------------------------------------------+