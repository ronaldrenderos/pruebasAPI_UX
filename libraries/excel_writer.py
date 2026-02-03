import os
from openpyxl import Workbook, load_workbook

class ExcelWriter:
    """Simple Robot Framework library to append test results to an Excel file."""
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self, path='results/filters_results.xlsx'):
        self.path = path
        dirname = os.path.dirname(self.path)
        if dirname and not os.path.exists(dirname):
            os.makedirs(dirname)
        if os.path.exists(self.path):
            self.wb = load_workbook(self.path)
            self.ws = self.wb.active
        else:
            self.wb = Workbook()
            self.ws = self.wb.active
            # write header
            self.ws.append(['environment', 'base_url', 'filter', 'path', 'method', 'result'])
            self.wb.save(self.path)

    def append_result(self, environment, base_url, filter_name, path, method, result):
        """Append a row to the XLSX file.

        Example: Append Result  env  https://...  filter_name  /path  GET  PASS
        """
        self.ws.append([environment, base_url, filter_name, path, method, result])
        self.wb.save(self.path)

# Create a module-level instance and expose a function so Robot can find the keyword
_excel_writer = ExcelWriter()

def append_result(environment, base_url, filter_name, path, method, result):
    """Module-level wrapper that appends a result using the ExcelWriter instance."""
    _excel_writer.append_result(environment, base_url, filter_name, path, method, result)
