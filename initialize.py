from pathlib import Path
import re
resconf = Path('/etc/resolv.conf').read_text()
pattern = re.compile('(?<=nameserver ).*')
nameserver = re.search(pattern, resconf)[0]

Path(__file__).parent.joinpath('display.txt').write_text(f'{nameserver}:0.0')

