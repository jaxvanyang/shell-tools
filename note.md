# Note for Shell

## TOC

- [1. Advanced Keyboard Skills](#1-advanced-keyboard-skills)

## 1. Advanced Keyboard Skills

Bash use a library called "Readline" to edit command line.

Here are some usefull keyboard shortcuts.

1. Moving Cursor

	| Keyboard Shortcut | Function |
	|:---|:---|
	| *Ctrl + A* | move cursor to the begin of the command line |
	| *Ctrl + E* | move cursor to the end of the command line |
	| Ctrl + F | move cursor a character forward, just like the right arrow key "->" |
	| Ctrl + B | move cursor a character backward, just like the left arrow key "<-" |
	| *Alt + F* | move cursor a word forward, just like "Ctrl + ->" in most text editor |
	| *Alt + B* | move cursor a word backward, just like "Ctrl + <-" in most text editor |
	| *Ctrl + L* | clear screen and move cursor to upper left |

2. Changing Text

	| Keyboard Shortcut | Function |
	|:---|:---|
	| Ctrl + D | *d*elete the character at cursor |
	| Ctrl + T | swap the character at cursor and the character before it |
	| *Alt + T* | swap current word and the word before it |
	| Alt + L | make the content from cursor to the end of word lowercase |
	| Alt + U | make the content from cursor to the end of word uppercase |

3. Killing and Yanking Text (Cutting and Pasting Text)

	The content that was killed is stored in a buffer called kill-ring.

	| *Ctrl + K* | kill the content from cursor to the end of line |
	| *Ctrl + U* | kill the content from cursor to the begin of line |
	| *Alt + D* | kill the content from cursor to the end of word |
	| *Alt + Backspace* | kill the 
