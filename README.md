## broadcast

a norns mod to create a public mp3 stream from your norns.

![broadcast](https://user-images.githubusercontent.com/6550035/148649812-feafa0f0-4512-42da-8cf6-16790ac77c2c.png)


broadcast is a simple mod that lets you make a dedicated music stream from your norns. the output is a public URL of an mp3 that can be listened to in a browser, in music apps, etc.

broadcast works by using [`darkice`](http://www.darkice.org/) and [`icecast2`](https://icecast.org/) which interface with JACK and convert the norns output into a mp3 stream (which is [configurable](https://github.com/schollz/broadcast/blob/main/darkice.cfg#L18)). this local stream is then streamed via `curl` to a server I setup at `streamyouraudio.com`. [the server](https://github.com/schollz/broadcast-server) is ~200 lines of code that simply copy bytes from a POST request (i.e. the stream) to any number of GET requests (i.e. browser client(s)).


broadcast will install ~2.5 MB of linux packages when you run it the first time and while running will take a small amount of CPU to run the stream conversion, and use some internet bandwidth to upload the stream.

### Requirements

- norns
- internet connection

### Documentation

you can install *broadcast* and then activate the mod in the `SYSTEM > MODS > BROADCAST`. after activating for the first time you need to restart `SYSTEM > RESTART`. (this first restart may take a few minutes, during which your screen may be blank).

after installation you can activate the broadcast by going to `SYSTEM > MODS > BROADCAST`. first use E3 to select `edit station name` and press K3 to enter in your station name. then you can use E3 to select `offline` and press K3 to turn go `online`. if you are "online" you can use the URL to listen to your norns.

you can advertise your stream by toggling "advertise" to "true". then your stream will be listed at [`streamyouraudio.com`](https://streamyouraudio.com). _note_: **all the streams are public so don’t share anything private. the streams are not password-protected or anything. but the URL for your stream is private unless you share it (technically the server also sees the URL but I don’t keep logs so I don’t see it…).**

### Download

```
;install https://github.com/schollz/broadcast
```

https://github.com/schollz/broadcast
