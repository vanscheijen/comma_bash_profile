,reduce () {
    func=${@:-\$1}
    func=${func//@/$}
    awk '{ total += '"$func"' } END { print total }'
}

