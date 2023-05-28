# Asteroid-health
A health tracker frontend for the data collected by sensorlogd

# Basic usage
Currently the app doesn't expose everything that the logger does.

What the app does:
* show steps data (total steps per day)
* allow turning on and off the step and heartrate tracking

What sensorlogd allows, which isn't used by the app:
* setting custom recording intervals
* display heartrate data (the data is recorded but not displayed)

TODO:
* translations
* recording of other sensors, such as GPS, altimeter or barometer (it's a sensor logger, not just a health tracker)

## Getting your data
It should be obvious from a quick search of this source code that neither the app nor the logger contain any way to leak your data onto the internet. Your data is yours to keep: here's how you can get to it.

Data is stored in plaintext in ~/.asteroid-sensorlogd/ . There are separate directories for each sensor, and within those are separate file for each day.

Each line in a file is a single recording, in the format `[seconds since UNIX epoch]:[value]`.
