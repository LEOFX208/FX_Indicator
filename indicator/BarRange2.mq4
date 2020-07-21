//+------------------------------------------------------------------+
//|                                                  Daily Range.mq4 |
//|                                        Copyright © 2008, LEGRUPO |
//|                                           http://www.legrupo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, LEGRUPO"
#property link      "http://www.legrupo.com"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red

double BufferRange[];
   string PatternText[5000];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//   IndicatorBuffers(1);
   SetIndexStyle(0, DRAW_ARROW, 0, 1);
   SetIndexArrow(0, 172);
   SetIndexBuffer(0,BufferRange);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectsDeleteAll();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   double bar_range;
//----
   if (counted_bars < 0) {
      return(-1);
   }
   
   if (counted_bars > 0) {
      counted_bars--;
   }
   int pos = Bars-counted_bars;
//   string PatternText[5000];
    for(int j = 0; j < Bars; j++) 
     { 
       PatternText[j] = "pattern-" + j;
     }
   while (pos>=0) {
      bar_range = (High[pos] - Low[pos]);
      if (Digits < 4) bar_range = bar_range * 100; else bar_range = bar_range * 10000;
      ObjectCreate(PatternText[pos], OBJ_TEXT, 0, Time[pos], Low[pos]);
      ObjectSet(PatternText[pos], OBJPROP_YDISTANCE, 200);
      ObjectSetText(PatternText[pos], DoubleToStr(bar_range, 0), 10, "Verdana", Red);
      
      BufferRange[pos] = bar_range;
      pos--;
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+