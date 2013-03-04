class Person(object):
    """Model for a real person."""

    def __init__(self, name, age, weight):
        super(Person, self).__init__()
        self.name = name
        self.age = age
        self.weight = weight

    def eat(self):
        self.weight += 2


if __name__ == '__main__':
    p = Person(name="Chuck Norris", age=73, weight=80)
