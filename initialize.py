from pathlib import Path
from subprocess import run
import re
import time 

RUN_ARGS = []

def run_cmd(cmd) -> str:
    return run(cmd, shell=True, capture_output=True, check=True
               ).stdout.decode('utf-8')


def usbipd():
    out =run_cmd('powershell.exe usbipd wsl list')
    for probe in out.splitlines():
        if ma:=re.search(r'^(\d+-\d+).*Picoprobe.*Not attached', probe):
            run_cmd(f'powershell.exe gsudo usbipd wsl attach --busid {ma[1]}')
    
def add_device_picoprobe_usb():
    out =run_cmd('lsusb')
    for probe in out.splitlines():
        if ma:=re.search(r'(\d{3}).*?(\d{3}).*Picoprobe', probe):
            RUN_ARGS.append(f'--device="/dev/bus/usb/{ma[1]}/{ma[2]}"')

def add_device_ACM():
    for acm in Path('/dev').glob('ttyACM*'):
        RUN_ARGS.append(f'--device={acm}')

if __name__ == '__main__':
    usbipd()
    time.sleep(0.5)
    # add_device_picoprobe_usb()
    add_device_ACM()
    
    env = 'DEVCONTAINER_RUN_ARGS'
    text = f"export {env}=\"{' '.join(RUN_ARGS)}\"\n"
    
    runenv_file = Path('/etc/profile.d/vscode_devcontainer_runenvs.sh')
    runenv_file.touch()
    old_text = runenv_file.read_text()
    runenv_file.write_text(text)
    assert old_text == text, "\n\n\nREBUILD IMAGE\n\n\n"
