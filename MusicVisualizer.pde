import processing.net.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.net.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import java.io.*;
import java.net.*;
import controlP5.*;  // Import ControlP5 
Minim minim;
AudioPlayer song;
AudioMetaData metatag;

FFT fft;
// BeatDetect beat;
Client c;
String track_url;
String stream;
int[] frequence;
int[] record;
PFont font_normal, font_bold;
int song_time;
int base_color;
int padding, bar_width, offset;
boolean is_playing;
String song_title, song_author,arousal,pleasure,saturation,angle,emotion;
color color_bg, color_text;
ControlP5 cp5;
Textfield input;
Button submitButton;


//////////////////////////////////////////////////////////////////////////////////////  
void setup() {
  // set window size
  size(1024, 576);  //16:9
   // Connect to Python server
   
   
  c = new Client(this, "localhost", 12345);

  // set main colors
  // color_text = #ffffff;
  color_bg = #222223;
  
  // init font
  // font_normal = loadFont("OpenSans-14.vlw");
  // font_bold   = loadFont("OpenSans-Bold-14.vlw");
  font_normal = createFont("SansSerif", 14);
  font_bold = createFont("SansSerif", 14);
  
  padding = 20;  // space from window borders
  bar_width = 6;  // width of each bar
  rectMode(CORNERS);
  
  // init audio obj
  if (c.available() > 0) {
    // Receive track URL from Python
    stream=c.readString();
    String[]messages=stream.split("1234567890");
    println(stream);
    println(messages);
    base_color = int(messages[0]);
    println();
    println();
    println();
    println("base_color"+base_color);
     saturation=messages[1];
    println("saturation"+saturation);

    pleasure=messages[2];
    println("pleasure:"+pleasure);

    arousal=messages[3];
    println("arousal:"+arousal);

    String title=messages[4];
    println("title"+title);
    String author=messages[5];
    println("author"+author);
    angle=messages[7];
    println("angle"+angle);
    emotion=messages[6];
    println("emotion"+emotion);
    track_url=messages[8];
    println(track_url);
    
    println(base_color);

    // Download the track
    try {
      URL url = new URL(track_url);
      URLConnection conn = url.openConnection();
      InputStream is = conn.getInputStream();
      byte[] bytes = loadBytes(is);
      saveBytes(title+".mp3", bytes);
    } catch (Exception e) {
      println("Error downloading file: " + e.getMessage());
    }
  minim = new Minim(this);
  song = minim.loadFile(title+".mp3", 1024);
  // song.cue( song.length()/3 );  // for debugging, start song from 33%

  fft = new FFT(song.bufferSize(), song.sampleRate());
  fft.linAverages(128);

  // beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  // beat.setSensitivity(15);

  // read metadata
  metatag = song.getMetaData();
  song_title  = title;
  song_author = author;
  
  // handle metadata text overflow
  if (song_author.length() > 25) {
    song_author = song_author.substring(0, 22) + "...";
  }
  if (song_title.length() > 25) {
    song_title = song_title.substring(0, 22) + "...";
  }

  // init frequence-records arrays
  frequence = new int[130];
  record = new int[130];
  for (int i=0; i<130; i++) {
    frequence[i] = 0;
    record[i] = 0;
  }

  // start playing
  songPlay();}
}


