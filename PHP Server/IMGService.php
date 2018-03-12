<?php
    
    
    //Image sent from app
    //$image = $_FILES['upfile']['tmp_name'];
    $image = $_POST['DATA'];
    //$image = 'testData';
    echo $image;
    
    //Filename index stuff
    $fileIndex = file_get_contents('images/nameIndex.txt');
    echo $fileIndex;
    
    //Put image(str) into file
    $imageName = 'images/';
    $imageName .= $fileIndex;
    file_put_contents($imageName, $image);
    
    //Increment file index
    //$fileIndex += 1;
    echo $fileIndex;
    file_put_contents('images/nameIndex.txt', $fileIndex += 1);
    
?>

