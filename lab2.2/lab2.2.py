from hashlib import sha256
import time

def pretty_binary(v: int) -> str:
    return '{0:b}'.format(v)

def measure(foo):
    start_time = time.time()
    result = foo()
    end_time = time.time()
    return (result, end_time - start_time)

def h(v: str) -> int:
    hsh = sha256(sha256(v.encode('ascii')).digest())
    return int(hsh.hexdigest(), 16)

def mine(VALUE: int, k: int) -> int:
    MASK  = (1 << k) - 1
    NONCE = 0
    while True:
        block_hash = h(VALUE + str(NONCE))
        if block_hash & MASK == 0:
            return (block_hash, NONCE)
        NONCE += 1

def find_k(value: int, t: int) -> int:
    k = 1
    while True:
        ((bhash, nonce), t_exec) = measure(lambda: mine(value, k))
        print(f'Experiment with k={k}: HASH={pretty_binary(bhash)}, NONCE={nonce}, t_exec={t_exec:0.2f}')
        if t_exec >= t:
            return k
        k += 1

def main():
    value = 'Am I some bitcoin transaction??'
    t = int(input("Expected time -> "))

    k = find_k(value, t)
    print(f'Found k: {k}')
    print(f'-----------------------')

    while True:
        value = value + '?' # Mutate value
        ((bhash, nonce), t_exec) = measure(lambda: mine(value, k))
        print(f"Hash: {bhash}, Nonce: {nonce}, Time: {t_exec:0.2f} sec")

if __name__ == "__main__":
    main()