//////////////////////////////////////////////////////////////////////////////////////
void draw() {
  
  
  resetScreen();
  
  // perform a Fourier Transform
  fft.forward(song.mix);
  
  // graph color is based on mouseX position and the next 64 gradations
  //base_color = int(map(mouseX, 0, 1024, 0, 296));  // 296 = 360 - 64
  
  // draw graph, 64 bars
  for (int i = 0; i < 64; i++) {
    frequence[i] = int(fft.getAvg(i)) * 6;  // amplify x6
    
    if (frequence[i] > 250) {
      frequence[i] = 250;  // set a max value
    }
    
    if (record[i] < frequence[i]) {
      record[i] = frequence[i];  // update with new record
    } else {
      if (record[i] > 0) {
        record[i] = record[i] - 1;  // decrese record, for "gravity effect"
      }
    }
    
    colorMode(HSB, 360, 100, 100);
    offset = bar_width * i; // how much space the previous bars have occupied
    
    // set current bar color
    // i-th color gradation after base_color
    // fill(base_color+i, int(saturation), 100);
    // stroke(base_color+i, int(saturation), 100);
     fill(base_color+2*i, 80, 100);
    stroke(base_color+2*i, 80, 100);
    
    // draw record line
    line(padding+offset+2, height/2-record[i], padding+offset+bar_width, height/2-record[i]);
    line(width-padding-offset-2, height/2-record[i], width-padding-offset-bar_width, height/2-record[i]);
    
    // draw current bar
    rect(padding+offset+2, (height/2), padding+offset+bar_width, height/2-frequence[i]);
    rect(width-padding-offset-2, (height/2), width-padding-offset-bar_width, height/2-frequence[i]);
    
    // set current reflection color 
    fill(base_color+2*i, float(saturation)*100, 80);
    stroke(base_color+2*i, float(saturation)*100, 80);
    
    // draw reflection record
    line(padding+offset+2, height/2+record[i], padding+offset+bar_width, height/2+record[i]);
    line(width-padding-offset-2, height/2+record[i], width-padding-offset-bar_width, height/2+record[i]);
    
    // draw reflection bar
    rect(padding+offset+2, (height/2), padding+offset+bar_width, height/2+frequence[i]);
    rect(width-padding-offset-2, (height/2), width-padding-offset-bar_width, height/2+frequence[i]);
    
  } // end "draw graph" loop
  
  colorMode(RGB, 256, 256, 256);
  song_time = int(map(song.position(), 0, song.length(), 0, 360));
  
  // circle border
  fill(#666666);
  stroke(#ffffff);
  strokeWeight(2);
  ellipse(width/2, height/2, 200, 200);
  
  // timer arc/pie
  fill(#ffffff);
  stroke(#ffffff);
  strokeWeight(1);
  arc(width/2, height/2, 200, 200, PI+HALF_PI, radians(270+song_time), PIE);

  // cancel the center of timer-pie by drawing over another circle, but smaller
  // and using the background color
  fill(color_bg);
  stroke(color_bg);
  ellipse(width/2, height/2, 185, 185);
  
  // print song title/author/time 
  fill(#ffffff);
  stroke(#ffffff);
  textAlign(CENTER);
    // Display pleasure and arousal
  textFont(font_normal);
  text(convertTime(song.position()), width/2, height/2+80);
    textFont(font_bold);
    text(song_title, width/2, height/2-5);
    text(song_author, width/2, height/2+20);
    text("pleasure:"+pleasure, width/2, height/2 + 150);
    text("arousal:"+arousal, width/2, height/2 + 180);
    

    fill(base_color);
  stroke(base_color);
  textAlign(CENTER);
  textFont(font_normal);
    text("emotion:"+emotion, width/2, height/2 + 210);
    text("angle:"+int(angle)+"°", width/2, height/2 + 240);
    
    
    
}


//////////////////////////////////////////////////////////////////////////////////////
// close app
void stop() {
  song.close();
  minim.stop();
  super.stop();
}

// onClick
// LEFT click = play/pause
// RIGHT click = stop
void mouseClicked() {
  if (mouseButton == LEFT) {
    if (song.isPlaying()){
      songPause();
    } else {
      songPlay();
    }
  } else if (mouseButton == RIGHT) {
    songStop();
  }
}

// clear the screen
void resetScreen() {
  colorMode(RGB, 256, 256, 256);
  background(color_bg);
  fill(#ffffff);
  stroke(#ffffff); 
  textFont(font_normal);
}

void songPlay() {
  song.play();
  is_playing = true;
}

void songPause() {
  song.pause();
  is_playing = false;
}

void songStop() {
  song.pause();
  song.rewind();
  is_playing = false;
}

void songRestart() {
  song.pause();
  song.rewind();
  song.play();
  is_playing = true;
}
// void submitSongName() {
//   String songName = input.getText();
//   if (c.active()) {
//     c.write(songName);
//   }
// }
// convert milliseconds into mm:ss format
String convertTime(int ms) {
  int minutes, seconds;
  minutes = 0;
  seconds = 0;

  ms = ms / 1000;
  minutes = int(ms/60);
  seconds = ms % 60;

  if (seconds < 10) {
    return minutes + ":0" + seconds;
  } else {
    return minutes + ":" + seconds;
  }
}
