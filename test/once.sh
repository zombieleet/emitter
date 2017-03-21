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
