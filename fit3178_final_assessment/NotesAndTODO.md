# TODO for final stretch
## GOAL IS 70% -- DON'T OVERWORK YOURSELF

- Check to make sure weekday notification works -X
    +> weekday component for date doesn't start with 0 (Monday is 2)
    +> Changed in WeekDates and NotificationHandler
- Get the active exercise screen working - next 2 
    - count down and changing set is now working
    +> Need to work on allowing user to choose the interval to change set/workout
        -> Change database structure
    +> Set up notification
    +> Set up finish workout screens
- Implement editing existing workouts - currently working on
    +> Cant reuse create workout scence because that thing is hooked for creating not editing
    +> Create a new thang
- importing exercise from other user
- voice notes (optional)
- Incrementing difficulty after time 
- Geofence notification (optional)
- Restructuring database so that firebase and coredata store different thing - HIGH PRIORITY - this next
    +> Still need to store data locally so in case of no network connection 
            -> redesign the syncing code to not always clear coredata first
    +> First idea is to have coredata store UserDefaults or some device specific customization
    +> Get images working
- Clean up the UI
- Cleaning up code part 1
- Cleaning up and documenting code part 2

Other things to fix:
    Home screen should show username
    Try to get the 'next' marked one done on Saturday if possible, extended to Sunday if stresseds
    Syncing now working



FUCK FUCK FUCK THE TIMER DOESN'T WORK IF YOU PUT THE THING IN BACK GROUND
- time stamp when app entered foreground 
- when app re-emerge update the manager

- implement a time skip function
+ invalidate current timer
+ calculate time diff app quit to re enter foreground
+ calculate how many exercise to skip
+ recalculate indexing for set and exercise
+ create new timer and continue

schedule ahead of time for next set

To do in order to finish our MVP: Voice note, store on CoreData
THATS ITS
