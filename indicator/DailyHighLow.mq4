
//+------------------------------------------------------------------+
//|                                               Daily High Low.mq4 |
//|                                           Copywrong 2005, RonT   |
//|                                 http://www.lightpatch.com/forex/ |
//+------------------------------------------------------------------+
#property copyright "RonT"
#property link      "http://www.lightpatch.com/forex/"

#property indicator_chart_window
#property indicator_buffers 2

double LOBuffer[];
double HIBuffer[];



//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0,DRAW_LINE,0,1,DarkTurquoise);
   SetIndexBuffer(0,LOBuffer);

   SetIndexStyle(1,DRAW_LINE,0,1,Crimson);
   SetIndexBuffer(1,HIBuffer);

   return(0);
  }



//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()

  {
   int    counted_bars=IndicatorCounted();
   int    limit, i;

   double dayhigh=0;
   double daylow=999;
   
   if(counted_bars<0) return(-1);
   limit=(Bars-counted_bars)-1;

   for (i=limit; i>=0;i--)
     { 
      if (dayhigh<High[i]) {dayhigh=High[i];}
      if (daylow>Low[i])   {daylow=Low[i];  }

      if (TimeDay(Time[i])!=TimeDay(Time[i+1]))
        { 
         // reset limits when day changes
         dayhigh=High[i];
         daylow=Low[i];
        }
   
      LOBuffer[i]=daylow;
      HIBuffer[i]=dayhigh;

     }
   return(0);
  }


