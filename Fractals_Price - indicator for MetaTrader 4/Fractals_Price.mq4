//+------------------------------------------------------------------+
//|                                               Fractals_Prise.mq4 |
//|                                                     Yuriy Tokman |
//|                                            yuriytokman@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman"
#property link      "yuriytokman@gmail.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue
//---- input parameters

//---- buffers
double ExtUpFractalsBuffer[];
double ExtDownFractalsBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicator buffers mapping  
    SetIndexBuffer(0,ExtUpFractalsBuffer);
    SetIndexBuffer(1,ExtDownFractalsBuffer);   
//---- drawing settings
    SetIndexStyle(0,DRAW_ARROW);
    SetIndexArrow(0,119);
    SetIndexStyle(1,DRAW_ARROW);
    SetIndexArrow(1,119);
//----
    SetIndexEmptyValue(0,0.0);
    SetIndexEmptyValue(1,0.0);
//---- name for DataWindow
    SetIndexLabel(0,"Fractal Up");
    SetIndexLabel(1,"Fractal Down");
//---- initialization done   
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
//----
   int obj_total=ObjectsTotal();//Возвращает общее число объектов 
   
   for(int i = obj_total - 1; i >= 0; i--)
     {
       string label = ObjectName(i);
       if(StringFind(label, "ArrowCodeFractals")==-1) continue;
       ObjectDelete(label); //Удаление объекта с указанным именем.  
     }     
//----   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    i,nCountedBars;
   bool   bFound;
   double dCurrent;
   datetime tCurrent;
   nCountedBars=IndicatorCounted();
//---- last counted bar will be recounted    
   if(nCountedBars<=2)
      i=Bars-nCountedBars-3;
   if(nCountedBars>2)
     {
      nCountedBars--;
      i=Bars-nCountedBars-1;
     }
//----Up and Down Fractals
   while(i>=2)
     {
      //----Fractals up
      bFound=false;
      dCurrent=High[i];
      tCurrent= Time[i];
      if(dCurrent>High[i+1] && dCurrent>High[i+2] && dCurrent>High[i-1] && dCurrent>High[i-2])
        {
         bFound=true;
         ExtUpFractalsBuffer[i]=dCurrent;
         DrawArrow(tCurrent,dCurrent,5,Red);
        }
      //----6 bars Fractal
      if(!bFound && (Bars-i-1)>=3)
        {
         if(dCurrent==High[i+1] && dCurrent>High[i+2] && dCurrent>High[i+3] &&
            dCurrent>High[i-1] && dCurrent>High[i-2])
           {
            bFound=true;
            ExtUpFractalsBuffer[i]=dCurrent;
           }
        }         
      //----7 bars Fractal
      if(!bFound && (Bars-i-1)>=4)
        {   
         if(dCurrent>=High[i+1] && dCurrent==High[i+2] && dCurrent>High[i+3] && dCurrent>High[i+4] &&
            dCurrent>High[i-1] && dCurrent>High[i-2])
           {
            bFound=true;
            ExtUpFractalsBuffer[i]=dCurrent;
           }
        }  
      //----8 bars Fractal                          
      if(!bFound && (Bars-i-1)>=5)
        {   
         if(dCurrent>=High[i+1] && dCurrent==High[i+2] && dCurrent==High[i+3] && dCurrent>High[i+4] && dCurrent>High[i+5] && 
            dCurrent>High[i-1] && dCurrent>High[i-2])
           {
            bFound=true;
            ExtUpFractalsBuffer[i]=dCurrent;
           }
        } 
      //----9 bars Fractal                                        
      if(!bFound && (Bars-i-1)>=6)
        {   
         if(dCurrent>=High[i+1] && dCurrent==High[i+2] && dCurrent>=High[i+3] && dCurrent==High[i+4] && dCurrent>High[i+5] && 
            dCurrent>High[i+6] && dCurrent>High[i-1] && dCurrent>High[i-2])
           {
            bFound=true;
            ExtUpFractalsBuffer[i]=dCurrent;
           }
        }
//-----------------------------------------------------------------------------------------                                    
      //----Fractals down
      bFound=false;
      dCurrent=Low[i];
      if(dCurrent<Low[i+1] && dCurrent<Low[i+2] && dCurrent<Low[i-1] && dCurrent<Low[i-2])
        {
         bFound=true;
         ExtDownFractalsBuffer[i]=dCurrent;
         DrawArrow(tCurrent,dCurrent,5,DodgerBlue);
        }
      //----6 bars Fractal
      if(!bFound && (Bars-i-1)>=3)
        {
         if(dCurrent==Low[i+1] && dCurrent<Low[i+2] && dCurrent<Low[i+3] &&
            dCurrent<Low[i-1] && dCurrent<Low[i-2])
           {
            bFound=true;
            ExtDownFractalsBuffer[i]=dCurrent;
           }                      
        }         
      //----7 bars Fractal
      if(!bFound && (Bars-i-1)>=4)
        {   
         if(dCurrent<=Low[i+1] && dCurrent==Low[i+2] && dCurrent<Low[i+3] && dCurrent<Low[i+4] &&
            dCurrent<Low[i-1] && dCurrent<Low[i-2])
           {
            bFound=true;
            ExtDownFractalsBuffer[i]=dCurrent;
           }                      
        }  
      //----8 bars Fractal                          
      if(!bFound && (Bars-i-1)>=5)
        {   
         if(dCurrent<=Low[i+1] && dCurrent==Low[i+2] && dCurrent==Low[i+3] && dCurrent<Low[i+4] && dCurrent<Low[i+5] && 
            dCurrent<Low[i-1] && dCurrent<Low[i-2])
           {
            bFound=true;
            ExtDownFractalsBuffer[i]=dCurrent;
           }                      
        } 
      //----9 bars Fractal                                        
      if(!bFound && (Bars-i-1)>=6)
        {   
         if(dCurrent<=Low[i+1] && dCurrent==Low[i+2] && dCurrent<=Low[i+3] && dCurrent==Low[i+4] && dCurrent<Low[i+5] && 
            dCurrent<Low[i+6] && dCurrent<Low[i-1] && dCurrent<Low[i-2])
           {
            bFound=true;
            ExtDownFractalsBuffer[i]=dCurrent;
           }                      
        }                                    
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//-------------------------------------------------------------------------------------------  
void DrawArrow(datetime x1, double vPrice, int vcode, color vcolor)
{//DrawArrow(Time[shift],Close[shift],200,Aqua);
 //if (!Draw_Arrow) return;
 string label = "ArrowCodeFractals - "+DoubleToStr(x1, 0);
 //ObjectDelete(label);
 ObjectCreate(label, OBJ_ARROW, 0, x1, vPrice);
 ObjectSet(label, OBJPROP_ARROWCODE, vcode);
 ObjectSet(label, OBJPROP_COLOR, vcolor);
}