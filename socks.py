import socket
from spotipy.client import Spotify

from spotifyAPI import getBaseColor, getData
from tool.mapping import map_to_saturation, map_to_thayer, calculate_angle, map_emotions

# Spotify API access token
access_token = 'BQBir-wqUU5vParqcdS5Q_ZoZpJNn0SjshvTd6ATFAtbwBjVoqKuOFfzRGCCks8bVOE5h71CqL40aYKmsnugZXvTJENKlPAhbSHOfYc3lJtTCJ5DV-2MYlAVscE5ezo6tPF6RXD_OK-NAP7Hb9VftpYyD94sbbw1-n69LEGd5qQDFaqDgkPKSfSE2G0J8sKKXYgbuugipAo-zRd_INrv46w_uF8w1cqz3qeaxmdViHSqp0bWfSKUKRU3Ps_SC-rwOIv1CT1am7KKznASUt8LKkmB'
track_id = '5BgztqoQ6NHOhNg5yq8SUQ'
#1urmwhtXPiakhcqvqUi3rp brown eyes
#4tBmRW1VtNvDopiEQV6GAz everywhere  we go
#5BgztqoQ6NHOhNg5yq8SUQ I really want to stay at your house
#7AEcphXUR52QGYxdZ8TDVI vogel im kafig
#7KkWs6lt3RoWULV0BbMxpM 恭喜发财

sp = Spotify(auth=access_token)

#color
data = getData(access_token, track_id)
valence = data['valence']
danceability = data['danceability']
energy = data['energy']
baseColor=str(getBaseColor(data))+"1234567890"
saturation=str(map_to_saturation(data))+"1234567890"

#emotion
arousal=str(map_to_thayer(valence, danceability, energy)[0])+"1234567890"
pleasure=str(valence)+"1234567890"
angle=str(calculate_angle(float(valence),float(arousal)))+"1234567890"
print(angle)
emotion=map_emotions(float(angle))+"1234567890"
print(emotion)
# Get track URL
track_info = sp.track(track_id)
track_url = track_info['preview_url']
track_name = track_info['name']+"1234567890"
track_artist = track_info['artists'][0]['name']+"1234567890"
print(track_name)
print(track_artist)
print(track_url)


# Create a socket
s = socket.socket()
host = 'localhost'
port = 12345
s.bind((host, port))

# Send track URL to Processing
s.listen(5)
while True:
    c, addr = s.accept()
    c.send(baseColor.encode())
    c.send(saturation.encode())
    c.send(pleasure.encode())
    c.send(arousal.encode())
    c.send(track_name.encode())
    c.send(track_artist.encode())
    c.send(emotion.encode())
    c.send(angle.encode())
    c.send(track_url.encode())
    c.close()
    