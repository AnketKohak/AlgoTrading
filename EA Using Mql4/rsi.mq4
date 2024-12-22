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

double openOrderIDb;
double openOrderIDb1;
double openOrderIDb2;

double openOrderIDs;
double openOrderIDs1;
double openOrderIDs2;
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
   double rsi =iRSI(NULL,0,14,PRICE_CLOSE,0);
   double rsi1 =iRSI(NULL,0,14,PRICE_CLOSE,1);
   double rsi2 =iRSI(NULL,0,14,PRICE_CLOSE,2);
   if(!CheckIfOpenOrderByMagicNB(magicNB))//if no open orders try to enter new position
     {
      if(ma<Bid && rsi2<=30 &&rsi1>=30)//buying
        {
         openOrderIDb = OrderSend(NULL,OP_BUY,lotsize,Ask,10,0,0,NULL,magicNB);
         openOrderIDb1 = OrderSend(NULL,OP_BUY,lotsize,Ask,10,0,0,NULL,magicNB);
         openOrderIDb2 = OrderSend(NULL,OP_BUY,lotsize,Ask,10,0,0,NULL,magicNB);
         if(openOrderIDb < 0)
            Alert("order rejected. Order error: " + GetLastError());
        }
      else
         if(ma>Bid && rsi2>=70 && rsi1<=70)
           {
            

            openOrderIDs = OrderSend(NULL,OP_SELL,lotsize,Ask,10,0,0,NULL,magicNB);
            openOrderIDs1 = OrderSend(NULL,OP_SELL,lotsize,Ask,10,0,0,NULL,magicNB);
            openOrderIDs2 = OrderSend(NULL,OP_SELL,lotsize,Ask,10,0,0,NULL,magicNB);
            if(openOrderIDs < 0)
               Alert("order rejected. Order error: " + GetLastError());
           }
     }
   else //else if you already have a position, update orders if need too.
     {
      if(OrderType()==0)
        {
         if(OrderSelect(2,SELECT_BY_POS,MODE_TRADES))
           {
            if(rsi>=45 || rsi<=25)
              {
               OrderClose(openOrderIDb2,0.01,Bid,10);
              }
           }
         else
            if(OrderSelect(1,SELECT_BY_POS,MODE_TRADES))
              {
               if(rsi>=55 || rsi<=44)
                 {
                  OrderClose(openOrderIDb1,0.01,Bid,10);
                 }
              }
            else
               if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES))
                 {
                  if(rsi>=65 || rsi<=54)
                    {

                     OrderClose(openOrderIDb,0.01,Bid,10);
                    }
                 }
        }
      else
         if(OrderType()==1)
           {
            if(OrderSelect(2,SELECT_BY_POS,MODE_TRADES))
              {
               if(rsi<=55 || rsi>=75)
                 {
                  OrderClose(openOrderIDs2,0.01,Bid,10);
                 }
              }
            else
               if(OrderSelect(1,SELECT_BY_POS,MODE_TRADES))
                 {
                  if(rsi<=45 || rsi>=56)
                    {
                     OrderClose(openOrderIDs1,0.01,Bid,10);
                    }
                 }
               else
                  if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES))
                    {
                     if(rsi<=35 || rsi>=46)
                       {

                        OrderClose(openOrderIDs,0.01,Bid,10);
                       }
                    }
           }
     }
  }
//+------------------------------------------------------------------+
