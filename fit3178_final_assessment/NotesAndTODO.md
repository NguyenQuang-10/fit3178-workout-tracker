# TODO for final stretch
## GOAL IS 70% -- DON'T OVERWORK YOURSELF

- Check to make sure weekday notification works -X
    +> weekday component for date doesn't start with 0 (Monday is 2)
    +> Changed in WeekDates and NotificationHandler
- Get the active exercise screen working
- Implement editing existing workouts
- importing exercise from other user
- voice notes (optional)
- Incrementing difficulty after time
- Geofence notification (optional)
- Restructuring database so that firebase and coredata store different thing
    +> Still need to store data locally so in case of no network connection 
            -> redesign the syncing code to not always clear coredata first
    +> First idea is to have coredata store UserDefaults or some device specific customization
    +> Get images working
- Clean up the UI
- Cleaning up code part 1
- Cleaning up and documenting code part 2



