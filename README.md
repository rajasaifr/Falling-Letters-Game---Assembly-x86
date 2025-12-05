Falling Letters Game - Assembly x86
A classic falling letters typing game written entirely in x86 assembly language for MS-DOS. Catch falling letters with your moving box to score points!

🎮 Game Features
Two Game Modes:

Single Player: Control one box at the bottom

Multiplayer: Two players can play simultaneously (Player 1: Arrow Keys, Player 2: A/D Keys)

Dynamic Difficulty: Game speed increases as you score more points

Visual Feedback: Different colored falling letters

Score Tracking: Real-time score and missed letters display

Shift Key Speed Boost: Hold shift to move your box faster!

🕹️ Controls
Single Player Mode:
Left Arrow ← : Move box left

Right Arrow → : Move box right

Shift + Arrow : Move faster

ESC : Exit game

Multiplayer Mode:
Player 1 (Bottom box):

Left Arrow ← : Move left

Right Arrow → : Move right

Player 2 (Top box):

A Key : Move left

D Key : Move right

Both players can use Shift for speed boost

🎯 Game Rules
Letters (A-Z) fall from the top of the screen

Move your box to catch falling letters

Each caught letter increases your score

Each missed letter (reaches bottom) counts against you

Win Condition: Score 15 points

Lose Condition: Miss 25 letters

Game ends immediately if ESC is pressed

🛠️ Technical Details
Language: x86 Assembly (MASM/TASM syntax)

Platform: MS-DOS

Video Mode: Text Mode (80x25, 16 colors)

Memory: Direct video memory access (0xB800 segment)

Interrupts:

Timer Interrupt (INT 8) for game loop

Keyboard Interrupt (INT 9) for input handling

Terminate and Stay Resident (TSR) program


Prerequisites:
DOS environment (DOSBox recommended)

x86 assembler (NASM, MASM, or TASM)


🎨 Game Screens
Start Screen: Shows "Start" message

Mode Selection: "Press S for SinglePlayer and M for MultiPlayer"

Game Screen:

Top: Score and missed counters

Middle: Falling colored letters

Bottom: Player box(es)

Game Over Screen: Shows final score and "Game Over" message

⚡ Performance Notes
Game uses timer interrupts for smooth animation

Direct video memory writes for fast rendering

Random number generation using system timer

Optimized assembly routines for efficiency

🐛 Known Issues
May conflict with other TSR programs

Random number generation might not be perfectly uniform

Some edge cases in box movement boundaries

📝 Code Highlights
Interrupt Service Routines: Custom keyboard and timer handlers

Memory Efficient: Uses minimal memory footprint

No Operating System Dependencies: Direct hardware access

Reusable Functions: Well-structured subroutines

🤝 Contributing
This is a learning project. Feel free to:

Report bugs or issues

Suggest improvements

Fork and modify for your own learning

📚 Learning Resources
This project demonstrates:

x86 assembly programming

MS-DOS interrupt handling

Direct video memory manipulation

Game development in low-level language

TSR programming concepts

⚠️ Disclaimer
This program directly modifies system interrupts and video memory. Use in a controlled environment like DOSBox. The author is not responsible for any system instability.

🏆 Credits
Developed as a learning project for x86 assembly language and MS-DOS game programming.

Enjoy the classic falling letters challenge! Test your reflexes and typing skills!
