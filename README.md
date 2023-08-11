# GLOBAL WARMING - THE GAME
#### Video Demo:  <URL HERE>
#### Description:
## 1. The concept of the game
#### The year 2023 has unfolded with cataclysmic environmental events - record braking heatwaves, floods storms etc.
#### The most likely culprit for all of this is global warming which inspired the idea behing the game. Thus, **the main
#### purpose of the game is to direct Earth as a planet and avoid the biggest contributor to global warming - CO2
#### gasses, and hopefully survive the next 100 years.** The game also includes solar panels which represent green energy
#### and help the player along the way.
####
## 2. Development
#### Development was done on the Windows Subsystem for Linux (WSL) in Visual Studio Code application. The game is
#### written in Lua using LOVE2D physics models. Physics libraries such as Windfield were consired but proved unnecessary
#### for the development of the mechanics in the game.
####
## 3. Gameplay
#### The purpose of the game is move the Earth sprite around the screen and avoid the CO2 gasses that are floating
#### around. Once in a while a solar panel sprite will appear as well. Colliding one of the gas sprites will cause the
#### the player to lose one life, while colliding with the solar panel will add one life. The game is started at year
#### 1 which represents 2023, and with 3 spare lives. Every second you manage to survive without colliding with CO2
#### gasses and not losing all the lives brings you closer to surviving those 100 years. Therefore, the game ends when
#### you run out of lives before you reach 100 years, or you manage to survive for 100 years and win the game.
####
## 4. Mechanics of the game
### 4.1 The code structure
#### Although I considered using pre-made libraries for menu buttons and physics, I ended up using only the built-in
#### functions and modules. Windfield turned out to be unneeded and for the one button library I tried, there were issues
#### adjusting colors and specifically font size which was not part of the default library attributes. After failing to
#### to edit the library code I gave up and just implemented keyboard keys with instructions to run and exit the game.
#### The main.lua file contains all the code to run the game. Furthermore, I contemplated using a separate file for some
#### of the functions, for example, spawning the CO2 gasses, but since I don't have much experience with OOP programming
#### and the requirements of the game do not necessarily need that, I dropped that idea. Therefore, all of the spawning
#### functions for CO2 gasses and the solar panels are within the main.lua file.
#### The only separate coding file was a shell file that I had to create since my LOVE2D installatin is on Windows, but
#### the development was done on Ubuntu. Since dragging and dropping all the folders and files every time on Windows
#### explorer would be cumbersome, I created a shell file with the sole function of taking the game code and running it
#### on the other system. For some reason I couldn't get the LOVE2D environment working properly on my Ubuntu image.
#### Lastly, the only folder within the game folder is for storing sprites. There's an Earth sprite (50x50), and two
#### 40x40 pixel size sprites for the CO2 gasses and the solar panels.
### 4.2 Requirements and logic
#### The game has a minimun requirement for screen size of 800x600 in pixels (width/height) and the default setting is
#### fullscreen mode. A built-in math random seed is used to spawn the CO2 gasses (red/-s in code) and solar panels
#### (green/-s in code) in radom locations with random x,y velocity directions. To make things more interesting d4 dice
#### is used to randomly adjust and increase the velocity of each sprite representing CO2. There is no gravity and
#### restitution is set to 1, therefore, the sprites continue bouncing of walls with the same velocity and only colliding
#### with each other the physics model adjust the velocity. Mathematics formula math.sqrt((x - x1) ^ 2 + (y - y1) ^ 2)
#### is used to calculate the distance between two sprites and compared to the sum of both radii, and used for collision
#### detection. Although the sprites are square images, the calculations are done as if they were circles. Therefore,
#### there is a small overlap of the sprites on the screen, but since the Earth sprite is round with a black background
#### and the other sprites also have a black background, this overlap is almost indistinguishable.
### 4.3 Functions
#### There is the main state of the game: game_running which being true and false determines what is shown on the screen.
#### Additionally depending on the outcome of the game game_finished_won and game_finished_lost are switched to true to
#### show the endgame message.
#### Besides the main Lua functions the code contains the following:
#### spawnred() and spawngreen(): these two functions are used to spawn the CO2 gasses and solar panels on the screen.
#### The empty dictionaries are then populated with each new object. Each object is a body that is added to the LOVE2D
#### physics model. The model then handles the basic movement of the objects.
#### reflect(): to ensure that objects don't leave the screen this functions takes the velocity and the x, y positions
#### of all the objects that are next to the walls of the screen and reflects them with an adjusted angle.
#### collision(): one of the most important functions that was not easy to create. It cycles through all the objects
#### and compares their locations with the player's location in each update. With the geometry formula mentioned above
#### at a distance of the sum of the two radii (player and an object, i.e., CO2 gas or solar panel) a collision is
#### detected and the object is removed from the dictionary that contained it. Furthermore, the life counter is incremented.
#### movement(): a simple function that moves the player's sprite in four directions using the A, W, S, and D keys.
#### border(): another simple functon that ensured that the player's sprite doesn't leave the screen.
#### love.keypressed(): two extra keys, 'space' and 'escape' for starting the game and quiting it. Also had to add logic
#### for repeat games, after finishing one already. The logic was implemented checking game_running status, then resetting
#### all the timers, lives, etc.