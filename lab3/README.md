# Практическое задание 3. Шифр Вернама и современные поточные шифры.

## How to run

Необходимо скомилировать исходники в исполняемый файл:

```bash
ghc lab3.hs
```

Предварительно необходимо установить пакет, реализующий шифр RC4:

```bash
cabal install cipher-rc4
```

Затем программа запускается следующим образом:

```bash
./lab3 <rc4 or vernam> <message_file> <key_file> <output_file>
```

## Пример использования

```bash
./lab3 vernam samples/jabba.jpeg key.txt jabba_vernam.enc
```
В итоге получим зашифрованный с использованием шифра Вернама файл `jabba_vernam.enc`

Его можно расшифровать следующим образом:
```bash
./lab3 vernam jabba_vernam.enc key.txt jabba_vernam.jpeg
```

Можно убедиться, что полученный расшифрованный файл совпадает с исходным:

```bash
>> diff -s samples/jabba.jpeg jabba_vernam.jpeg
Files samples/jabba.jpeg and jabba_vernam.jpeg are identical
```
