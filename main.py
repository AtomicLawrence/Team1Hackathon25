from auditer import chat

if __name__ == '__main__':
    for outputChunk in chat(user_input = input("Enter webpage source: ")):
       print(outputChunk)