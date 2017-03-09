// On a remote server, this script receives URL requests from the app to access a MySQL database.

<?php
// Getting database login
$host = "localhost"; //Your database host server
$db = "db"; //Your database name
$user = "u"; //Your database user
$pass = "p"; //Your password
if (isset ($_GET["method"])) {
	$method = $_GET["method"];
	
	if ($method == "checkUpdates") {
		$checkUpdates = true;
	}
	if ($method == "getUpdates") {
		$getUpdates = true;
	}
	if ($method == "updateMonologue") {
		$updateMonologue = true;
	}
	if ($method == "getAllMonologues") {
		$getAllMonologues = true;
	}
}
// Create connection
$connection = mysql_connect($host, $user, $pass);
//Check to see if we can connect to the server
	if(!$connection)
	{
		die("Database server connection failed.");	
	}
	else
	{
		//Attempt to select the database
		$dbconnect = mysql_select_db($db, $connection);
		
		//Check to see if we could select the database
		if(!$dbconnect)
		{
			die("Unable to connect to the specified database!");
		}
		else
		{
			if ($getAllMonologues == true ) {
				$query = "SELECT * FROM monologues";
				$resultset = mysql_query($query, $connection);
			
				$records = array();
			
				//Loop through all our records and add them to our array
				while($r = mysql_fetch_assoc($resultset))
				{
					$records[] = $r;		
				}
			
				//Output the data as JSON
				echo json_encode($records);
			}
			if ($checkUpdates == true ) {
				// get number of updates
				$result = mysql_query("SELECT * FROM updates");
				$num_rows = 0;
				$num_rows = mysql_num_rows($result);
				echo "{$num_rows}";
			}
			if ($getUpdates == true ) {
				$query = "SELECT * FROM updates";
				$resultset = mysql_query($query, $connection);
			
				$records = array();
			
				//Loop through all our records and add them to our array
				while($r = mysql_fetch_assoc($resultset))
				{
					$records[] = $r;		
				}
			
				//Output the data as JSON
				echo json_encode($records);
			}
			if ($updateMonologue == true ) {
				$body = file_get_contents('php://input');
				echo("body is" . $body . ".\r");
				$monologue = json_decode($body);
				if (json_last_error() === JSON_ERROR_NONE) { 
				
					$id = $monologue->{"id"};
					$uuid = $monologue->{"id"};
					$age = $monologue->{"age"};
					$authorFirst = $monologue->{"authorFirst"};
					$authorLast = $monologue->{"authorLast"};
					$character = $monologue->{"character"};
					$gender = $monologue->{"gender"};
					$length = $monologue->{"length"};
					$notes = $monologue->{"notes"};
					$period = $monologue->{"period"};
					$text = $monologue->{"text"};
					$title = $monologue->{"title"};
					$tags = $monologue->{"tags"};
					$tone = $monologue->{"tone"};
				
					$query = "INSERT INTO updates (
 `id` ,
 `uuid` ,
 `age` ,
 `authorFirst` ,
 `authorLast` ,
 `character` ,
 `gender` ,
 `length` ,
 `notes` ,
 `period` ,
 `text` ,
 `title` ,
 `tags` ,
 `tone`
)
VALUES ('$id', '$uuid', '$age', '$authorFirst', '$authorLast', '$character', '$gender', '$length', '$notes', '$period', '$text', '$title', '$tags', '$tone')
ON DUPLICATE KEY UPDATE `uuid`='$uuid', `age`='$age', `authorFirst`='$authorFirst', `authorLast`='$authorLast', `character`='$character', `gender`='$gender', `length`='$length', `notes`='$notes', `period`='$period', `text`='$text', `title`='$title', `tags`='$tags', `tone`='$tone';";
					$result = mysql_query($query);
					if (!$result) {
						echo "Error!";
						trigger_error('Invalid query: ' . mysql_error());
					} else {
    						echo "New record created successfully";
					}
				} else { 
    					echo("this isn't even JSON\r");
				} 
				
			}
		}
	}
mysql_close($connection);
?>
