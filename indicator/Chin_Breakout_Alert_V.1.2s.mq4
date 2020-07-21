//+------------------------------------------------------------------+
//|                                          Chin Breakout Alert.mq4 |
//|                      Copyright © 2007, MetaQuotes Software Corp. |
 

//|    Instructions for use
// |   are in this video:http://www.youtube.com/watch?v=5Ds1BZl78xQ
//+------------------------------------------------------------------+
#property copyright "Chin Pip.  Video instruction is@ youtube video below:"
#property link  "  http://www.youtube.com/watch?v=svbAXmkCTKE"
#property link  "and  http://www.youtube.com/watch?v=5Ds1BZl78xQ"

#include <stdlib.mqh>

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Black
//---- input parameters


extern bool      Alert_on? =True;
extern bool      Pop_Up_Box=False; 
extern double    Time_Out=7;
extern bool      Full_Voice_Support? = true;
extern string INSTURCTIONS____= "The Above requires 20 additional Sound files.";



//---- buffers
double ExtMapBuffer1[];



double top =-1;
double bottom=-1;
double hi= -1;  //this is used for the visible bar High
double lo= -1;  //visible bar Low
double hi5=-1;  // (5 bar hi)this is to make sure that we didn't scale ourselves out of the visible area of WindowS
double lo5=-1;  // (5 bar low)
double himax=-1; //max price on the scale.
double lomin=-1; //min price on the scale

int windowbars=-1; //how many bars

double i=-1; //this is a counter
double ii=-1; //another counter
double asdf=-28347.23898,asdfff=-289349.832892;//couple of other counters
double iasdf=0; //just a counter.  Probably not the most efficient way to use variables.
double sleep = 716.0989767; // this is an artificial sleep
double timecur = -1; //this is the time current for the pauses between movements
double timelock = -1;
double timelock2= -1;//this is a smaller lock out just for displaying the breech message
//double timelock3= -1;//this yet another time lock to make sure sounds are not piled up on each other.  I probably could have been more efficient and just used one variable instead of 3.
 

string top$=" ";  //this is a string to convert the double top into a string
string bottom$="."; //this is to convert double bottom into a string
string sym$ = "nothing"; //this is for the symbol();
int    sym  = -1; // this is going for case switch.


double blue_ydistance= -1; //finds the ydistnace 
double red_ydistance = -1;

