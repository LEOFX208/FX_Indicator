/*------------------------------------------------------------------+
                                                  6MovingAverages.mq4
                                          Copyright (c) 2010, Ken.tak 
                                 http://kenchanfxblog.blog76.fc2.com/
+------------------------------------------------------------------+*/
#property copyright "ken.tak"
#property link      "http://kenchanfxblog.blog76.fc2.com/"

#property indicator_chart_window

#property indicator_buffers 6
#property indicator_color1 LightBlue
#property indicator_color2 LightGreen
#property indicator_color3 Khaki
#property indicator_color4 LightSalmon
#property indicator_color5 Pink
#property indicator_color6 Violet

//---- input parameters
extern int  MA1=    5;
extern int  MA2=   10;
extern int  MA3=   25;
extern int  MA4=   75;
extern int  MA5=  100;
extern int  MA6=  200;

//---- buffers
double MABuffer1[];
double MABuffer2[];
double MABuffer3[];
double MABuffer4[];
double MABuffer5[];
double MABuffer6[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
   {
   //---- indicators
   SetIndexStyle(0,DRAW_LINE,1,2);
   SetIndexBuffer(0,MABuffer1);
   string index0=StringConcatenate("MA ",MA1);
   SetIndexLabel(0,index0);
   
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,MABuffer2);
   string index1=StringConcatenate("MA ",MA2);
   SetIndexLabel(1,index1);
   
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,MABuffer3);
   string index2=StringConcatenate("MA ",MA3);
   SetIndexLabel(2,index2);
   
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,MABuffer4);
   string index3=StringConcatenate("MA ",MA4);
   SetIndexLabel(3,index3);
   
   SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer(4,MABuffer5);
   string index4=StringConcatenate("MA ",MA5);
   SetIndexLabel(4,index4);
   
   SetIndexStyle(5,DRAW_LINE);
   SetIndexBuffer(5,MABuffer6);
   string index5=StringConcatenate("MA ",MA6);
   SetIndexLabel(5,index5);
   //----
   return(0);
   }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

int start()
  {
   int counted_bars = IndicatorCounted();
   int limit = Bars - counted_bars;
   
   for (int i = 0; i < limit; i++)
   {
   MABuffer1[i] = iMA(NULL, 0, MA1, 0, MODE_SMA, PRICE_CLOSE, i);
   MABuffer2[i] = iMA(NULL, 0, MA2, 0, MODE_SMA, PRICE_CLOSE, i);
   MABuffer3[i] = iMA(NULL, 0, MA3, 0, MODE_SMA, PRICE_CLOSE, i);
   MABuffer4[i] = iMA(NULL, 0, MA4, 0, MODE_SMA, PRICE_CLOSE, i);
   MABuffer5[i] = iMA(NULL, 0, MA5, 0, MODE_SMA, PRICE_CLOSE, i);
   MABuffer6[i] = iMA(NULL, 0, MA6, 0, MODE_SMA, PRICE_CLOSE, i);
   } 
   return(0);
  }
//+------------------------------------------------------------------+