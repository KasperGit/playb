<html>
 

<body>
<p style="text-align:center">
<a href="index.php"> <img src="hoofdpage.jpg"  alt ="Sqills" width = "200" height = "100">
</a>
</p>
<h2>
Welkom op de website
</h2>
Deze website is bedoeld als test voor Varnish. Verder is hier niets te doen.

<h3>
Check nu je prijs:
</h3>
<form action=prijs.php method="GET">
<p>Wat is je naam? <select name="naam">
<?php

$servername = "localhost";
$username = "website";
$password = "password1";
$dbname= "myDB";
	$conn = new mysqli($servername, $username, $password, $dbname);

		if ($conn->connect_error) {
		    die("Connection failed: " . $conn->connect_error);
		}

		$sql = "SELECT naam FROM namen";
		$result = $conn->query($sql);

		if ($result->num_rows > 0) {
		    // output data of each row
		    echo "<table> ";
		    while($row = $result->fetch_assoc()) {
		     $name=$row['naam'];
				print ("<p> <option value= \"" .  $name  . "\"> " . $name . " </option> </p> ");
			}
			echo "</table> ";
			} else {
		    print "<p> er is iets fout gegaan met de namen</p>" ;
		}
		$conn->close(); ?>
		
			<option value='nvt'>Anders</option>
			</select> </p>
<input type='submit' value='Send'><input type='reset' 'value='clear'>

</form>

</body>

</html>
