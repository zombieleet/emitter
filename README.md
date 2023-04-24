# Emitter
Emitter is a bash library that helps you to be able to create custom event listeners and assign a function to be executed whenever the listener is been emitted

**Usage**
`event` takes three subcommands which are `attach` `emit` and `detach`

**event attach**
`event attach` takes two argument which is the name of the event you want to listen for and the function to execute when the event is emitted

```bash
1  #!/usr/bin/env bash
2  source ../evt.sh
3  CreateFile() {
4    local ftocreate=$1
5    echo -e "Love is a name \nSex is a game\nPlay the Game\nForget the name " > "$ftocreate"
6    printf "%s\n" "$ftocreate have been created"
7  }
8  event attach createfile CreateFile ;# createfile is the event to listen for, CreateFile is the callback function to execute when the event is emitted
9  event attach showfile ReadFile ;# showfile is the event to listen for, ReadFile is the callback function to execute when the event is emitted
```


**event emit**
`event emit` the first argument to `event emit` must be the the event you want to listen for and it must have already been added to the stack with `event attach` , the second argument must be the list  of all the argument which will be passed to the callback function (behind the hood) assigned to the event you want to listen for

Note:- You must not pass the arguments to the callback function directly when createing the event listener with `event attach`

Note:- When assigning the arguments to the event listener using `event emit` you must wrap the arguments with double quotes , each argument must be separated with a single space, if a single argument have spaces or tabs , wrap that specific argument with single quotes.

Note:- Under the hood, 2 other argument are passed to the callback function which is the name of the event listend for and the function that will be fired if the event is emitted

for example:

```bash
  event attach talk SayShell # talk is the event to listen for, SayShell is the callback function to execute when the event talk is been emitted

  event emit talk "bash ksh zsh sh" # talk is the event to listen for, "bash ksh zsh sh" is the argument passed to SayShell
  
  loveWhat="These are the shells i love"
  event emit talk "'$loveWhat' bash ksh zsh sh" # loveWhat variable contains space, and it's wrapped in single quotes so that it will be parsed as a single argument

```


see line 7 and line 27

```bash
1  #!/usr/bin/env bash
2  source ../evt.sh
3  CreateFile() {
4    local text=$1 ftocreate=$2
5    echo -e "Love is a name \nSex is a game\nPlay the Game\nForget the name " > "$ftocreate"
6    printf "%s\n" "$ftocreate $text"
7    event emit showfile "$ftocreate"
8  }
9  event attach createfile CreateFile ; #createfile is the event to listen for, CreateFile is the callback function to execute when the event is emitted
10 event attach showfile ReadFile  ; #showfile is the event to listen for, ReadFile is the callback function execute when the event is emitted
11 ReadFile() {
12    local file=$1
13    echo "------------------------- READING $file -----------------------"
14    while read log;do
15      printf "%s\n" "$log"
16    done < "$file"
17    echo "------------------------- DONE READING $file ------------------"
18 }
19
20  File() {
21
22    if [[ ! -f "log.txt" ]];then
23    	 event emit createfile "'has been created' log.txt" ;# 'has been created' and log.txt will be passed to CreateFile
24	     return 1;
25    fi
26
27  event emit showfile "log.txt" ; #log.txt will be passed to ReadFile
28}

```
**once**
`event once` works like `event emit`. The only difference is that once an event is emitted in `event once` that event is removed as an event listener i.e it is only executed ones


```bash
	# check test/once.sh
		
	source ../emitter.bash;

	s() {
		echo "${1}";
	}
	event attach sayHoss s

	event emit sayHoss 'victory'
	event emit sayHoss 'victory'
	event emit sayHoss 'victory'


	ff() {
		local _num1=${1};
		local _num2=${2};

		printf "%d\n" "$(( _num1 + _num2 ))";
	}

	event attach addNumber ff

	event once addNumber 2 2	

```

**NOTE:** once the event `addNumber` is emitted trying to emit again will cause an error


**removeall listener** 
`event removeAll` This subcommands removes all listener by unsetting the Stack array 

**List Event**
`event list` takes no argument. It lists the total number of event listener in the Stack

example
`event list`


**setmaxlistener**
`event setMaxlistener` takes one argument which must be an integer. It resets the default maximum listener by the specified ones


**Detach Event**
`event detach` takes a single argument, it detaches/removes the event you don't want to listen for again from the Stack.

`event detach eventName`


**maxlisteners**
The total number of listeners allowed is 1000, and it's readonly, you cannot modify it in your script, except you want to modify it directly from the emitter library

***License***
GNU General Public License
