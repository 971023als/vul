function print_good () {
    echo -e "\x1B[01;32m[+]\x1B[0m $1"
}

function print_error () {
    echo -e "\x1B[01;31m[-]\x1B[0m $1"
}

function print_info () {
    echo -e "\x1B[01;34m[*]\x1B[0m $1"
}

function OK () {
    echo -e "\x1B[01;32m[ 양호 ]\x1B[0m $*"
}

function WARN () {
    echo -e "\x1B[01;31m[ 취약 ]\x1B[0m $*"
}

function INFO () {
    echo -e "\x1B[01;34m[ 정보 ]\x1B[0m $1"
}

function ERROR () {
    echo -e "\x1B[01;31m[ 애러 ]\x1B[0m $1"
}




