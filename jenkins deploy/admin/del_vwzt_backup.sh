#!/bin/bash

DEL_PATH="$1"
if [ ! -n "$DEL_PATH" ]; then
  printf "please input delete backup path! \n"
  exit 0;
fi

printf "delete backup: $DEL_PATH \n"


num=`ls -t $DEL_PATH|wc -l`;
if [ $num -gt 5 ];
then
    num=`expr $num - 5`
    ls -tr $DEL_PATH|head -$num|xargs -i -n1 rm $DEL_PATH/{}
fi

