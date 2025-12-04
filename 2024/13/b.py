from a import parse

if __name__ == "__main__":
    machines = parse()
    
    total = 0
    for m in machines:
        (px, py) = m.prize
        px += 10000000000000
        py += 10000000000000
        m.prize = (px, py)
        
        if (s := m.solve()) is not None:
            a, b = s
            total += 3 * a + b
    
    print(total)