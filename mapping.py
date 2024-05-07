import colorsys
import math


def map_to_thayer(valence, danceability, energy):
    arousal = (danceability + energy) / 2
    pleasure = valence
    return arousal, pleasure

def map_to_color_wheel(arousal, pleasure, energy):
    hue = (arousal + pleasure + energy) / 3
    return hue

def map_to_rgb(hue):
    rgb = colorsys.hsv_to_rgb(hue, 1, 1)
    return [int(x * 255) for x in rgb]

def map_music_to_color(valence, danceability, energy):
    arousal, pleasure = map_to_thayer(valence, danceability, energy)
    hue = map_to_color_wheel(arousal, pleasure,energy)
    rgb = map_to_rgb(hue)
    h, s, v = colorsys.rgb_to_hsv(rgb[0] / 255.0, rgb[1] / 255.0, rgb[2] / 255.0)

# 将HSB颜色值转换为整数形式
    h = int(h * 360)
    return h

def map_to_saturation(data):
    # Assuming the range for valence and energy is from 0 to 1
    # Calculate saturation as a normalized sum of valence and energy
    valence = data['valence']
    energy = data['energy']
    saturation = (valence + energy) / 2 
    return saturation

def calculate_angle(valence, arousal):
    """
    计算给定愉悦度和唤醒度的角度值。

    参数:
    valence -- 愉悦度，范围从0到1。
    arousal -- 唤醒度，范围从0到1。

    返回:
    角度值，范围从0到360度。
    """
    # 将valence和arousal标准化到-1到1
    valence_normalized = 2 * valence - 1
    arousal_normalized = 2 * arousal - 1

    # 使用atan2计算角度的弧度值
    theta = math.atan2(arousal_normalized, valence_normalized)

    # 将弧度转换为角度，并确保角度在0到360度之间
    angle_degrees = (theta * 180 / math.pi) % 360

    return angle_degrees


def map_emotions(angle_degrees):
    """
    根据计算出的角度值映射情感状态。

    参数:
    angle_degrees -- 角度值，范围从0到360度。

    返回:
    情感状态的描述。
    """
    # 根据角度范围映射情感状态
    if 0 <= angle_degrees < 22.5:
        emotion = 'excited'
    elif 22.5 <= angle_degrees < 45:
        emotion = 'delighted'
    elif 45 <= angle_degrees < 67.5:
        emotion = 'enthusiastic'
    elif 67.5 <= angle_degrees < 90:
        emotion = 'inspired'
    elif 90 <= angle_degrees < 112.5:
        emotion = 'angry'
    elif 112.5 <= angle_degrees < 135:
        emotion = 'frustrated'
    elif 135 <= angle_degrees < 157.5:
        emotion = 'annoyed'
    elif 157.5 <= angle_degrees < 180:
        emotion = 'alarmed'
    elif 180 <= angle_degrees < 202.5:
        emotion = 'sad'
    elif 202.5 <= angle_degrees < 225:
        emotion = 'tired'
    elif 225 <= angle_degrees < 247.5:
        emotion = 'bored'
    elif 247.5 <= angle_degrees < 270:
        emotion = 'lonely'
    elif 270 <= angle_degrees < 292.5:
        emotion = 'content'
    elif 292.5 <= angle_degrees < 315:
        emotion = 'calm'
    elif 315 <= angle_degrees < 337.5:
        emotion = 'relaxed'
    elif 337.5 <= angle_degrees < 360:
        emotion = 'peaceful'

    return emotion