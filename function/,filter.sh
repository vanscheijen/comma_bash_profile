,filter () {
    func=${@:-\$1}
    func=${func//@/$}
    awk '{ if ('"$func"') { print } }'
}

