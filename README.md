# Big-Red-Bowling

This file includes all the features and the thought went into the design during the creation of Big Red Bowling.

There is no other app on the App Store that allows users to keep track of their bowling scores with other players interactively. 

The complex score calculation algorithm was coded from scratch (no outside API). 

This app is created to work between iPhones so that everyone can set their individual scores and view how everyone else is doing. The app calculates the score
for the user, and the users can join any other game with a game id. They can also see which pins were knocked down by anyone in the game.

Features:

ViewController:
  Home screen for the app that features a table of all of your games, currently active and previously completed.
  
AddGameViewController:
  Presented from the home screen, this view controller allows the user either create a new game or join a friend's game with their id. 

SettingsViewController:
  Allows the user to set their name. Stored in UserDefaults.

GameViewController:
  When you click a game from the home screen, app transitions to the GameViewController. Lists all of the players in the game, showcases their scores, game status,
  and the highest scorer.

AddPlayerViewController:
  Presented when the + icon is clicked in the navigation bar of the GameViewController. Allows the user to add another player into the game. 

PlayerViewController:
  When you click a player from the GameViewController, app transitions to the PlayerViewController. Displays the active frame and the previous frames of the
  player.

FrameViewController:
  Presented when a frame is clicked in the PlayerViewController. Lets the user enter their data for the frame. Users can select which specific pin they knocked
  down for each roll, so that they can view these later. 
 
AlertController:
  Takes a view controller argument and Error enum to alert the player on any issues, such as duplicate player, invalid game id, failed to connect, etc. 
  
UserDefaults:
  Stores the player's name and the previous games that were joined, so they appear after restarting the app.
  
ScoreCalculator and Score Keeping: 
  The score of one frame maybe depended on future frames depending on the presence of a strike or a spare.
  If there a frame is not a strike or a spare, the score could be calculated immediately by adding the pins knocked over. However, if it's a spare,
  for the score to be calculated, the next roll of the next frame must be known. Similarly in a strike scenerio, the next two rolls must be known, which
  can take place in up to two frames.
  
  The tenth frame is very complex, as there are four different scenerios for the score calculation. Because of this, score calculation is a complex and integral
  process of this app. Combining this feature with the selection of the pins makes it even more challenging, but nonetheless, much more user friendly and
  professional. 
 
