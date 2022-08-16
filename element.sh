#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ $1 ]]
  then
  if [[ ! $1 =~ ^[0-9]+$ ]]
    then
    ELEMENT=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type from properties join elements using(atomic_number) join types using(type_id) where elements.name like '$1%' order by atomic_number limit 1")
      else
    ELEMENT=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type from properties join elements using(atomic_number) join types using(type_id) where elements.atomic_number = $1")
  fi

    if [[ -z $ELEMENT ]]
    then
    echo "I could not find that element in the database."
    else
      echo $ELEMENT | while IFS=\| read ATOMIC_NUMBER ATOMIC_MAS MPC BPC SY NAME TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SY). It's a $TYPE, with a mass of $ATOMIC_MAS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."

      done
    fi
    else
      echo "Please provide an element as an argument." 
fi