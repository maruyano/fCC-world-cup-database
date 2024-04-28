#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games RESTART IDENTITY")

cat games.csv | while IFS=, read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #populate teams table with team names
  #if not already in teams
  if [[ ($($PSQL "SELECT EXISTS(SELECT 1 FROM teams WHERE name='$WINNER')") == f) \
                  && ($WINNER != winner)]]
  then
    echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
  fi

  if [[ ($($PSQL "SELECT EXISTS(SELECT 1 FROM teams WHERE name='$OPPONENT')") == f) \
                  && ($OPPONENT != opponent) ]]
  then
    echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
  fi

  #get the team IDs
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  
  #echo Winner $WINNER $WINNER_ID : Loser $OPPONENT $OPPONENT_ID
  #echo $YEAR $ROUND $WINNER_GOALS to $OPPONENT_GOALS

  #populate 
  echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) \
                VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
done