,map () {
    func=${@//@/$}
    awk '{ print '"$func"' }'
}

