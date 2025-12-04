from a import parse

if __name__ == "__main__":
    l, r = parse()
    s = 0

    for n in l:
        s += n * r.count(n)
    
    print(s)