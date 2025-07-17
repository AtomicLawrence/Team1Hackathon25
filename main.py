from auditer import chat
import sys

if __name__ == '__main__':
    input = sys.stdin.read()
    for outputChunk in chat(user_input = input):
       print(outputChunk)