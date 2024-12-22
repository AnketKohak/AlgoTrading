//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property show_inputs
#include  <custom.mqh>

int magicNB = 55555;
double lotsize=0.01;
input int t=5;
input int  s=2;

int openOrderIDb;
int openOrderIDb1;
int openOrderIDb2;

int openOrderIDs;
int openOrderIDs1;
int openOrderIDs2;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   Alert("");
   Alert("Starting Strategy BB 2Bans MR");

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Alert("Stopping Strategy BB 2Bans MR");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  int highestcandle=iHighest(NULL,0,MODE_HIGH,50,0);
  int lowestcandle=iLowest(NULL,0,MODE_LOW,50,0);
  ObjectDelete("Fibonacci");
  ObjectCreate("Fibonacci",OBJ_FIBO,0,Time[0],High[highestcandle],Time[50],Low[lowestcandle]);
  
 
  double Level0=ObjectGetDouble(0,"Fibonacci",OBJPROP_PRICE,1);
   double Level100=ObjectGetDouble(0,"Fibonacci",OBJPROP_PRICE,0);
   double Level50=((Level0+Level100)/2);
  
 
   Comment(  
               "Level  0 : ",Level0+"\n",
             "Level   50 : ",Level50+"\n",
             "Level  100 : ",Level100+"\n"
             );
    
  }










//+------------------------------------------------------------------+

//+------------------------------------------------------------------

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
