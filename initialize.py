from pathlib import Path
from subprocess import run
import re

runenv_file = Path('/etc/profile.d/vscode_devcontainer_runenvs.sh')
args = dict()

usbinfo = run('lsusb', shell=True, capture_output=True).stdout.decode('utf-8')
pat = 'Bus (\d+) Device (\d+): .*? Picoprobe'
match = re.search(pat, usbinfo)
if match:
    device = f'/dev/bus/usb/{match.group(1)}/{match.group(2)}'
    args['VS_DEVCONT_PICOPROBE']=f'--device={device}'

acm_file = Path('/dev/ttyACM0')
if acm_file.exists():
    args['VS_DEVCONT_ACM']=f'--device=/dev/ttyACM0'

text = ''.join(f'export {key}={val}\n' for key, val in args.items())
old_text = runenv_file.read_text()
runenv_file.write_text(text)
assert old_text == text, "runenv_file changed, rebuild"
