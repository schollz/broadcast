## broadcast

a norns mod to create a public mp3 stream from your norns.

![image](https://user-images.githubusercontent.com/6550035/148573879-0a419172-9ad3-4d31-89c1-ea3176da87f7.png)


broadcast is a simple mod that lets you make a dedicated music stream from your norns. the output is a public URL of an mp3 that can be listened to in a browser, in music apps, etc.

broadcast works by using [`darkice`](http://www.darkice.org/) and [`icecast2`](https://icecast.org/) which interface with JACK and convert the norns output into a mp3 stream (which is [configurable](https://github.com/schollz/broadcast/blob/main/darkice.cfg#L18)). this local stream is then streamed via `curl` to a server I setup at `broadcast.norns.online`. [the server](https://github.com/schollz/broadcast-server) is ~200 lines of code that simply copy bytes from a POST request (i.e. the stream) to any number of GET requests (i.e. browser client(s)).


broadcast will install ~2.5 MB of linux packages when you run it the first time and while running will take a small amount of CPU to run the stream conversion, and use some internet bandwidth to upload the stream.

### Requirements

- norns
- internet connection

### Documentation

you can install *broadcast* and then activate the mod in the `SYSTEM > MODS > BROADCAST`. after activating for the first time you need to restart `SYSTEM > RESTART`. 

after installation you can activate the broadcast by going to `SYSTEM > MODS > BROADCAST`. first use E3 to select `edit station name` and press K3 to enter in your station name. then you can use E3 to select `offline` and press K3 to turn go `online`. if you are "online" you can use the URL to listen to your norns.


### Download

```
;install https://github.com/schollz/broadcast
```

https://github.com/schollz/broadcast