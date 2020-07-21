//+------------------------------------------------------------------+
//|                                         MACD_ColorHist_Alert.mq4 |
//|                                    Copyright © 2006, Robert Hill |
//|                                                                  |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2006, Robert Hill"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 4
#property  indicator_color1  Aqua
#property  indicator_color2  Red
#property  indicator_color3  Green
#property  indicator_color4  Red

//---- indicator parameters

extern int FastEMA=12;
extern int SlowEMA=26;
extern int SignalSMA=9;
//---- indicator buffers
double     ind_buffer1[];
double     ind_buffer2[];
double HistogramBufferUp[];
double HistogramBufferDown[];
int flagval1 = 0;
int flagval2 = 0;
//---- variables

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
//   IndicatorBuffers(3);
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+1);
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID);
   SetIndexBuffer(0,ind_buffer1);
   SetIndexDrawBegin(0,SlowEMA);
   SetIndexStyle(1,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(1,ind_buffer2);
   SetIndexDrawBegin(1,SignalSMA);
   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_SOLID);
   SetIndexBuffer(2,HistogramBufferUp);
   SetIndexStyle(3,DRAW_HISTOGRAM,STYLE_SOLID);
   SetIndexBuffer(3,HistogramBufferDown);
//   SetIndexDrawBegin(2,SlowEMA + SignalSMA);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("MACD-EMA("+FastEMA+","+SlowEMA+","+SignalSMA+")");
   SetIndexLabel(0,"MACD");
   SetIndexLabel(1,"Signal");
   SetIndexLabel(2,"Histogram");
   
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   double temp;
   
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- macd counted in the 1-st buffer
   for(int i=0; i<limit; i++)
      ind_buffer1[i]=iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i)-iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i);
//---- signal line counted in the 2-nd buffer
   for(i=0; i<limit; i++)
      ind_buffer2[i]=iMAOnArray(ind_buffer1,Bars,SignalSMA,0,MODE_EMA,i);
//      ind_buffer2[i] = alpha*ind_buffer1[i] + alpha_1*ind_buffer2[i+1];

   for(i=0; i<limit; i++)
   {
      HistogramBufferUp[i] = 0;
      HistogramBufferDown[i] = 0;
      temp = ind_buffer1[i] - ind_buffer2[i];
      if (temp >= 0)
        HistogramBufferUp[i] = temp;
      else
        HistogramBufferDown[i] = temp;
   }
      
//---- done
   return(0);
  }