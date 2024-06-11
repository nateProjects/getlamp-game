
 10 REM ** INIT VARIABLES **
 15 REM LOCATION DESCRIPTION (LD), LOCATION (L)
 20 DIM LD$ ( 4 ) : DIM LE ( 4, 4 ) 
 25 L=1 
 30 DATA "an empty office. There is a door south and a locked door east.","the stock room. There is a door north."
 32 DATA "a dark room. You cannot see a thing.","the world outside." 
 40 FOR I=1 TO 4
 42 READ LD$ ( I ) 
 44 NEXT I
 46 REM LOCATION EXITS (LE)
 50 REM N(1),S(2),E(3),W(4)
 51 DATA 0,2,0,0
 52 DATA 1,0,0,0
 54 DATA 0,0,0,1
 56 DATA 3,0,0,0
 58 FOR I=1 TO 4
 60 FOR J=1 TO 4
 62 READ LE ( I, J )
 64 NEXT J
 66 NEXT I
 70 REM OBJECTS OBJ COUNT (OC), OBJ DESCRIPTION (OD$), OBJ LOCATION (OL) OL=0=PLAYER
 72 OC = 2 : DIM OD$ ( OC ) : DIM OL ( OC )
 74 DATA 1, "a lamp", 2, "a key"
 76 FOR I=1 TO OC
 78 READ OL ( I ) : READ OD$ ( I )
 80 NEXT I
 85 REM ** START GAME **
 90 HOME
 95 PRINT "   *** GET LAMP - A (SHORT) TEXT ADVENTURE ***"
 96 FOR I=1 TO 20 : PRINT "" : NEXT
 100 REM ** MAIN LOOP **
 102 HGR
 105 PRINT ""
 110 PRINT "You are in " ;LD$( L )
 112 GOSUB 1900 : REM DRAW ROOM 
 115 GOSUB 1100 : REM DISPLAY OBJECTS
 117 GOSUB 1930 : REM DRAW OBJECTS
 120 INPUT "> " ;IN$
 130 OK = 0
 140 IF LEFT$ ( IN$, 2 ) = "GO" THEN OK = 1 : GOSUB 1000 : REM GO COMMAND
 150 IF LEFT$ ( IN$, 3 ) = "INV" THEN OK = 1 : GOSUB 1200 : REM INVENTORY COMMAND
 152 IF LEFT$ ( IN$, 4 ) = "TAKE" OR LEFT$ ( IN$, 3 ) = "GET" THEN OK = 1 : GOSUB 1300 : REM TAKE COMMAND
 154 IF LEFT$ ( IN$, 4 ) = "DROP" THEN OK = 1 : GOSUB 1400 : REM DROP COMMAND
 156 IF IN$ = "LIGHT LAMP" THEN OK = 1 : GOSUB 1600 : REM LIGHT LAMP COMMAND
 158 IF IN$ = "UNLOCK DOOR" OR IN$ = "OPEN DOOR" THEN OK = 1 : GOSUB 1700 : REM UNLOCK DOOR COMMAND
 160 IF IN$ = "HELP" THEN OK = 1 : GOSUB 1800 : REM HELP COMMAND
 170 IF OK = 0 THEN PRINT "What?" : GOSUB 900 : REM PRESS RETURN
 200 REM CONTINUE GAME?
 210 IF L <> 4 GOTO 100
 215 HGR : GOSUB 1920 : REM DRAW WORLD OUTSIDE
 220 PRINT "You are in " ;LD$( L )
 230 FLASH : PRINT "CONGRATULATIONS, YOU HAVE WON THE GAME!" : NORMAL
 250 END
 900 REM *** PRESS RETURN TO CONTINUE SUBROUTINE ***
 902 INVERSE
 905 INPUT "PRESS <RETURN>" ;K$
 907 NORMAL
 910 RETURN
 1000 REM *** GO COMMAND SUBROUTINE ***
 1030 BUF=L
 1040 IF LEFT$ ( IN$, 2 ) = "GO" AND RIGHT$ ( IN$, 5 ) = "NORTH" THEN L=LE ( L, 1 )
 1042 IF LEFT$ ( IN$, 2 ) = "GO" AND RIGHT$ ( IN$, 5 ) = "SOUTH" THEN L=LE ( L, 2 )
 1044 IF LEFT$ ( IN$, 2 ) = "GO" AND RIGHT$ ( IN$, 4 ) = "EAST" THEN L=LE ( L, 3 )
 1046 IF LEFT$ ( IN$, 2 ) = "GO" AND RIGHT$ ( IN$, 4 ) = "WEST" THEN L=LE ( L, 4 )
 1048 IF L = 0 THEN L=BUF : PRINT "You cannot go in that direction." : GOSUB 900 : REM PRESS RETURN
 1090 RETURN
 1100 REM *** DISPLAY OBJECTS SUBROUTINE ***
 1110 FOR I=1 TO OC
 1112 IF OL ( I ) = L THEN PRINT "You see " ;OD$ ( I ) ;". " ;
 1130 NEXT I : PRINT ""
 1150 RETURN
 1200 REM *** INVENTORY COMMAND SUBROUTINE ***
 1210 PRINT "You are carrying: " ;
 1215 J = 0
 1220 FOR I=1 TO OC
 1230 IF OL ( I ) = 0 THEN PRINT " " ;OD$ ( I ) ;" ;"  ;: J = J + 1
 1240 NEXT I : IF J = 0 THEN PRINT "nothing." ;
 1243 PRINT "" 
 1245 GOSUB 900 : REM PRESS RETURN
 1250 RETURN
 1300 REM *** TAKE COMMAND SUBROUTINE ***
 1305 GOSUB 1500 : REM IDENTIFY OBJECT
 1310 IF OL ( OBJ ) = L THEN OL ( OBJ ) = 0 : PRINT "You have picked up " ;OD$ ( OBJ ) : GOSUB 900 : RETURN
 1380 PRINT "You don't see that object in here." : REM Either we do not know this object or it is not here
 1385 GOSUB 900 : REM PRESS RETURN
 1390 RETURN
 1400 REM *** DROP COMMAND SUBROUTINE ***
 1405 GOSUB 1500 : REM IDENTIFY OBJECT
 1410 IF OL ( OBJ ) = 0 THEN OL ( OBJ ) = L : PRINT "You have dropped " ;OD$ ( OBJ ) : GOSUB 900 : RETURN
 1480 PRINT "You don't have that object." : REM Either we do not know this object or you do not have it
 1485 GOSUB 900 : REM PRESS RETURN
 1490 RETURN
 1500 REM *** IDENTIFY OBJECT SUBROUTINE ***
 1510 OBJ = 0
 1520 IF RIGHT$ ( IN$, 4 ) = "LAMP" THEN OBJ=1
 1530 IF RIGHT$ ( IN$, 3 ) = "KEY" THEN OBJ=2
 1550 RETURN
 1600 REM *** LIGHT LAMP COMMAND SUBROUTINE ***
 1610 IF OL ( 1 ) <> 0 THEN PRINT "You don't have a lamp." : RETURN
 1615 REM update map and object state
 1620 OD$ ( 1 ) = "a lit lamp" : LE ( 3, 2 ) = 4 : LE ( 3, 4 ) = 1 : LD$ ( 3 ) = "an empty room. You see doors leading west and south."
 1630 PRINT "Now you have a lit lamp."
 1635 GOSUB 900 : REM PRESS RETURN
 1650 RETURN
 1700 REM *** UNLOCK DOOR COMMAND SUBROUTINE ***
 1710 IF L <> 1 THEN PRINT "There is no door to unlock here." : RETURN
 1720 IF L = 1 AND LE ( 1, 3 ) = 3 THEN PRINT "The door is already unlocked." : RETURN
 1730 IF OL ( 2 ) <> 0 THEN PRINT "With what?" : RETURN
 1740 LD$ ( 1 ) = "an empty office. There are doors south and east." : LE ( 1, 3 ) = 3
 1750 PRINT "You have unlocked the door."
 1755 GOSUB 900 : REM PRESS RETURN
 1790 RETURN
 1800 REM *** HELP COMMAND SUBROUTINE ***
 1810 PRINT "Try some of the following commands: GO, TAKE, DROP, INVENTORY, LIGHT, UNLOCK, OPEN"
 1815 GOSUB 900 : REM PRESS RETURN
 1890 RETURN
 1900 REM *** DRAW LOCATION SUBROUTINE ***
 1905 IF L > 3 THEN GOTO 1930
 1910 IF L < 3 THEN GOTO 1915
 1912 IF OD$ ( 1 ) = "a lamp" THEN GOTO 1919
 1915 GOSUB 1940 : REM DRAW ROOM
 1916 IF L = 1 THEN GOSUB 1950 : REM DRAW DESK
 1917 IF L = 2 THEN GOSUB 1960 : REM DRAW SHELVES
 1919 RETURN
 1920 REM *** DRAW WORLD OUTSIDE SUBROUTINE ***
 1921 HCOLOR= 6 : FOR I = 1 TO 110 : HPLOT 1, I TO 279, I : NEXT I
 1922 HCOLOR= 1 : FOR I = 111 TO 159 : HPLOT 1, I TO 279, I : NEXT I
 1923 HCOLOR= 7
 1924 FOR I = 1 TO 9
 1925 LET R = I : LET CX = 130 : LET CY = 60 : GOSUB 2200 : REM DRAW CIRCLE
 1926 NEXT I 
 1929 RETURN
 1930 REM *** DRAW OBJECTS SUBROUTINE ***
 1934 IF OL ( 1 ) = L THEN GOSUB 1970: REM DRAW LAMP
 1936 IF OL ( 2 ) = L THEN GOSUB 1990 : REM DRAW KEY
 1939 RETURN
 1940 REM *** DRAW ROOM SUBROUTINE ***
 1941 HCOLOR= 3
 1942 HPLOT 50,110 TO 230,110
 1943 HPLOT 50,110 TO 1,160
 1944 HPLOT 230,110 TO 279,160
 1945 HPLOT 51,1 TO 51,110
 1946 HPLOT 229,1 TO 229,110
 1945 RETURN 
 1950 REM *** DRAW DESK SUBROUTINE ***
 1952 HCOLOR= 5
 1953 HPLOT 131,90 TO 169,90
 1954 HPLOT 131,80 TO 169,80
 1955 HPLOT 131,80 TO 131,110
 1956 HPLOT 169,80 TO 169,110
 1957 LET R = 3 : LET CX = 151 : LET CY = 86
 1958 GOSUB 2200 : REM DRAW CIRCLE
 1959 RETURN 
 1960 REM *** DRAW SHELVES SUBROUTINE ***
 1961 HCOLOR= 5
 1962 HPLOT 71,90 TO 109,90
 1963 HPLOT 71,80 TO 109,80
 1964 HPLOT 71,70 TO 109,70
 1965 HPLOT 71,60 TO 109,60
 1966 HPLOT 71,60 TO 71,110
 1967 HPLOT 109,60 TO 109,110
 1969 RETURN 
 1970 REM *** DRAW LAMP SUBROUTINE ***
 1972 HCOLOR= 7 : LET R = 7 : LET CX = 90 : LET CY = 130 : GOSUB 2200 : REM DRAW CIRCLE
 1974 HPLOT 85,137 TO 94,137
 1976 HPLOT 85,137 TO 86,132
 1978 HPLOT 94,137 TO 93,132
 1980 HPLOT 85,120 TO 94,120
 1982 HPLOT 85,120 TO 86,124
 1984 HPLOT 94,120 TO 93,124
 1989 RETURN 
 1990 REM *** DRAW KEY SUBROUTINE ***
 1992 HCOLOR= 7 : LET R = 3 : LET CX = 160 : LET CY = 120 : GOSUB 2200 : REM DRAW CIRCLE
 1993 HPLOT 160,119 TO 150,119
 1994 HPLOT 150,119 TO 150,121
 1999 RETURN 
 2200 REM *** DRAW CIRCLE (CX,CY,R) SUBROUTINE ***
 2210 IF ( R < 1 OR R > 96 ) THEN RETURN
 2215 LET R2 = R * R : K = 0.618
 2240 LET SX =  INT ( CX ) - 0.5
 2250 LET SY =  INT ( CY ) - 0.5
 2260 FOR X = 0 TO R
 2270 LET Y =  SQR ( R2 - X * X )
 2275 IF Y < X - 1 THEN  RETURN 
 2280 HPLOT SX + X, Y * K + SY
 2281 HPLOT SX - X, Y * K + SY
 2282 HPLOT SX + X, - Y * K + SY
 2283 HPLOT SX - X, - Y * K + SY
 2285 HPLOT SX + Y, X * K + SY
 2286 HPLOT SX - Y, X * K + SY
 2287 HPLOT SX + Y, - X * K + SY
 2288 HPLOT SX - Y, - X * K + SY
 2290 NEXT 
 2295 RETURN
 