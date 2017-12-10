-----------------------
Readme for UDK Frontend
-----------------------

When UFE is first started up, you will be asked to choose the initial Location of the UDK.exe file. Please select it from Binaries\Win32 or Win64 folder only.

All the functionality of the original Unreal Frontend has been retained. The extras that have been added\updated are:

1. File -> Change UDK Directory
This allows you to use the same Frontend application for multiple UDK Builds. No more need to switch between Frontends to cook or compile your stuff when a new UDK Build is released.

2. Edit -> Auto Scroll
The original frontend would stop auto-scrolling when you click somewhere in-between the Log window while an action is being performed. Now you can choose to always scroll the window whenever a new line is written to the Log window, even if you lose focus from the Log window. Note: If you have focus (clicked) in the Log window, it will auto scroll regardless of the AutoScroll status.

3. Server -> Add Clients
Compared to Unreal Frontend, this command will now 'instantly' add only the number of clients that have been specified in the 'Number of Clients' box in the Game Tab

4. Strip Source Commandlet
Useful if you want to remove source code from your custom packages. Clicking this button opens a new window that will allow you to choose which packages you want to perform strip source on. All Custom Packages should be written with their extensions and should be comma separated (e.g. MyPackage.u, MySecondPackage.u)

5. Ability to Stop Packaging the Game (Default Installer)
Now you can stop packaging your game if you feel you made a mistake. No need to go to Task Manager every time.

6. Configuration Bar
This allows you to modify the Configuration of your Launch, Cooking and Compiling processes. Both 32 and 64 bit configuration options have been added, but only 32 bit has been tested by me.

The Final_Release Configuration is especially useful when you are just about to release your game, as it disables all expensive log messages. Please remember that you should have Final_Release set for both the Script configuration and the Cooking configuration for the packaged game to be in Final Release mode.

7. Platform Chooser
Allows you to select the platform on which to Cook/Compile your game. Obviously only PC Platform makes sense currently since the UDK binary is for PC only. This option will become useful later on when UDK comes to iPhone.

8. Supported Resolutions shown only
Resolutions that are supported by your current display device will be shown only. However, if you want to see the old list, you can check the 'Show All Resolutions' box.

9. FullScreen Mode
Starting UDK in Fullscreen is directly possible through Frontend. (Although Alt+Enter was there earlier too)

10. Additional Cooker Options
Now you can add any number of extra flags to your Cook Packages commandlet without having to make Batch scripts or shortcuts for each new UDK Build

11. GFxImport Commandlet
Allows you to enter a list of all SWF Movies that will be imported or updated. The list can have space, new line or comma separated list of SWF Movies and all of them will be checked for updates. This setting is relevant only for UDK August 2010 build onwards.

Since the List is saved between sessions, you can quickly update your SWF files without having to manually write scripts to do the same thing. You can place all your SWF files in one go into the list box and import every time a change is made, as Swf's that are up-to date will not be modified.

12. Custom Commandlet
You can run UDK.exe with any commandlet that appears with later versions by typing the arguments in the Custom Commandlet window. All commandlets are saved to history, and it is possible to clear history as well.

13. Package Game -> Custom Packaging
To use this option, you must have a valid Manifest File. The file is to be selected at first run, and can be changed later on. After selection, you have 2 options:
	a. Collect Game: Allows you to select a Folder where all relevant UDK Files will be copied. NOTE: When copying to the same location twice, Read-Only Files will NOT be overwritten
	b. Package Game: Creates a NSIS Script with a listing of all relevant UDK Files. The script also contains extra code to create UnSetup.exe Registry keys during the main installation itself. This will allow your users to run the Game directly (without the extra EULA screen & without Admin Access). Pre-Requisites are installed as well (not in silent mode yet). The generated script will be written to the same directory in which UDKFrontend is present.
	
