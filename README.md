## broadcast

a norns mod to create a public mp3 stream from your norns.

![image](https://user-images.githubusercontent.com/6550035/148565246-6ab76ee5-68da-498c-9ea8-885bbc36ae5f.png)


broadcast is a simple mod that lets you make a dedicated music stream from your norns. the output is a public URL of an mp3 that can be listened to in a browser, in music apps, etc.

broadcast works by using [`darkice`](http://www.darkice.org/) and [`icecast2`](https://icecast.org/) which interface with JACK and convert the norns output into a mp3 stream (which is [configurable](https://github.com/schollz/broadcast/blob/main/darkice.cfg#L18)). this local stream is then streamed via `curl` to a server I setup at `broadcast.norns.online`. [the server](https://github.com/schollz/broadcast-server) is ~200 lines of code that simply copy bytes from a POST request (i.e. the stream) to any number of GET requests (i.e. browser client(s)).


broadcast will install ~2.5 MB of linux packages when you run it the first time and while running will take a small amount of CPU to run the stream conversion.

### Requirements

- norns
- internet connection

### Documentation

you can install *broadcast* and then activate the mod in the `SYSTEM > MODS > BROADCAST`. after activating for the first time you need to restart `SYSTEM > RESTART`. 

after installation there will be a new menu item in the parameters menu: `BROADCAST`.


![broadcast](https://user-images.githubusercontent.com/6550035/148565235-bffa75a4-42ad-489b-bc07-e4ad8ac489e7.png)

you can go into this menu and change your station name and toggle broadcasting off or on.

![11](https://user-images.githubusercontent.com/6550035/148567598-820c8c3f-25dd-40b9-8fbd-17b765b11401.png)

![22](https://user-images.githubusercontent.com/6550035/148567603-8aaef393-c979-4225-af56-76a2929b7c2f.png)
g)


when you begin broadcasting you will see a URL that you can goto to listen to your stream.



### Download

```
;install https://github.com/schollz/broadcast
```

https://github.com/schollz/broadcast