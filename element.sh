if [[ -z $1 ]]
then
	echo Please provide an element as an argument.
	exit 0
fi

CANT_FIND_EXIT(){
	echo I could not find that element in the database.
	exit 1
}

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 =~ ^[0-9]+$ ]]
then
	GET_ELEMENT_RESULT="$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number = $1")"
else

	GET_ELEMENT_RESULT="$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE symbol = '$1' OR name= '$1'")"
fi

if [[ -z $GET_ELEMENT_RESULT ]]
then
	# invalid number, prompt and exit
	CANT_FIND_EXIT	
else
	# replace | with a space
	GET_ELEMENT_RESULT=$(echo $GET_ELEMENT_RESULT | sed 's/|/ /g')
	# read values from query result
	read  ATOMIC_NUMBER SYMBOL NAME <<< $GET_ELEMENT_RESULT
	# get properties of the element
	PROPERTY=$($PSQL "SELECT * FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
	# replace | with a space
	PROPERTY=$(echo $PROPERTY | sed 's/|/ /g')
	# read values from query result
	read ATOMIC_NUMBER MASS MELTING BOILING <<< $PROPERTY
	# check if it is correct
	echo $ATOMIC_NUMBER $MASS $MELTING $BOILING
	
fi
