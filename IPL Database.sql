Create Database IPL;
Use IPL;

Create Table Ball_by_Ball
(
	Match_Id integer,
    Innings_Id integer,
    Over_Id integer,
    Ball_Id integer,
    Team_Batting_Id integer,
    Team_Bowling_Id integer,
    Striker_Id integer,
    Striker_Batting_Position integer,
    Non_Striker_Id integer,
    Bowler_Id integer,
    Batsman_Scored integer,
    Extra_Type varchar(30),
    Extra_Runs integer,
    Player_Dismissal_Id integer,
    Dismissal_Type varchar(30),
    Fielder_Id integer
);

Create Table Matches
(
	Match_Id integer PRIMARY KEY,
    Team_Name_Id integer,
    Opponent_Team_Id integer,
    Season_Id integer,
    Venue_Name varchar(200),
    Toss_Winner_Id integer,
    Toss_Decision varchar(15),
    Is_Superover integer,
    Is_Result integer,
    Is_DuckWorthLewis integer,
    Win_Type varchar(30),
    Won_By integer,
    Match_Winner_Id integer,
    Man_Of_The_Match_Id integer,
    First_Umpire_Id integer,
    Second_Umpire_Id integer,
    City_Name varchar(200),
    Host_Country varchar(50)
);

Create Table Player
(
	Player_Id integer PRIMARY KEY,
    Player_Name varchar(100),
    Batting_Hand varchar(30),
    Bowling_Skill varchar(50),
    Country varchar(50),
    Is_Umpire integer	
);

Create Table Player_Match
(
	Match_Id integer,
    Player_Id integer,
    Team_Id integer,
    Is_Keeper integer,
    Is_Captain integer
);

Create Table Season
(
	Season_Id integer PRIMARY KEY,
    Season_Year integer,
    Orange_Cap_Id integer,
    Purple_Cap_Id integer,
    Man_Of_The_Series_Id integer
);

Create Table Team
(
	Team_Id integer PRIMARY KEY,
    Team_Name varchar(60),
    Team_Short_Code varchar(4)
);

Insert into Player Values ("0","NULL","NULL","NULL","NULL","0");
Select * from player;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM Ball_by_Ball
 WHERE Match_Id NOT IN (SELECT M.Match_Id 
                        FROM Matches M);
SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM Player_Match
 WHERE Match_Id NOT IN (SELECT M.Match_Id 
                        FROM Matches M);
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE Ball_by_Ball
ADD FOREIGN KEY (Striker_Id) REFERENCES Player(Player_Id);
ALTER TABLE Ball_by_Ball
ADD FOREIGN KEY (Match_Id) REFERENCES Matches(Match_Id);
ALTER TABLE Ball_by_Ball
ADD FOREIGN KEY (Striker_Id) REFERENCES Player(Player_Id);
ALTER TABLE Ball_by_Ball
ADD FOREIGN KEY (Non_Striker_Id) REFERENCES Player(Player_Id);
ALTER TABLE Ball_by_Ball
ADD FOREIGN KEY (Bowler_Id) REFERENCES Player(Player_Id);
ALTER TABLE Ball_by_Ball
ADD FOREIGN KEY (Fielder_Id) REFERENCES Player(Player_Id);
ALTER TABLE Ball_by_Ball
ADD FOREIGN KEY (Player_Dismissal_Id) REFERENCES Player(Player_Id);
ALTER TABLE Ball_by_Ball
ADD FOREIGN KEY (Team_Batting_Id) REFERENCES Team(Team_Id);
ALTER TABLE Ball_by_Ball
ADD FOREIGN KEY (Team_Bowling_Id) REFERENCES Team(Team_Id);


ALTER TABLE Matches
ADD FOREIGN KEY (Second_Umpire_Id) REFERENCES Player(Player_Id);
ALTER TABLE Matches
ADD FOREIGN KEY (Team_Name_Id) REFERENCES Team(Team_Id);
ALTER TABLE Matches
ADD FOREIGN KEY (Opponent_team_Id) REFERENCES Team(Team_Id);
ALTER TABLE Matches
ADD FOREIGN KEY (Toss_Winner_Id) REFERENCES Team(Team_Id);
ALTER TABLE Matches
ADD FOREIGN KEY (Match_Winner_Id) REFERENCES Team(Team_Id);
ALTER TABLE Matches
ADD FOREIGN KEY (Man_Of_The_Match_Id) REFERENCES Player(Player_Id);
ALTER TABLE Matches
ADD FOREIGN KEY (First_Umpire_Id) REFERENCES Player(Player_Id);
ALTER TABLE Matches
ADD FOREIGN KEY (Second_Umpire_Id) REFERENCES Player(Player_Id);
ALTER TABLE Matches
ADD FOREIGN KEY (Season_Id) REFERENCES Season(Season_Id);


