-- from https://inst.eecs.berkeley.edu/~cs61a/fa15/lab/lab13

CREATE TABLE flights as
  SELECT "SFO" as departure, "LAX" as arrival, 97 as price UNION
  SELECT "SFO"             , "AUH"           , 848         UNION
  SELECT "LAX"             , "SLC"           , 115         UNION
  SELECT "SFO"             , "PDX"           , 192         UNION
  SELECT "AUH"             , "SEA"           , 932         UNION
  SELECT "SLC"             , "PDX"           , 79          UNION
  SELECT "SFO"             , "LAS"           , 40          UNION
  SELECT "SLC"             , "LAX"           , 117         UNION
  SELECT "SEA"             , "PDX"           , 32          UNION
  SELECT "SLC"             , "SEA"           , 42          UNION
  SELECT "SFO"             , "SLC"           , 97          UNION
  SELECT "LAS"             , "SLC"           , 50          UNION
  SELECT "LAX"             , "PDX"           , 89               ;

CREATE TABLE supermarket as
  SELECT "turkey" as item, 30 as price UNION
  SELECT "tofurky"       , 20          UNION
  SELECT "cornbread"     , 12          UNION
  SELECT "potatoes"      , 10          UNION
  SELECT "cranberries"   , 7           UNION
  SELECT "pumpkin pie"   , 15          UNION
  SELECT "CAKE!"         , 60          UNION
  SELECT "foie gras"     , 70               ;

create table main_course as
  select "turkey" as meat, "cranberries" as side, 2000 as calories UNION
  select "turducken"     , "potatoes"           , 4000             UNION
  select "tofurky"       , "cranberries"        , 1000             UNION
  select "tofurky"       , "stuffing"           , 1000             UNION
  select "tofurky"       , "yams"               , 1000             UNION
  select "turducken"     , "turducken"          , 9000             UNION
  select "turkey"        , "potatoes"           , 2000             UNION
  select "turkey"        , "bread"              , 1500             UNION
  select "tofurky"       , "soup"               , 1200             UNION
  select "chicken"       , "cranberries"        , 2500             UNION
  select "turducken"     , "butter"             , 10000            UNION
  select "turducken"     , "more_butter"        , 15000                 ;

create table pies as
  select "pumpkin" as pie, 500 as calories UNION
  select "apple"         , 400             UNION
  select "chocolate"     , 600             UNION
  select "cherry"        , 550                  ;

CREATE TABLE products as
  SELECT "phone" as category, "uPhone" as name, 99.99 as MSRP, 4.5 as rating UNION
  SELECT "phone"            , "rPhone"        , 79.99        , 3             UNION
  SELECT "phone"            , "qPhone"        , 89.99        , 4             UNION
  SELECT "games"            , "GameStation"   , 299.99       , 3             UNION
  SELECT "games"            , "QBox"          , 399.99       , 3.5           UNION
  SELECT "computer"         , "iBook"         , 112.99       , 4             UNION
  SELECT "computer"         , "wBook"         , 114.29       , 4.4           UNION
  SELECT "computer"         , "kBook"         , 99.99        , 3.8                ;

CREATE TABLE inventory as
  SELECT "Hallmart" as store, "uPhone" as item, 99.99 as price UNION
  SELECT "Targive"          , "uPhone"        , 100.99         UNION
  SELECT "RestBuy"          , "uPhone"        , 89.99          UNION

  SELECT "Hallmart"         , "rPhone"        , 69.99          UNION
  SELECT "Targive"          , "rPhone"        , 79.99          UNION
  SELECT "RestBuy"          , "rPhone"        , 75.99          UNION

  SELECT "Hallmart"         , "qPhone"        , 85.99          UNION
  SELECT "Targive"          , "qPhone"        , 88.98          UNION
  SELECT "RestBuy"          , "qPhone"        , 87.98          UNION

  SELECT "Hallmart"         , "GameStation"   , 298.98         UNION
  SELECT "Targive"          , "GameStation"   , 300.98         UNION
  SELECT "RestBuy"          , "GameStation"   , 310.99         UNION

  SELECT "Hallmart"         , "QBox"          , 399.99         UNION
  SELECT "Targive"          , "QBox"          , 390.98         UNION
  SELECT "RestBuy"          , "QBox"          , 410.98         UNION

  SELECT "Hallmart"         , "iBook"         , 111.99         UNION
  SELECT "Targive"          , "iBook"         , 110.99         UNION
  SELECT "RestBuy"          , "iBook"         , 112.99         UNION

  SELECT "Hallmart"         , "wBook"         , 117.29         UNION
  SELECT "Targive"          , "wBook"         , 119.29         UNION
  SELECT "RestBuy"          , "wBook"         , 114.29         UNION

  SELECT "Hallmart"         , "kBook"         , 95.99          UNION
  SELECT "Targive"          , "kBook"         , 96.99          UNION
  SELECT "RestBuy"          , "kBook"         , 94.99               ;

CREATE TABLE stores as
  SELECT "Hallmart" as store, "50 Lawton Way" as address, 25 as MiBs UNION
  SELECT "Targive"          , "2 Red Circle Way"        , 40         UNION
  SELECT "RestBuy"          , "1 Kiosk Ave"             , 30              ;


