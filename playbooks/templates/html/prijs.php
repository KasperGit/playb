<html>
<body>

<p style="text-align:center">
<a href="index.php"> <img src="hoofdpage.jpg"  alt ="Sqills" width = "200" height = "100">
</a>
</p>

<?php  
$slaap=$_GET['sleep'];

$naam = ucfirst($_GET['naam']);
$servername = "localhost";
$username = "website";
$password = "password1";
$dbname= "myDB";



$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
$sql1 = "SELECT id, naam, kleur FROM namen WHERE naam='$naam' ";
$result = $conn->query($sql1);
if ($result->num_rows > 0) {
    while($row1 = $result->fetch_assoc()) {
	$ID = $row1["id"];
	$name= $row1["naam"]; }
} else {
    echo "<p> 0 results  voor namen</p> ";
}
$conn->close();

// $sql2 lot nummer check
$conn = new mysqli($servername, $username, $password, $dbname);
$sql2 = "SELECT lot, nummer FROM prijzen WHERE nummer='$ID' ";
$result = $conn->query($sql2);

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
$lotnr = $row["lot"];
$prodID =$row["nummer"];
    }
} else {
    echo "<p> Je hebt geen loten</p> ";
}
$conn->close();

// $sql lot nummer check
$conn = new mysqli($servername, $username, $password, $dbname);
$sql3 = "SELECT product FROM producten WHERE lot='$prodID' ";
$result = $conn->query($sql3);

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
	$prijs = $row["product"];
	$antwoord = "gewonnen, Hartelijk gefeliciteerd" ;
    }
} else {
    $prijs="beetje pech. Je hebt helaas geen prijs ";
    $antwoord = "gewonnen, Volgende keer beter" ;
}
$conn->close();

//website teksten:
print (" 
<h1>welkom </h1>"
. $name . 
" je lot nummer is " 
. $lotnr . 
" met dit lot heb je een " 
. $prijs . 
$antwoord
)
?> 
</body>
</html>