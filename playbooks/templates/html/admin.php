<?php  

    if(isset($_REQUEST['submit_btn']))
    {
       echo "<div>";
       
$naam = ucfirst($_GET['naam']);
$servername = "localhost";
$username = "webmin";
$password = "Password2@";
$dbname= "myDB";
$n = ($_POST['naam'] );
$k = ($_POST['kleur'] );

	// Create connection
	$conn = new mysqli($servername, $username, $password, $dbname);
	// Check connection
	if ($conn->connect_error) {
	    die("Connection failed: " . $conn->connect_error);
	}

	$sql = "INSERT INTO namen (naam, kleur)
	VALUES ('$n', '$k')";

	if ($conn->query($sql) === TRUE) {
	    echo "geregisteerd";
	    sleep(2);
	} else {
	    echo "Error: " . $sql . "<br>" . $conn->error;
	}
	$conn->close();
	    }

?>

<form action="" method="POST">
<p>Voer je gegevens in: </p>
<p>  Naam <input type="text" name="naam" id="naam" required="required" pattern="[A-za-z]{3,20}" > </p>
<p>  Selecteer je kleur <select name="kleur" required="required"></p>
			<option value="Blauw">Blauw</option>
			<option value="Geel">Geel</option>
			<option value="Rood">Rood</option> 
			
			 </select> </p>
<p>  Ik ga akkoord met de voorwaarden <input type="checkbox" name="check" id="check" required="required" > </p>
			 
   <input type="submit" value="submit" name="submit_btn">

</form>
