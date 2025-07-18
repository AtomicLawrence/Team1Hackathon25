
class Filters:
    def __init__(
            self,
            screen_reader_support = True,
            voice_input = True,
            sufficient_contrast = True
    ) -> None:
        self.screen_reader_support = screen_reader_support
        self.voice_input = voice_input
        self.sufficient_contrast = sufficient_contrast

    def __str__(self):
        output_string = 'Filter has the following configuration:\n\n'

        output_string += f'Screen reader support: {self.screen_reader_support}\n'
        output_string += f'Voice input support: {self.voice_input}\n'
        output_string += f'Sufficient contrast: {self.sufficient_contrast}\n'

        return output_string