<?php
    //This is the SQL statement to be run
    $sql = $_POST['DATA'];
    
    //Create connection (IP Address, databaseUser, userPassword, databaseName)
    $con = mysqli_connect("127.0.0.1","dbuser","Monday100!","hibuy");
    
    //Check if can connect
    if (mysqli_connect_errno()) {
        echo "Failed to connect to server with error: " . mysqli_connect_error();
    }
    
    //Check if there are results
    if ($result = mysqli_query($con, $sql)) {
        //Create a results array
        $resultArray = array();
        
        //Loop through each row in the result set
        while($row = $result->fetch_object()) {
            //Add each row into the results array
            array_push($resultArray, $row);
        }
        
        //Encode the array to JSON and output the results
        echo json_encode($resultArray);
    }
    
    //Close connection
    mysqli_close($con);
?>
