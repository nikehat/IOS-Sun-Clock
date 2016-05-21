=============================INFORMATION==================================
Program:        Sun Clock
Author:         Mikahil Ovchinnikov
Contact info:   mikeovc@csu.fullerton.edu
Class:          CPSC 411
Assignment:     Assignment 6

=============================DESCRIPTION==================================
A twilight/dusk calculator using GPS location finding and Quartz 2D drawing.
The user is allowed to select location using either the provided database or to use GPS location finding to determine his/her coordinates. Once coordinates are found dawn and dusk times are calculated and output to the main screen using both labels and a Quartz 2D drawn 24 hour clock.

This project was made and tailored specifically for the iPhone 6s Plus, and not tested on other devices.

===============================FEATURES===================================
GPS navigation
    - Uses CLGeocoder to find city, state, coordinates, and timezone
    - Updates asynchronously
Cities database
    - Two UITableViews, one to represent states, second to represent cities
    - Updates sunset/sunrise information after selecting a city
24-Hour clock
    - Top of circle represents midnight. Bottom of circle represents noon.
    - Green line to represent current time
    - Yellow lines represent astronomical, nautical, and civil twilight starts and ends
Saved information
    - The application remembers the last location an observation was made by using the NSCoding protocol

==================================BUGS=====================================
CLGeocoder update
    - If a location is selected through the database, then the user requests a new location using GPS, the sunrise/sunset draw representation will briefly flash using default timezone (PST) before the network data from CLGeocoder returns values and a new graphical representation is redrawn.
Locate using GPS without changing location
    - If a user selects "Locate Using GPS", then selects the option again without changing his/her coordinates, GPS will not update, timing out instead. This is because it looks for anything that has either higher accuracy to the previous GPS find, or for a different location.