ALTER TABLE Season
ADD FOREIGN KEY (Orange_Cap_Id) REFERENCES Player(Player_Id);
ALTER TABLE Season
ADD FOREIGN KEY (Purple_Cap_Id) REFERENCES Player(Player_Id);
ALTER TABLE Season
ADD FOREIGN KEY (Man_Of_The_Series_Id) REFERENCES Player(Player_Id);


ALTER TABLE Player_Match
ADD FOREIGN KEY (Match_Id) REFERENCES Matches(Match_Id);
ALTER TABLE Player_Match
ADD FOREIGN KEY (Player_Id) REFERENCES Player(Player_Id);
ALTER TABLE Player_Match
ADD FOREIGN KEY (Team_Id) REFERENCES Team(Team_Id);


Select * from Season;
Select * from Team;






Select distinct player_name from player;
Select player_name, sum(batsman_scored) as Score 
from ball_by_ball, player 
where ball_by_ball.striker_id=player.player_id 
group by striker_id, match_id;

Select player_name as Player, sum(batsman_scored) as Runs 
from player, ball_by_ball 
where ball_by_ball.striker_id=player.player_id 
group by striker_id, match_id 
having sum(batsman_scored)>=100 ;

Create view maxscore as
Select player_name as Player, sum(batsman_scored) as Runs
from player, ball_by_ball
where ball_by_ball.striker_id=player.player_id
group by striker_id, match_id;
Select Player, max(Runs) as Highest_Score 
from maxscore 
group by Player;
Select Player, max(Runs) as Highest_Score 
from maxscore 
group by Player 
having Player like "%dhoni";

Select bowler_id,ball_id as b
from ball_by_ball 
where player_dismissal_id>0 and dismissal_type !="run out" 
group by over_id, innings_id, match_id;

Create view maxmatch as 
Select player_name as Player,count(player_match.player_id) as No_of_Matches 
from player,player_match 
where player_match.player_id=player.player_id 
group by player_match.player_id;
Select Player , No_of_Matches 
from maxmatch 
where No_of_Matches=(SELECT max(No_of_Matches) FROM maxmatch);
Select * 
from maxmatch 
where Player like "%gayle";




Select Host_Country, count(*) as Matches_Hosted 
from matches 
group by Host_country;

Select Country, count(*) as No_of_Players 
from player 
group by Country;

Select distinct player_name AS Opening_Batsmen
from player, ball_by_ball, team 
where over_id=1 and ball_id=1 and team.team_id=ball_by_ball.Team_Batting_Id and
(player.player_id=ball_by_ball.striker_id or player.player_id=ball_by_ball.non_striker_id) 
and team_name="Chennai Super Kings";
      
Select Team_Name, count(distinct player_id) as No_of_Players
from player_match, team 
where team.team_id=player_match.team_id 
group by player_match.team_id;

Select Win_Type, count(*) as No_of_Wins 
from matches 
group by Win_Type;

Select T1.team_name as Winning_Team, max(won_by) as Max_victory_by_runs, "Against", T2.team_name as Losing_Team
from matches, team T1, team T2
where win_type="by runs" and T1.team_id=matches.team_name_id and T2.team_id=matches.Opponent_team_id;

Select Batting_Hand, count(*) as No_of_Players 
from player where batting_hand is not null 
group by Batting_Hand;

Select player_name as Player,count(player_dismissal_id) as Wickets 
from ball_by_ball, player 
where ball_by_ball.bowler_id=player.player_id and player_dismissal_id>0 
group by ball_by_ball.bowler_id 
order by wickets desc
Limit 50;

Select player_name as Player, count(man_of_the_match_id) as MOTM 
from player, matches
where player.player_id=matches.man_of_the_match_id 
group by man_of_the_match_id
having MOTM>1
order by MOTM desc;










