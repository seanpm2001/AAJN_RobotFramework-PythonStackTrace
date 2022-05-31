# Copyright 2022- Piotr Chromiński
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# pylint: disable=invalid-name, unused-argument
import sys
from dataclasses import dataclass, field
from typing import Callable, Dict, Optional

from robot.utils import ErrorDetails


def print_trace(exc):
    error = ErrorDetails(exc)
    if error is None:
        return

    print("", end="\r")
    print(f"Python {error.traceback}")
    print("_" * 78)


@dataclass
class EndKeyword:
    name: str
    attributes: Dict[str, str]
    exc: Optional[Exception]

    @property
    def passed(self) -> bool:
        return self.attributes["status"] == "PASS"


class EndTestOrSuite:
    pass


@dataclass
class PythonStackTracer:
    """Robot Framework listener which prints Python traceback for failing keywords."""

    ROBOT_LISTENER_API_VERSION = "2"

    _state: Callable = field(init=False)
    _first_end_keyword: Optional[EndKeyword] = field(init=False, default=None)

    def __post_init__(self):
        self._state = self._state_gather

    def _state_gather(self, event):
        if isinstance(event, EndKeyword):
            if not event.passed:
                if event.attributes["libname"] != "BuiltIn":
                    self._first_end_keyword = event
                    self._state = self._state_failing
        elif isinstance(event, EndTestOrSuite):
            pass

    def _state_failing(self, event):
        if isinstance(event, EndKeyword):
            if event.attributes["status"] == "PASS":
                self._state = self._state_gather
                self._first_end_keyword = None
            elif event.attributes["libname"] != "BuiltIn":
                print_trace(self._first_end_keyword.exc)
                self._state = self._state_skip_remaining
        elif isinstance(event, EndTestOrSuite):
            print_trace(self._first_end_keyword.exc)
            self._state = self._state_skip_remaining

    def _state_skip_remaining(self, event):  # pylint: disable=no-self-use
        if isinstance(event, EndKeyword):
            pass

    def end_keyword(self, name, attributes):
        self._state(EndKeyword(name, attributes, sys.exc_info()[1]))

    def end_test(self, data, result):
        self._state(EndTestOrSuite())

    def end_suite(self, data, result):
        self._state(EndTestOrSuite())
