 fprintf("-----------------------------Offline Testing----------------------------\n");
    
 fprintf("The number of audio files available for testing are %d \n",nentry);
    
 fprintf("Press ENTER to test and summarize the results");
 pause;
    
 code = sr_trainer(".\Dataset-1\train\",nentry);
    
 sr_tester(".\Dataset-1\test\",nentry,code);
    
 fprintf("-----------------------------Offline Testing Complete!----------------------------\n");