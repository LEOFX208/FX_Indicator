//+------------------------------------------------------------------+
//|                                              Stochastic tape.mq4 |
//|                                                           mladen |
//+------------------------------------------------------------------+
#property copyright "mladen"
#property link      ""

#property indicator_separate_window
#property indicator_buffers   2
#property indicator_color1    DimGray
#property indicator_color2    Lime
#property indicator_minimum   0
#property indicator_maximum 100
#property indicator_level1   80
#property indicator_level2   20
#property indicator_levelcolor DimGray

//
//
//
//
//

extern int   KPeriod       = 34;
extern int   Slowing       = 10;
extern int   DPeriod       =  5;
extern int   MAMethod      =  2;
extern int   PriceField    =  0;
extern int   BarsToCount   = 300;
extern bool  ShowTape      = true;
extern color TapeColorUp   = Green;
extern color TapeColorDown = Red;
extern int   TapeBarsWidth = 1;

//
//
//
//
//

double StocBuffer[];
double SignBuffer[];
double EmaBuffer1[];
double EmaBuffer2[];
double EmaBuffer3[];
string shortName;
int    Window;
int    WindowID;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

int init()
{
   IndicatorBuffers(5);
   SetIndexBuffer(0,SignBuffer);
   SetIndexBuffer(1,StocBuffer);
   SetIndexBuffer(2,EmaBuffer1);
   SetIndexBuffer(3,EmaBuffer2);
   SetIndexBuffer(4,EmaBuffer3);
   
   //
   //
   //
   //
   //

   WindowID     = MathRand();
   BarsToCount  = MathMax(BarsToCount,300);
   shortName    = "Stochastic tape("+KPeriod+","+DPeriod+","+Slowing+" : "+WindowID+")";
   
   //
   //
   //
   //
   //
   
   IndicatorShortName(shortName);
   return(0);
}

int deinit()
{
   DeleteTape();
   return(0);
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

int start()
{
   int    counted_bars=IndicatorCounted();
   int    limit,i;


   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
         limit  = Bars-counted_bars;
         CheckWindow();

   //
   //
   //
   //
   //

   for (i=limit;i>=0;i--)
      {
          StocBuffer[i] = iStochastic(NULL,0,KPeriod,DPeriod,Slowing,MAMethod,PriceField,MODE_MAIN,i);
          SignBuffer[i] = iStochastic(NULL,0,KPeriod,DPeriod,Slowing,MAMethod,PriceField,MODE_SIGNAL,i);
      }   
   
   //
   //
   //
   //
   //
   
   DeleteTape();
   if (ShowTape) for (i=0; i<BarsToCount ;i++) DrawTape(StocBuffer[i],SignBuffer[i],i);

   //
   //
   //
   //
   //
         
   for (i=0;i<indicator_buffers;i++) SetIndexDrawBegin(i,Bars-BarsToCount);
   return(0);
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#define SignalName "StocTape"
    int maxLines = 0;

//
//
//
//
//

void DrawTape(double __1, double __2,int shift)
{
   if (__1==__2) return;
   
   //
   //
   //
   //
   //
   
   maxLines++;
      datetime time = Time[shift];
      string   name = StringConcatenate(SignalName,WindowID,"-",maxLines);
 
      ObjectCreate(name,OBJ_TREND,Window,time,__1,time,__2);
         if (__1>__2)
               ObjectSet(name,OBJPROP_COLOR ,TapeColorUp);
         else  ObjectSet(name,OBJPROP_COLOR ,TapeColorDown);
         ObjectSet(name,OBJPROP_RAY   ,false);
         ObjectSet(name,OBJPROP_BACK  ,true);
         ObjectSet(name,OBJPROP_WIDTH ,TapeBarsWidth);
}
void DeleteTape()
{
   string name = StringConcatenate(SignalName,WindowID);
      while(maxLines>0) { ObjectDelete(StringConcatenate(name,"-",maxLines)); maxLines--; }
                          ObjectDelete(name);
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void CheckWindow()
{
   string name = StringConcatenate(SignalName,WindowID);
   
   //
   //
   //
   //
   //
   
   Window = WindowFind(shortName);
   if(Window == -1) {
      Window = ObjectFind(name);
      if(Window == -1) {
         Window = WindowOnDropped();
            ObjectCreate(name,OBJ_TEXT,Window,0,0);
      }
   }
}