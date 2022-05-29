# pylint: disable=unused-argument
import pathlib

from invoke import task

ROOT = pathlib.Path(__file__).parent


@task
def test(c):
    c.run(f"python -m robot --console dotted {ROOT / 'atest'}", echo=True)


@task
def lint(c):
    c.run(
        f"pylint --score=n {ROOT / 'PythonStackTracer'} {ROOT / 'tasks.py'}", echo=True
    )


@task
def format_code(c):
    c.run(f"black --quiet {ROOT}", echo=True)
    c.run(f"isort {ROOT}", echo=True)


@task
def precommit(c):
    format_code(c)
    test(c)
    lint(c)
