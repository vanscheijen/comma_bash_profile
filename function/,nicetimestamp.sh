,nicetimestamp () {
    /bin/cat "${1:--}" | /usr/bin/perl -pe 's/(\d+)/localtime($1)/e'
}

