from prettytable import PrettyTable
import random
import itertools

RAND_SEED = 42
MAX_Q = 1024 * 1024 * 10

def fpow(b, e, m):
    result = 1
    while e > 1:
        if e & 1:
            result = (result * b) % m
        b = (b * b) % m
        e >>= 1
    return (b * result) % m

def primes_sieve(limit):
    a = [True] * limit
    a[0] = a[1] = False
    for (i, isprime) in enumerate(a):
        if isprime:
            yield i
            for n in range(i*i, limit, i):
                a[n] = False

def main():
    random.seed(RAND_SEED)

    # Get input
    N = int(input("Number of abonents -> "))
    k = int(input("Key size (bits) -> "))
    print('---------------')
    
    # Generate parameters (q, p, g) 
    primes = list(primes_sieve(MAX_Q))
    
    q = primes[random.randint(0, len(primes)-1)]
    p = 2 * q + 1
    g = next(filter(lambda x: fpow(x, q, p) > 1, primes))

    print('Parameters:')
    print(f'q = {q}')
    print(f'p = {p}')
    print(f'g = {g}')
    print('---------------')

    # Generate secret key for each abonent
    abonents = list(range(0, N))
    skeys = [random.randint(1, (2 << k) - 1) for _ in abonents]

    # Generate public key for each abonent
    pkeys = list(map(lambda x: fpow(g, x, p), skeys))

    t = PrettyTable([])
    t.add_column('Abonent', abonents)
    t.add_column('Secret key', skeys)
    t.add_column('Public key', pkeys)
    print(t)

    t = PrettyTable(['Z_ij', 'Z_ji'])
    for (i, j) in itertools.combinations(abonents, 2):
        z = lambda skey, pkey: fpow(pkey, skey, p) 
        z_ij = z(skeys[i], pkeys[j])
        z_ji = z(skeys[j], pkeys[i])
        t.add_row([z_ij, z_ji])
        assert z_ij == z_ji
    print(t)

if __name__ == '__main__':
    main()