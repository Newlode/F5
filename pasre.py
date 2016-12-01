#!/usr/bin/python3

import re


class bloc():
    "Définit un bloc de configuration F5"

    def __init__(self, s_bloc):

        _lines = s_bloc.splitlines()

        self._title = _lines[0]
        self._bloc = _lines[1:-1]

    def __str__(self):
        return self._title + ';'.join(self._bloc)


_input_file="AUB.conf"


def _parse_bloc(b):
    print("bloc :", repr(b))


with open(_input_file) as f:
    
    _re_bloc_start = re.compile("^(\S+\s)+{$")
    _re_bloc_end = re.compile("^}$")
    _bloc_level = 0

    _in_bloc = False
    _buffer = ""
    for line in f:
        if _re_bloc_start.match(line):
            _in_bloc = True

        if _in_bloc: _buffer += line

        _bloc_level += line.count('{')
        _bloc_level -= line.count('}')

        if _bloc_level == 1:
            print("e", _buffer, "r")
            continue
            print(bloc(_buffer))
            _buffer = ""
            _in_bloc = False

