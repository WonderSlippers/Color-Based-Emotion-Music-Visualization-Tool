# Color-Based Music Visualization Tool
This project presents a system that translates audio features of music into visually engaging representations using color and shape. The aim is to enhance the music listening experience by providing a deeper emotional connection through visual cues.

## Prerequisites
Before running the project, ensure you have the following installed:
- Python 3.x
- Spotify Developer Account with API access
- Processing IDE (for visualizing the music)

## Setup
1. Obtain a Spotify API access token by logging into your Spotify for Developers account.
2. Find the Spotify track ID for the song you wish to visualize.

## Running the Project
1. Open `socks.py` and replace the placeholder text with your Spotify API access token.
   ```python
   access_token = 'YOUR_SPOTIFY_ACCESS_TOKEN'
   track_id = 'YOUR_SPOTIFY_TRACK_ID'
Run socks.py to start the server.
Open the MusicVisualizer.pde file in the Processing IDE.
Ensure the MusicVisualizer.pde is configured to connect to the same host and port as specified in socks.py.
Run the MusicVisualizer.pde sketch in Processing to start the visualization.
Libraries and Dependencies
requests: For making HTTP requests in Python.
spotipy: A Python library for the Spotify Web API.
socket: For network communication between Python and Processing.
colorsys: To convert color values in Python.
controlP5: A user interface library for Processing.
minim: An audio library for Processing.
Usage
Once the visualization is running, you can interact with it using the mouse.
Left-click to play/pause the music.
Right-click to stop the music.
Future Work
Explore the impact of cultural differences on music emotion recognition.
Expand the music dataset for improved generalizability.
Develop a personalized user interface for user control over visualization outcomes.
License
This project is licensed under the MIT License.

Acknowledgements
Thanks to the Spotify API for providing access to music data and the Processing community for the minim and controlP5 libraries.