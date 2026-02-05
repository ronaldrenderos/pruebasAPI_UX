import os
from datetime import datetime
from openpyxl import Workbook, load_workbook


class ExcelWriter:
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self, base_path='results/'):
        self.base_path = base_path
        self.wb = None
        self.ws = None
        self.path = None

    def init_excel_for_test(self, test_name):
        """Initialize Excel file using test name in filename."""
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        safe_test_name = test_name.replace(" ", "_")

        filename = f'{safe_test_name}_{timestamp}.xlsx'
        self.path = os.path.join(self.base_path, filename)

        os.makedirs(self.base_path, exist_ok=True)

        self.wb = Workbook()
        self.ws = self.wb.active

        self.ws.append([
            'environment',
            'base_url',
            'filter',
            'path',
            'method',
            'result'
        ])

        self.wb.save(self.path)

    def append_result(
        self,
        environment,
        base_url,
        filter_name,
        path,
        method,
        result
    ):
        if not self.wb or not self.ws:
            raise RuntimeError(
                "Excel file not initialized. "
                "Call 'Init Excel For Test' first."
            )

        self.ws.append([
            environment,
            base_url,
            filter_name,
            path,
            method,
            result
        ])
        self.wb.save(self.path)


# Global instance
_excel_writer = ExcelWriter()


def init_excel_for_test(test_name):
    """Robot keyword to initialize the Excel file."""
    _excel_writer.init_excel_for_test(test_name)


def append_result(environment, base_url, filter_name, path, method, result):
    """Robot keyword to append a row."""
    _excel_writer.append_result(
        environment,
        base_url,
        filter_name,
        path,
        method,
        result
    )
