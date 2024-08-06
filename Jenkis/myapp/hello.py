import fire

def hello(name="world"):
    return "Hello %s!" % name
if __name__ == "__main__":
    fire.Fire(hello)