import requests

from mapping import map_music_to_color

def getData(token, track_id):
    url = f'https://api.spotify.com/v1/audio-features/{track_id}'
    headers = {
        'Authorization': f'Bearer {token}'
    }

    # 发送API请求并获取返回的JSON数据
    response = requests.get(url, headers=headers)
    data = response.json()
    
    # 打印歌曲的feature
    if response.status_code == 200:
        print('Danceability:', data['danceability'])
        print('Energy:', data['energy'])
        print('Speechiness:', data['speechiness'])
        print('Acousticness:', data['acousticness'])
        print('Instrumentalness:', data['instrumentalness'])
        print('Liveness:', data['liveness'])
        print('Valence:', data['valence'])

        return data
    else:
        print('Error:', data['error']['message'])

def getBaseColor(data):
    valence = data['valence']
    danceability = data['danceability']
    energy = data['energy']
    return map_music_to_color(valence,danceability,energy)