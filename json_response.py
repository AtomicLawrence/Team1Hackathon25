
class AccessiblityImprovementResponse:
    def __init__(
            self,
            text_template: str,
            image_dictionary: dict[str, str] # make memory stream in order to serve images to app
    ) -> None:
        self.text_template = text_template
        self.image_dictionary = image_dictionary
