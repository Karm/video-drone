# VideoDrone
Featuring [Ruby](http://www.ruby-lang.org/en/), [DRb](http://www.ruby-doc.org/stdlib-1.9.2/libdoc/drb/rdoc/DRb.html), [WebSockets](http://websocket.org/index.html), [GWT](http://code.google.com/webtoolkit/) and [MPlayer](http://www.mplayerhq.hu/design7/info.html).

## Objective
To have a software that would be able to control multiprojector visual installations
with quite precise timing. In another words, to control remote video players.

## Requirements
We may picture a scene, where we have e.g. eight data projectors installed in a hall,
each one connected to a computer that provides VGA output and runs Linux and
Ruby environment. Computers are connected in a network.

Furthermore, we have a device, likely a handheld, capable of running a modern web browser.
This control device allows us to manage remote video players and synchronize playback
through user friendly web GUI.

## Initial functionality
### Basic pilot version
  * starting/pausing/resuming/stopping a particular video sequence on a chosen data projector
 
### Next stage
  * synchronizing video sequences among the players
  * fast forward / seek / slow motion / fast motion settings to the selected video sequences

### Future plans
Optionally, there might be web cameras installed in the video hall. Streams coming
from these cameras would be routed to the web application for user to
have a possibility of direct observation of the video installation in the hall.

## Implementation
Video providing computers will probably be a bunch of discarded, old notebooks
running daemons written in Ruby. These daemons are instances of VideoDrone application.

The aforementioned computers share network with server daemon, VideoDroneServer running
on a dedicated system.

VideoDrone instances (video playback daemons) communicate with VideoDroneServer via DRb,
super fast Ruby inter-process messaging (calling methods via sending messages).

VideoDrone GUI, a GWT application communicates with VideoDroneServer via WebSockets.
This technology offers low latency bidirectional messaging which is exactly what
satisfies all the needs for a very responsive / UX lovely web GUI.

## Installation
Coming soon...

    tunnel to the server: ssh -L9001:127.0.0.1:9001 -R9000:127.0.0.1:9000 your.server.com

