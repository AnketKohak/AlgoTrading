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

int openOrderIDb;
int openOrderIDs;
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

   double ma = iMA(NULL,0,200,0,MODE_SMA,PRICE_CLOSE,0);

   double ma1 = iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,1);
   double ma2 = iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,2);
   double ma3 = iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,3);
   
   double uptrend= ((ma3<ma2)&&(ma2<ma1));
   double downtrend=((ma3>ma1)&&(ma2>ma1));
   double sideways=((!uptrend) && (!downtrend));
   


   double main=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   double main1=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   double main2=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,2);
   double signal = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   if(!CheckIfOpenOrderByMagicNB(magicNB))//if no open orders try to enter new position
     {
      if(ma<Bid && main >=0 && main2<main1 && uptrend) //buying
        {
         double stoploss;
         double takeprofit;
         double stopLossPrice = Low[2];
         double takeProfitPrice = ((Bid-Low[2])*2)+Bid;

         openOrderIDb = OrderSend(NULL,OP_BUY,lotsize,Ask,10,0,0,NULL,magicNB);
         if(openOrderIDb < 0)
            Alert("order rejected. Order error: " + GetLastError());
        }
      else
         if(ma>Bid && main <=0 && main2>main1 && downtrend)
           {
            double stoploss=50;
            double stopLossPrice = Low[3];
            double takeProfitPrice = ((Bid-Low[3])*2)+Bid;

            openOrderIDs = OrderSend(NULL,OP_SELL,lotsize,Ask,10,0,0,NULL,magicNB);
            if(openOrderIDs < 0)
               Alert("order rejected. Order error: " + GetLastError());
           }
     }
   else //else if you already have a position, update orders if need too.
     {
      if(main2>main1)
        {
         double orderclose = OrderClose(openOrderIDb,lotsize,Bid,10);
        }
      else
         if(main2<main1)
           {
            double orderclose = OrderClose(openOrderIDs,lotsize,Bid,10);
           }
     }
  }


//+-----------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
