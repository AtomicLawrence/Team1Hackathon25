
class AccessiblityImprovementRequest:
    def __init__(
            self,
            text: str,
            screenshot: str
    ) -> None:
        self.text = text
        self.screenshot = screenshot

    def __str__(self):
        request_as_string = ''

        request_as_string += f'Text input {self.text} \n'
        request_as_string += f'Path to image {self.screenshot}'

        return request_as_string