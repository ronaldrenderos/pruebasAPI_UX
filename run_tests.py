import sys
from datetime import datetime
from robot import run_cli

timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')

args = [
    "--output", f"output_{timestamp}.xml",
    "--log", f"log_{timestamp}.html",
    "--report", f"report_{timestamp}.html",
    "--xunit", f"xray_{timestamp}.xml",
    "tests"
]

exit_code = run_cli(args, exit=False)

sys.exit(exit_code)