string TopComment = "none";
string BottomComment = "none";

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() 
  {

    if (Full_Voice_Support? == true && Pop_Up_Box == true) Alert("Turn off Pop_Up_Box if you Want Full Voice Support.");

    sym$=Symbol(); //this gets the symbols and converts it to a numerical value.
    if (sym$==	"AUDCAD"	)	sym =	1	;	
	 if (sym$==	"AUDJPY"	)	sym =	2	;	
	 if (sym$==	"AUDUSD"	)	sym =	3	;	
	 if (sym$==	"CADJPY"	)	sym =	4	;	
	 if (sym$==	"CHFJPY"	)	sym =	5	;	
	 if (sym$==	"EURAUD"	)	sym =	6	;	
	 if (sym$==	"EURCAD"	)	sym =	7	;	
	 if (sym$==	"EURCHF"	)	sym =	8	;	
	 if (sym$==	"EURGBP"	)	sym =	9	;	
	 if (sym$==	"EURJPY"	)	sym =	10	;	
	 if (sym$==	"EURUSD"	)	sym =	11	;	
	 if (sym$==	"GBPCHF"	)	sym =	12	;	
	 if (sym$==	"GBPJPY"	)	sym =	13	;	
	 if (sym$==	"GBPUSD"	)	sym =	14	;	
	 if (sym$==	"NZDJPY"	)	sym =	15	;	
	 if (sym$==	"NZDUSD"	)	sym =	16	;	
	 if (sym$==	"USDCAD"	)	sym =	17	;	
	 if (sym$==	"USDCHF"	)	sym =	18	;	
	 if (sym$==	"USDJPY"	)	sym =	19	;	    
  
  
//---- indicators
   //Before we Start, Let's delete all the objects:
   
   ObjectDelete("top");
   ObjectDelete("bottom");

   ObjectDelete("Top Instruction");
   ObjectDelete("Bottom Instruction");
   
   ObjectDelete("Vis1");
   ObjectDelete("Vis2");
   ObjectDelete("Vis3");
   ObjectDelete("Vis4");
   
   
   //------------

   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   //Comment("blah blah");
  
 
/* 
   //>>>>>>>>>>>>>>>>>>>>>>>>>>>
//let's do some visual effects to let traders know that this is indeed a Visual Trader


   himax=WindowPriceMax(0);  //get the hi and low window price
   lomin=WindowPriceMin(0); 
   
    

   int x1 = MathRound(WindowBarsPerChart()*0.66);
   int x2 = MathRound(WindowBarsPerChart()*0.39);
   int x3 = MathRound(WindowBarsPerChart()*0.71);
   int x4 = MathRound(WindowBarsPerChart()*0.31);
   
   double xx1 = lomin+(himax-lomin)/7;  //the low plus a tenth of the range of the high to the low
   double xx2 = himax-(himax-lomin)/7;
   double xx3 = himax-(himax-lomin)/7;
   double xx4 = himax-(himax-lomin)/7;
   
   xx1=WindowPriceMax(0);
   xx2=WindowPriceMin(0);
   
   Comment("winmax",WindowPriceMax(0), " xx1 ", xx1, " xx2 ", xx2, " xx3 ", xx3, " xx4 ", xx4);
   
   ObjectCreate("Vis1",OBJ_TEXT,0,Time[x1],xx1);//lomin+(himax+lomin)/10);
   ObjectCreate("Vis2",OBJ_TEXT,0,Time[x2],xx2);//himax-(himax+lomin)/10);
   ObjectCreate("Vis3",OBJ_TEXT,0,Time[x3],xx3);//himax-(himax+lomin)/7);
   ObjectCreate("Vis4",OBJ_TEXT,0,Time[x4],xx4);

   ObjectSetText("Vis1","____________________________________________________________",10,"Arial",Blue); //start at the middle and move towards the final location 
   ObjectSetText("Vis2","____________________________________________________________",10,"Arial",Red); 
   ObjectSetText("Vis3","Visual",30,"Arial",ForestGreen);
   ObjectSetText("Vis4","Trader",40,"Arial",ForestGreen);

    

   
   
   //final destination of:
   //vis1: middle and Hi (spins twice as fast)
   //vis2: middle and low
   //vis3: Left middle and Low(spins twice as fast)
   //vis4: Right Middle and Low   
   
   //we will do a measured move from the origination to the destination

   i=0;
   for (i=0; i < 723.9000; i+=4.00000)  //we want to spin this thing until it reaches the X coordinates and y coordinates we want.
                             //i / 2 = 360   
       
       {
        timecur = TimeLocal();
        
        ii=0;
        while (TimeLocal()<timecur+sleep-i/2 && ii<70000.00001-i*1.655) ii+=1.01010101;  //we have a small pause between each movement
                                                                          //the pause gets smaller and smaller (ie substracted by increments of i 
       
       
        
      
        Sleep(500);
                                                                       //at first we substract 0.17 / 720.  But eventually, we substract the whole 0.17.
        x1 = MathRound(0.660000*WindowBarsPerChart()-0.17000*WindowBarsPerChart()/720.00001*i);
        xx1= lomin+(himax-lomin)/7+(himax-lomin)*0.6/720.000001*i;



      //ObjectDelete("Vis1");
      //ObjectCreate("Vis1",OBJ_TEXT,0,Time[x1],xx1);//lomin+(himax+lomin)/10);
      
        ObjectMove("Vis1",0,Time[x1],xx1);
        ObjectSet("Vis1",OBJPROP_ANGLE, 720-i);
      
      //ObjectSetText("Vis1","____________________________________________________________",10,"Arial",Blue); //start at the middle and move towards the final location 
      //ObjectSet("Vis1",OBJPROP_TIME1,  Time[x1]);
      //ObjectSet("Vis1",OBJPROP_PRICE1,  xx1);
                                          //This math has us starting at 0.66.  We substract 0.17 in 720 increments to eventually substract the whole 0.17, which ends us up in 0.5  
 
        
        x2 = MathRound(0.37*WindowBarsPerChart()+0.14*WindowBarsPerChart()/720.000001*i);                                                             
        xx2 = himax-(himax-lomin)/7-(himax-lomin)*0.72/720.000001*i;

      //ObjectDelete("Vis2");
      //ObjectCreate("Vis2",OBJ_TEXT,0,Time[x2],xx2);//himax-(himax+lomin)/10);
        
        ObjectSet("Vis2",OBJPROP_ANGLE,  i/2);
        ObjectMove("Vis2",0,Time[x2],xx2);
        
      //ObjectSetText("Vis2","____________________________________________________________",10,"Arial",Red); 
      //ObjectSet("Vis2",OBJPROP_TIME1,  Time[x2]);
      //ObjectSet("Vis2",OBJPROP_PRICE1,  xx2);
                                          //we add .14 in 720 increments.  Eventually, as i approach 720, we add the whole 0.14 to make .51       
        
    
        x3 = MathRound(0.71*WindowBarsPerChart()-0.4*WindowBarsPerChart()/720.000001*i);  //eventually the secone term grows bigger until it becomes 0.4; so 0.71-.4 = 0.31 where we want it to end up
        xx3 = himax-(himax-lomin)/7-(himax-lomin)*0.72/720.0000001*i;
        int xxx3 = MathRound(39.00000-27.0000001/720.0000001*i);

      //ObjectDelete("Vis3");
      //ObjectCreate("Vis3",OBJ_TEXT,0,Time[x3],xx3);//himax-(himax+lomin)/7);
        
        ObjectMove("Vis3",0,Time[x3],xx3);
        ObjectSet("Vis3",OBJPROP_ANGLE,  i);
        ObjectSetText("Vis3","Visual",xxx3,"Arial",Purple);     
     
     // ObjectSet("Vis3",OBJPROP_TIME1,  Time[x3]);
     // ObjectSet("Vis3",OBJPROP_PRICE1,  xx3);
     
          


        
        x4 = MathRound(0.31*WindowBarsPerChart()+0.4*WindowBarsPerChart()/720*i);
        xx4 = himax-(himax-lomin)/7-(himax-lomin)*0.72/720*i;
        int xxx4 = MathRound(44.000001-30.0000001/720.0000001*i);
       
      //ObjectDelete("Vis4");
      //ObjectCreate("Vis4",OBJ_TEXT,0,Time[x4],xx4);   
        
        ObjectMove("Vis4",0,Time[x4],xx4);
        ObjectSet("Vis4",OBJPROP_ANGLE, (720.0000000-i)/2);
        ObjectSetText("Vis4","Trader",xxx4,"Arial",Green);


        ObjectsRedraw();        
      //ObjectSet("Vis4",OBJPROP_TIME1,  Time[x4]);
      //ObjectSet("Vis4",OBJPROP_PRICE1,  xx4);
        
        
          
        xx3=3000.00234/720.2342;  
        Comment("winmax",WindowPriceMax(0)," i ", i, " xx1 ", xx1, " xx2 ", xx2, " xx3 ", xx3, " xx4 ", xx4, " xxx3 ", xxx3, " xxx4 ",xxx4
                ,"mathround ", (45-(30.00000/720.000000*i)," 30/ ", (307.0000/777.00000))  
                 
               );  
        
       }
   
*/


   


   //Now let's set the Horizontal Lines.  
   if (WindowFirstVisibleBar()>WindowBarsPerChart()) windowbars = WindowBarsPerChart();  //these are numbered with last bar being number 1.  If first visible bar is more than the # of bars per window, then the chart has been scrolled left.
   else windowbars = WindowFirstVisibleBar();  //if chart has not bee scrolled left, we can use the first visible bar
   
   if (windowbars >WindowBarsPerChart()*0.95 || windowbars <WindowBarsPerChart()*0.47) windowbars=WindowBarsPerChart()*0.75;
       //if windowbars is too big or too small, we will make it 75% of the window.  
   

   himax=WindowPriceMax(0);  //get the hi and low window price
   lomin=WindowPriceMin(0); 
      
   hi=High[iHighest(NULL,0,MODE_HIGH,windowbars*0.6,0)];
   lo=Low[iLowest(NULL,0,MODE_LOW,windowbars*0.6,0)];

   hi5=High[iHighest(NULL,0,MODE_HIGH,15,0)];
   lo5=Low[iLowest(NULL,0,MODE_LOW,15,0)];

   himax=WindowPriceMax(0);
   lomin=WindowPriceMin(0);

   if (hi>himax) hi -= (hi+lo)/12; 
   if (lo<lomin) lo += (hi+lo)/12;

   if (hi<hi5) hi=hi5;  //if we moved the y parameter too close to the current price, then do it at the current price.
   if (lo>lo5) lo=lo5;  //if the scale is out of range, we just take the hi or low of the last 5 bars.


   
                          //length of the window # of bars short by 1/7
   ObjectCreate("top",2,0,Time[windowbars]+windowbars*0.321*Period()*60,hi,Time[0],hi);
   ObjectSet("top",OBJPROP_COLOR,Blue);
  
   ObjectCreate("bottom",2,0,Time[windowbars]+windowbars*0.312*Period()*60,lo,Time[0],lo);
   ObjectSet("bottom",OBJPROP_COLOR,Red);
   
  
  
//----


  return (0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----


   ObjectDelete("top");
   ObjectDelete("bottom");

   ObjectDelete("Top Instruction");
   ObjectDelete("Bottom Instruction");

   ObjectDelete("Top Instruction2");
   ObjectDelete("Bottom Instruction2");

 
   

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   
   
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>...

/*
for (int akak =1 ; akak< 10; akak++)
     { 
      for(int kkkk=1; kkkk<500000; ) kkkk++;
      
      Comment(akak); 
      PlaySound("Alert2.wav");
      kkkk=0;
     }
*/



//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

   if (Alert_on? == False)
      {
       ObjectDelete("Top Instruction");
       ObjectCreate("Top Instruction",OBJ_LABEL,0,TimeLocal(),0);
       ObjectSetText("Top Instruction","Alert HAS been Turned OFF.",10,"Arial",DodgerBlue);  
       ObjectSet("Top Instruction",OBJPROP_YDISTANCE, 44); 
       ObjectSet("Top Instruction",OBJPROP_XDISTANCE, 10);
       
       ObjectSet("top",OBJPROP_STYLE,STYLE_DASHDOT);
       ObjectSet("top",OBJPROP_COLOR,Yellow);

       ObjectSet("bottom",OBJPROP_STYLE,STYLE_DASHDOT);
       ObjectSet("bottom",OBJPROP_COLOR,Yellow);
       
       return(0);
       
         
      } 
        

   
   ObjectCreate("Top Instruction",OBJ_TEXT,0,Time[WindowBarsPerChart()/2],hi);
   ObjectSetText("Top Instruction","Resistance",10,"Arial",DodgerBlue);
  // ObjectMove("Top Instruction",0,Time[55],hi+15*Point); 
  // ObjectSet("Top Instruction",OBJPROP_XDISTANCE,30);
   ObjectSet("Top Instruction",OBJPROP_ANGLE, i); 
    
   if (i>3.9 || ii<-3.7) {i=-3.2; ii=3.4;}
   i +=0.1657;
   ii-=0.6;
   
   ObjectCreate("Bottom Instruction",OBJ_TEXT,0,Time[WindowBarsPerChart()/2],lo);
   ObjectSetText("Bottom Instruction","Support",10,"Arial",DeepPink);
  // ObjectMove("Bottom Instruction",0,Time[37],lo+12*Point);
  // ObjectSet("Bottom Instruction",OBJPROP_XDISTANCE,30); 
   ObjectSet("Bottom Instruction",OBJPROP_ANGLE, ii); 
 
 
 
   ObjectSet("top",OBJPROP_COLOR,Blue);
   ObjectSet("bottom",OBJPROP_COLOR,Red);
   


//this gets the price of the blue and red lines
   top = ObjectGetValueByShift("top",0); 
   bottom = ObjectGetValueByShift ("bottom",0);


   if(top != hi) 
      {
       hi +=0.002932498*Point;   
       
       top$ = NormalizeDouble(top,Digits);   
       
       
       //--Let's find the decimal point to the top$ string.  (we do this so we can truncate the string to shave off the extra zeros after the decimal point
       i=0;  //for any while loop or for loop, you want to give it two ways to break the loop (for safety).
       while (StringGetChar(top$,i)!=46 && i<10) i+=1.01010101; //trying to find the decimal point in the top$ string
       top$ = StringSubstr(top$,0,i+Digits+1); //start extract the string from the first charater up to all the places behind the decimal
       
       if (TimeLocal()>timelock2)  //do this only if we are not in time lock
           {TopComment=   "R: "+top$;
           }
       if (ObjectFind("top") !=0 ) //This is if the /blue horizontal line has been deleted.
           
           {
            top=9999999;
            TopComment="Top Alert=off (Blue line DELETED)."; //objfind returns the window in which the object resides.
           }
                     
       ObjectDelete("Top Instruction");
       ObjectCreate("Top Instruction",OBJ_LABEL,0,TimeLocal(),0);
       ObjectSetText("Top Instruction",TopComment,10,"Arial",SteelBlue);  
       ObjectSet("Top Instruction",OBJPROP_YDISTANCE, 44); 
       ObjectSet("Top Instruction",OBJPROP_XDISTANCE, 10);  
 

 
      }
    

   if(bottom != lo) 
      {
       lo +=0.001228398*Point;      
       
       bottom$ = NormalizeDouble(bottom,Digits);
       
       
       //--- The following is for trying to find the decimal point of the bottom$ string
       i=0;
       while (StringGetChar(bottom$,i)!=46 && i <10) i+=1.01010101; //trying to find the decimal point in the top$ string
       bottom$ = StringSubstr(bottom$,0,i+Digits+1);  //start extract the string from the first charater (0) all the way to the last place behind the decimal
       
       //---


       if(TimeLocal()>timelock2)//DO THIS  only if we are not in lock out.
          {BottomComment="S: "+bottom$;    
          }
       if (ObjectFind("bottom") !=0 ) //this is if the Red line has been deleted.
           {
            bottom=-9999999;
            BottomComment="Bottom Alert=off (Red line DELETED).";//objectfind returns the window that object resides.
           }
              
       ObjectDelete("Bottom Instruction");
       ObjectCreate("Bottom Instruction",OBJ_LABEL,0,TimeLocal(),0);
       ObjectSetText("Bottom Instruction",BottomComment,10,"Arial",Red);  
       ObjectSet("Bottom Instruction",OBJPROP_YDISTANCE,61); 
       ObjectSet("Bottom Instruction",OBJPROP_XDISTANCE,10); 
 

 
      }
   //Comment("\ntop: ", top, " b ", bottom, " y ", blue_ydistance, " ", red_ydistance);   
   
    
    if (Close[0] >=NormalizeDouble(top,Digits)  &&  TimeLocal() > timelock  && Alert_on? ==true) 

        {
        
        
            timelock2=TimeLocal()+4.5; //this is a smaller lock out just for displaying the breech message           
            timelock= TimeLocal();  //done just for a slight pause
           
         if (Pop_Up_Box == False  && Full_Voice_Support? ==False)  //if both of these choices are false, we default to just playing the sounds.
            {
             PlaySound("Alert.wav");
            }
        else 
            {
             timelock = TimeLocal();
             
             if (Pop_Up_Box == true) 
                 {
                  Alert("Upper Breech ",Symbol()," ",top$);  //we will shoot an alert, but then go for a few seconds delay if full voice is on
                 }     
             
             if (Full_Voice_Support? == true) 
                 {
                  SoundFilesResistance();
                 }
                  
            }
            


            
            
            TopComment = top$+ " Breech!";
            ObjectSetText("Top Instruction",TopComment,12,"Arial",DodgerBlue);
            timelock = TimeLocal()+Time_Out;   //how many seconds do we lock out the Alert
        }    


    if (Close[0] <=NormalizeDouble(bottom,Digits)  &&  TimeLocal() > timelock  && Alert_on? ==true) 

        {
        
        
            timelock2 = TimeLocal()+4.5;//this is a smaller lock out just for displaying the breech message
            timelock  = TimeLocal();   //just for a slight, unofficial pause
            
        if (Pop_Up_Box == False  && Full_Voice_Support? == False)  //if both choices are false, we default to just playing the sound alone without pop box and no full voice support
            {
            PlaySound("Alert.wav");            
            }
        else 
            {
             timelock = TimeLocal();

             if (Pop_Up_Box == true) 
                 {
                  Alert("Lower Breech ",Symbol()," ",bottom$);//we will shoot an alert, but then go for a few seconds delay if full voice is on
                 } 

            
             if (Full_Voice_Support? == true) 
                 {
                  SoundFilesSupport();
                          
                 } 
                 
            }
     
            BottomComment =bottom$ + " Breech!";
            ObjectSetText("Bottom Instruction",BottomComment,12,"Arial",Red); 
            timelock = TimeLocal()+Time_Out;   //how many seconds do we lock out the Alert
        }    


   //for(asdfff=0;asdfff<99.293;asdfff +=1.020201021) asdfff+=0;
   //while(asdf<99.299302 && asdfff <1000) asdf +=1.101001011;
    
  // Comment("TimeLocal() ",TimeToStr(TimeLocal(),TIME_SECONDS)," Lockout, ",TimeToStr(timelock2,TIME_SECONDS)  );
   //Comment("asdf ", asdf," asdfff ", asdfff," iasdf ",iasdf, " i ", i, " ii ",ii); 
	
	

    
//----
   return(0);
  }
//+------------------------------------------------------------------+


int SoundFilesResistance()
    {     
     switch(sym)
            
           {
            case 1:
                PlaySound("rAUDCAD.wav");
                break;
                
            case 2:
                PlaySound("rAUDJPY.wav");
                break;    
                
            case 3:
                PlaySound("rAUDUSD.wav");
                break;    
                
            case 4:
                PlaySound("rCADJPY.wav");
                break;    
                
            case 5:
                PlaySound("rCHFJPY.wav");
                break;    
                
            case 6:
                PlaySound("rEURAUD.wav");
                break;    
                
            case 7:
                PlaySound("rEURCAD.wav");
                break;
                
            case 8:
                PlaySound("rEURCHF.wav");
                break;        
                
            case 9:
                PlaySound("rEURGBP.wav");
                break;
               
            case 10:
                PlaySound("rEURJPY.wav");
                break;   
                
            case 11:
                PlaySound("rEURUSD.wav");
                break;    
                
            case 12:
                PlaySound("rGBPCHF.wav");
                break;    
                
            case 13:
                PlaySound("rGBPJPY.wav");
                break;    
                
            case 14:
                PlaySound("rGBPUSD.wav");
                break;    
                
            case 15:
                PlaySound("rNZDJPY.wav");
                break;    
                
            case 16:
                PlaySound("rNZDUSD.wav");
                break;    
                
            case 17:
                PlaySound("rUSDCAD.wav");
                break;    
                
            case 18:
                PlaySound("rUSDCHF.wav");
                break;    
                
            case 19:
                PlaySound("rUSDJPY.wav");
                break;    
            
            default:    
                if (Pop_Up_Box==false) Alert("Res. Break. ",Symbol(), " (Voice Support not Avail.)");
                break;
                
            }
            
    
     return(0);
    }                
    
 
 
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//now for when support is broken:

int SoundFilesSupport()
    {         
     switch(sym)
            
           {
            case 1:
                PlaySound("sAUDCAD.wav");
                break;
                
            case 2:
                PlaySound("sAUDJPY.wav");
                break;    
                
            case 3:
                PlaySound("sAUDUSD.wav");
                break;    
                
            case 4:
                PlaySound("sCADJPY.wav");
                break;    
                
            case 5:
                PlaySound("sCHFJPY.wav");
                break;    
                
            case 6:
                PlaySound("sEURAUD.wav");
                break;    
                
            case 7:
                PlaySound("sEURCAD.wav");
                break;
                
            case 8:
                PlaySound("sEURCHF.wav");
                break;        
                
            case 9:
                PlaySound("sEURGBP.wav");
                break;
               
            case 10:
                PlaySound("sEURJPY.wav");
                break;   
                
            case 11:
                PlaySound("sEURUSD.wav");
                break;    
                
            case 12:
                PlaySound("sGBPCHF.wav");
                break;    
                
            case 13:
                PlaySound("sGBPJPY.wav");
                break;    
                
            case 14:
                PlaySound("sGBPUSD.wav");
                break;    
                
            case 15:
                PlaySound("sNZDJPY.wav");
                break;    
                
            case 16:
                PlaySound("sNZDUSD.wav");
                break;    
                
            case 17:
                PlaySound("sUSDCAD.wav");
                break;    
                
            case 18:
                PlaySound("sUSDCHF.wav");
                break;    
                
            case 19:
                PlaySound("sUSDJPY.wav");
                break;    
            
            default:    
                if (Pop_Up_Box==false) Alert("Supp. Breech (Voice Support Not Avail.) ", Symbol());
                break;
                
            }
            
    
     return(0);
    }                 
    