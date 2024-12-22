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
   double ma = iMA(NULL,0,50,0,MODE_EMA,PRICE_CLOSE,0);
   double atr = iATR(NULL,0,14,0);
   int  highest = iHighest(NULL,0,MODE_HIGH,14,0);
   int lowest  =iLowest(NULL,0,MODE_LOW,14,0);
   if(!CheckIfOpenOrderByMagicNB(magicNB))//if no open orders try to enter new position
     {
      if(High[highest] <= Close[0] && ma<Bid)//buying
        {
         double stoploss;
         double takeprofit;
         double stopLossPrice = Bid-(2*atr);
         double takeProfitPrice = Bid+(5*atr);
         openOrderIDb = OrderSend(NULL,OP_BUY,0.01,Ask,10,stopLossPrice,takeProfitPrice,NULL,magicNB);
         if(openOrderIDb < 0)
            Alert("order rejected. Order error: " + GetLastError());
        }
      else
         if(Low[lowest] >= Close[0] && ma>Bid)
           {
            double stoploss=50;
            double stopLossPrice = Bid+(2*atr);
            double takeProfitPrice = Bid -(5*atr);
            openOrderIDs = OrderSend(NULL,OP_SELL,0.01,Bid,10,stopLossPrice,takeProfitPrice,NULL,magicNB);
            if(openOrderIDs < 0)
               Alert("order rejected. Order error: " + GetLastError());
           }
     }
   else //else if you already have a position, update orders if need too.
     {
      if(OrderType()==0)
        {
         double takeprofit=High[highest]+(5*atr);
         double stoploss  =High[highest]-(2*atr);
         double ordermodify =OrderModify(openOrderIDb,Bid,stoploss,0,0);

        }
      else
         if(OrderType()==1)
           {
            double takeprofit=Low[lowest]-(5*atr);
            double stoploss  =Low[lowest]+(2*atr);
            double ordermodify =OrderModify(openOrderIDs,Bid,stoploss,0,0);
           }
     }
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
