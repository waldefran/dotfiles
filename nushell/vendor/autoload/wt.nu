$env.TERM_PROGRAM = "WezTerm"

def --env wezterm-set-user-var [name: string, value: string] {
    if ($env | get -o TERM_PROGRAM) == "WezTerm" {
        print -n $"\e]1337;SetUserVar=($name)=($value | encode base64)\a"
    }
}
