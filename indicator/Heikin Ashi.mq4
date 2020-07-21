//+------------------------------------------------------------------+
//|                                                  Heikin Ashi.mq4 |
//|                                                 Copyright © ¡¿—» |
//|                                                                  |
//+------------------------------------------------------------------+
//05-04-05 LGP

#property copyright "Copyright © ¡¿—»"
#property link      ""

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Orange   //haOpen
#property indicator_color2 Blue     //haHigh  
#property indicator_color3 Red      //haLow
#property indicator_color4 Green    //haClose

//---- input parameters
int      i,
         counter;

double   result,
         haOpen,
         haHigh,
         haLow,
         haClose;
         
//---- buffers
double   haOpen_Buffer[600];
double   haHigh_Buffer[600];
double   haLow_Buffer[600];
double   haClose_Buffer[600];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   ArrayInitialize(haOpen_Buffer[600],0.0);
   ArrayInitialize(haHigh_Buffer[600],0.0);
   ArrayInitialize(haLow_Buffer[600],0.0);
   ArrayInitialize(haClose_Buffer[600],0.0);
      
//---- 2 indicator buffers mapping
   SetIndexStyle(0,DRAW_LINE);
   SetIndexArrow(0,250);
   SetIndexBuffer(0,haOpen_Buffer);
   SetIndexEmptyValue(0,0.0);
   
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,159);
   SetIndexBuffer(1,haHigh_Buffer);
   SetIndexEmptyValue(1,0.0);
   
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexArrow(2,159);
   SetIndexBuffer(2,haLow_Buffer);
   SetIndexEmptyValue(2,0.0);
   
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(3,159);
   SetIndexBuffer(3,haClose_Buffer);
   SetIndexEmptyValue(3,0.0);
   
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Heikin Ashi"); 
   SetIndexLabel(0, "haOpen"); 
   SetIndexLabel(1, "haHigh"); 
   SetIndexLabel(2, "haLow"); 
   SetIndexLabel(3, "haClose"); 

//----
   if (Bars<=500) 
      counter=Bars;
   else
      counter=500;


//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//---- TODO: add your code here
// haClose = (O+H+L+C)/4
// haOpen = (haOpen (ÔÂ‰˚‰Û˘ËÈ ·‡) + haClose (ÔÂ‰˚‰Û˘ËÈ ·‡))/2
// haHigh = Maximum(H, haOpen, haClose)
// haLow = Minimum(L, haOpen, haClose)

   for (i=counter;i>=0;i--)
      {
      haClose_Buffer[i]=(Open[i]+High[i]+Low[i]+Close[i])/4;
      if (i==counter)
         haOpen_Buffer[i]=Open[i];
      else
         haOpen_Buffer[i]=(haOpen_Buffer[i+1]+haClose_Buffer[i+1])/2;
      
      result=MathMax(High[i],haOpen_Buffer[i]);
      haHigh_Buffer[i]=MathMax(result,haClose_Buffer[i]);
      
      result=MathMin(Low[i],haOpen_Buffer[i]);
      haLow_Buffer[i]=MathMin(result,haClose_Buffer[i]);

      }
//----
   return(0);
  }
//+------------------------------------------------------------------+

