# SPACE DELIVERY \*\*Working title

## Project config

- 640 x 380 resolution
- Supports fullscreen
- Vsync disabled

## Star Navigation

The Star navigation system is very dynamic and you shouldn't need to adjust the code in order to add levels/nodes or to adjust nodes. Everything can be adjusted in the Inspector.

### Adding levels

Easiest thing to do here is to duplicate the level 1 `space.tscn` and move or adjust the location nodes. Any scene that has the `space.gd` script + some `LocationNode`s + a `SpacePlayer` will become a space navigation scene.
Levels NEED:

- A LocationNode named simply "LocationNode". All other nodes can be named whatever you like.
- The "LocationNode" is the starting node for the level and the player will warp to this node when the scene loads.
- One of the location nodes needs to have the `final_node` property ticked on in the inspector.

### Adding nodes

You can instance a new LocationNode or simply duplicate one already in your level scene.

To create a link to other nodes you need specify the nodes the player can come from - not the ones they can fly to. This can be set in the `departure nodes` setting in the Inspector.

## Notes

- You can access Global game state anywhere in the game with `G` e.g. `G.player_health`

## Itch.io Page

https://ragewolf.itch.io/cosmic-order-gamejam
