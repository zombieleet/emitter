# Emitter
Emitter is a bash library that helps you to be able to listen for events and run a particular function if the event is emitted

**Usage**
`event` takes three subcommands namely `attach` `emit` and `detach`

**event attach**
`event attach` takes 2 argument which is the name of the event you want to listen for and the Function attach to that event

```
1  #!/usr/bin/env bash
2  source ../evt.sh
3  CreateFile() {
4    local ftocreate=$1
5    echo -e "Love is a name \nSex is a game\n Play the Game\n Forget the name " > "$ftocreate"
6    printf "%s\n" "$ftocreate have been created"
7  }
8  event attack createfile CreateFile
9  event attach showfile ReadFile
```


**event emit**
`event emit` the first argument to `event emit` must be the the event you want to listen for and it must already been created using `event attach` , the second argument must be the total number of argument you want to pass to the callback function assigned to the event you want to listen for

Note:- You must not pass the arguments to the callback function directly when createing the event listener with `event attach`

Note:- When assiging the arguments to the event listener using `event emit` you must wrap the arguments with double quotes , each argument must be separated with spaces, if a particular argument have white space or tabs , wrap that specific argument with single quotes.

Note:- Under the hood, 2 other argument are passed to the callback function which is the name of the event listend for and the function that will be fired if the event is emitted

for example:

```
  event attach talk SayShell # talk is the event to listen for, SayShell is the callback function to execute when the event talk is been emitted

  event emit talk "bash ksh zsh sh" # talk is the event to listen for, "bash ksh zsh sh" is the argument passed to SayShell
  loveWhat="This are the shells i love"
  event emit talk "'$loveWhat' bash ksh zsh sh" # loveWhat variable contains space, and it's wrapped in single quotes so that it will be read as a single argument

```

see line 7 and line 27

```
1  #!/usr/bin/env bash
2  source ../evt.sh
3  CreateFile() {
4    local text=$1 ftocreate=$2
5    echo -e "Love is a name \nSex is a game\n Play the Game\n Forget the name " > "$ftocreate"
6    printf "%s\n" "$ftocreate $text"
7    event emit showfile "$ftocreate"
8  }
9  event attack createfile CreateFile
10 event attach showfile ReadFile
11 ReadFile() {
12    local file=$1
13    echo "------------------------- READING $file -----------------------"
14    while read log;do
15      printf "%s\n" "$log"
16    done < <( cat "$file" )
17    echo "------------------------- DONE READING $file ------------------"
18 }
19
20  File() {
21
22    if [[ ! -f "log.txt" ]];then
23    	 event emit createfile "'has been created' log.txt"
24	     return 1;
25    fi
26
27  event emit showfile "log.txt"
}
```

**Detach Event**
`event detach` takes a single argument, it detaches/removes the event you want to listen for from the Stack.

`event detach eventName`


***License***
GNU
