from pathlib import Path
from subprocess import run

def run_cmd(cmd):
    run(cmd, shell=True)

for path in Path('/workspaces').rglob('*'):
    if path.is_dir() and '.git' in (p.name for p in path.iterdir()):
        run_cmd(f'git config --global --add safe.directory {path}')
        
        
run_cmd('git config --global user.email "emil.martens@gmail.com"')
run_cmd('git config --global user.name "Emil Martens"')

display = Path(__file__).parent.joinpath('display.txt').read_text()
bashrc = Path.home().joinpath('.bashrc')
bashrc.write_text(f'{bashrc.read_text()}export DISPLAY={display}\n')

