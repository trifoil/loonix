#!/bin/bash

# Borrowed from https://askubuntu.com/questions/1705/how-can-i-create-a-select-menu-in-a-shell-script
#               by oToGamez
#               www.pro-toolz.net

      E='echo -e';e='echo -en';trap "R;exit" 2
    ESC=$( $e "\e")
   TPUT(){ $e "\e[${1};${2}H" ;}
  CLEAR(){ $e "\ec";}
  CIVIS(){ $e "\e[?25l";}
   MARK(){ $e "\e[7m";}
 UNMARK(){ $e "\e[27m";}
      R(){ CLEAR ;stty sane;CLEAR;};
   HEAD(){ for each in $(seq 1 15);do
           $E "   \xE2\x94\x82                                          \xE2\x94\x82"
           done
           MARK;TPUT 1 5
           $E "              DESKTOPIFY                  " ;UNMARK;
           TPUT 2 5
           $E "      SELECT A DESKTOP ENVIRONMENT        " ;UNMARK;}
           i=0; CLEAR; CIVIS;NULL=/dev/null
   FOOT(){ MARK;TPUT 15 5
           $E " UP \xE2\x86\x91 \xE2\x86\x93 DOWN    ENTER - SELECT,NEXT       ";UNMARK;}
  ARROW(){ IFS= read -s -n1 key 2>/dev/null >&2
           if [[ $key = $ESC ]];then 
              read -s -n1 key 2>/dev/null >&2;
              if [[ $key = \[ ]]; then
                 read -s -n1 key 2>/dev/null >&2;
                 if [[ $key = A ]]; then echo up;fi
                 if [[ $key = B ]];then echo dn;fi
              fi
           fi
           if [[ "$key" == "$($e \\x0A)" ]];then echo enter;fi;}
     M0(){ TPUT  4 20; $e "Lubuntu";}
     M1(){ TPUT  5 20; $e "Kubuntu";}
     M2(){ TPUT  6 20; $e "Ubuntu";}
     M3(){ TPUT  7 20; $e "Ubuntu-Budgie";}
     M4(){ TPUT  8 20; $e "Ubuntu-Kylin";}
     M5(){ TPUT  9 20; $e "Ubuntu-Mate";}
     M6(){ TPUT 10 20; $e "Ubuntu-Studio";}
     M7(){ TPUT 11 20; $e "Xubuntu";}
     M8(){ TPUT 12 20; $e "EXIT   ";}
      LM=8
   MENU(){ for each in $(seq 0 $LM);do M${each};done;}
    POS(){ if [[ $cur == up ]];then ((i--));fi
           if [[ $cur == dn ]];then ((i++));fi
           if [[ $i -lt 0   ]];then i=$LM;fi
           if [[ $i -gt $LM ]];then i=0;fi;}
REFRESH(){ after=$((i+1)); before=$((i-1))
           if [[ $before -lt 0  ]];then before=$LM;fi
           if [[ $after -gt $LM ]];then after=0;fi
           if [[ $j -lt $i      ]];then UNMARK;M$before;else UNMARK;M$after;fi
           if [[ $after -eq 0 ]] || [ $before -eq $LM ];then
           UNMARK; M$before; M$after;fi;j=$i;UNMARK;M$before;M$after;}
   INIT(){ R;HEAD;FOOT;MENU;}
     SC(){ REFRESH;MARK;$S;$b;cur=`ARROW`;}
     ES(){ MARK;$e "ENTER = main menu ";$b;read;INIT;};INIT
  while [[ "$O" != " " ]]; do case $i in
        0) S=M0;SC;if [[ $cur == enter ]];then R;$e "\n$($e lubuntu)\n";ES;fi;;
        1) S=M1;SC;if [[ $cur == enter ]];then R;$e "\n$($e kubuntu)\n";ES;fi;;
        2) S=M2;SC;if [[ $cur == enter ]];then R;$e "\n$($e ubuntu)\n";ES;fi;;
        3) S=M3;SC;if [[ $cur == enter ]];then R;$e "\n$($e ubuntu-budgie)\n";ES;fi;;
        4) S=M4;SC;if [[ $cur == enter ]];then R;$e "\n$($e ubuntu-kylin)\n";ES;fi;;
        5) S=M5;SC;if [[ $cur == enter ]];then R;$e "\n$($e ubuntu-mate)\n";ES;fi;;
        6) S=M6;SC;if [[ $cur == enter ]];then R;$e "\n$($e ubuntu-studio)\n";ES;fi;;
        7) S=M7;SC;if [[ $cur == enter ]];then R;$e "\n$($e xubuntu)\n";ES;fi;;
        8) S=M8;SC;if [[ $cur == enter ]];then R;exit 0;fi;;
 esac;POS;done
