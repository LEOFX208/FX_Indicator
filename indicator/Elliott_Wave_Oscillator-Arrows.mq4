//+------------------------------------------------------------------+
//|                                      Elliott Wave Oscillator.mq4 |
//|                                                tonyc2a@yahoo.com |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "tonyc2a@yahoo.com"
#property link      ""

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue

extern int Fast.MA.Period = 5;
extern int Slow.MA.Period = 34;
extern int  Signal.period        = 5;

//---- buffers
double      Buffer1[],
            Buffer2[],
            b2[],
            b3[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators

// two additional buffers used for counting

   IndicatorBuffers(4);
        
   
   IndicatorShortName("Elliott Wave Oscillator");
   
   SetIndexStyle(0,DRAW_ARROW,STYLE_SOLID,1);
   SetIndexArrow(0,234);  // down  226 234  242
   SetIndexBuffer(0,b2);

   SetIndexStyle(1,DRAW_ARROW,STYLE_SOLID,1);
   SetIndexArrow(1,233);   //UP   225  233 241
   SetIndexBuffer(1,b3);
   
// These buffers are not plotted, just used to determine arrows

   SetIndexBuffer (2,Buffer1);
   SetIndexBuffer (3,Buffer2);
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
   int    i, counted_bars=IndicatorCounted();
   double MA5,MA34;
   int limit=Bars-counted_bars;
   Print(" print limit = ", limit);
   if(counted_bars>0) limit++;
//---- TODO: add your code here
   
// Main line
   for(i=0; i<limit; i++)
   {
      MA5=iMA(NULL,0,Fast.MA.Period,0,MODE_SMA,PRICE_MEDIAN,i);
      MA34=iMA(NULL,0,Slow.MA.Period,0,MODE_SMA,PRICE_MEDIAN,i);
      
      Buffer1[i]=MA5-MA34;
    }       

// Signal line

  for(i=0; i<limit; i++)
   {
      Buffer2[i]=iMAOnArray(Buffer1,Bars,Signal.period,0,MODE_LWMA,i);
   }
      
// Arrows

   for(i=0; i<limit; i++)
   {
         if(Buffer1[i] > Buffer2[i] && Buffer1[i-1] < Buffer2[i-1])
               b2[i] = High[i]+10*Point;      
         if(Buffer1[i] < Buffer2[i] && Buffer1[i-1] > Buffer2[i-1])
               b3[i] = Low[i]-10*Point; 
   }
        
//----
   return(0);
  }
//+------------------------------------------------------------------+