The Manifest File can have an Include and an Exclude Group. The XML Tags can have any name as long as they contain the words 'Include' or 'Exclude'. Files and Directories in the Include Group have a higher priority than Excludes, so if you need to place specific files like Custom Launchers or UDK(.*).ini files, then write them here, so that they're automatically included during collection & in the NSIS Script.

For updated UDK Builds, you need to do the following to create a new Manifest File using "Binaries\UnSetup.Manifests.xml" as a starting point:
	a. Find and Delete all occurrences of the '^' character.
	b. Add the 'ExtraExcludes' Group present inside the 'UDKManifest_Base.xml' file, to the UnSetup XML File.
	c. In the 'GameFilesToInclude' section, replace "UDKGame/^Default(.*).ini" with "UDKGame/Config/Default(.*).ini"

14. Multiple Language Cooking
By typing in multiple language codes in the Languages to be Cooked box, you can execute the CookPackages commandlet multiple times with the same initial settings. The language codes can be separated by space, comma or new line characters.

----------------------------------------------------------------
NOTES:
----------------------------------------------------------------

1. The only goal of this version of the Frontend was to expose the Configuration options, and allow for Extra Cooking options when required. Another reason why I made this was that UDK August Build removed the draggable slider between the Log window and the Game/Cooking Panels, which was really annoying.

2. This Frontend also helped me avoid creating a whole new set of shortcuts all over again for Final_Release mode, and strip source for Final_Release modes for new UDK Builds.

3. If you want to Package your Game with the Default Installer, you should run UDK Frontend as Administrator before starting it, otherwise you'll have to face 4 UAC prompts on clicking the 'Package Game' button. The only reason I left it this way was that Package Game is not a commonly used option (only at end of long development periods), and that doesn't justify the whole program requiring admin access at all times.

4. If you're using the NSIS Script that bypasses UnSetup's EULA, Don't remove the UDK EULA from the License Page

----------------------------------------------------------------
SHORTCUTS:
----------------------------------------------------------------

Ctrl + L: Launch Game with current Game Settings
Ctrl + E: Launch Editor with current Game Settings
Ctrl + S: Launch Server game with current Game Settings
Ctrl + K: Cook Packages with current Cooking Settings
Ctrl + M: Compile Scripts [Not Full Recompile]
Ctrl + P: Open the Strip Source Window
Ctrl + I: Open the GFxImport Window
Ctrl + U: Open the Custom Commandlet Window
Ctrl + G: Package the Game using UDK's Default installer
F1: Navigate to the Game Settings Tab
F2: Navigate to the Cooking Settings Tab

----------
Changelog:
----------
v1.0.0.0:
	Initial Version
v1.0.0.1:
	Fixed Form Window resize bug
v1.0.2.0:
	Added support for GFxImport Commandlet
	Added a Right click menu to the notification icon with basic options
v1.0.3.0:
	Added Custom Commandlet option
	Fixed Button Lock when Package Game is denied Admin Access
v1.0.6.0:
	Cooking now possible with Arbitrary Language Codes
	Added Collect Game Option
	Added Automatic NSIS Script Generation for Packaged Game
v1.0.6.1:
	Added support for cooking multiple languages with one command
	Fixed Additional Cooker Options box being ignored
v1.0.6.3:
	Removed un-implemented 'Clear UnrealConsole Window' option from Game Tab
	Added '-Installed' mode to the Game Tab
	Extra Options for the Game Tab are now saved to history
	Fixed Error when Server->Kill All is performed when UDK's output is logged internally
	Server->Kill All now only ends 'Launch', 'Server', and 'Add Client' processes that were started by UDKFrontend
	Fixed Language not being generated for Edit->'Copy to Clipboard'->'Cooking Command Line'
	Fixed Cooking Error when user doesn't type anything (Language will now Default to INT)
	Fixed Inconsistent 'Use Cooked map' option in the Game Tab
v1.0.6.5:
	Minor code Refactoring
	Removed unnecessary drop-down list in Strip Source commandlet
	Fixed error in rare cases when window width isn't saved correctly