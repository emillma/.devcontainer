from pathlib import Path
from subprocess import run, CompletedProcess
import re


def run_cmd(cmd) -> CompletedProcess:
    return run(cmd, shell=True, capture_output=True).stdout.decode('utf-8')


for path in Path('/workspaces').rglob('*'):
    if path.is_dir() and '.git' in (p.name for p in path.iterdir()):
        run_cmd(f'git config --global --add safe.directory {path}')


run_cmd('git config --global user.email "emil.martens@gmail.com"')
run_cmd('git config --global user.name "Emil Martens"')
run_cmd('pip install -e `find /  -type d -wholename "*/vitass/hwlib"`')

run_cmd('apt install -y iproute2')
ip = re.search(r'(?:\d{1,3}\.?){4}',
               run_cmd('ip route list default'))[0]
display = f'{ip}:0.0'
bashrc = Path.home().joinpath('.bashrc')
bashrc.write_text(f'{bashrc.read_text()}export DISPLAY={display}\n')
