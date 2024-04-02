# Практическое задание 2. Вычисление информационной энтропии файла.

## How to run

Необходимо скомпилировать 2 исполняемых файла:

```bash
ghc lab2.hs
ghc filegenerator.hs
```

## Генератор файлов

Как использовать:

```bash
./filegenerator
```
После выполнения программы в директории появятся 3 файла:
* onlyA.txt -- файл, содержащий 10000 одинаковых символов
* random0or1.txt -- файл, содержащий случайную последовательность 0 и 1
* randomASCII.hs -- файл, содержащий случайную последовательность байтов

## Вычисление энтропии

Как использовать:

```bash
./lab2 <имя_файла>
```

После исполнения программы в консоль напечатается полученная энтропия.

Примеры исполнения:

```bash
>> ./lab2 samples/onlyA.txt
Entropy of samples/onlyA.txt = 0.0
```

```bash
>> ./lab2 samples/random0or1.txt 
Entropy of samples/random0or1.txt = 0.9999626050214436
```
* log2(2) = 1

```bash
>> ./lab2 samples/randomASCII.txt 
Entropy of samples/randomASCII.txt = 7.982527782850108
```
* log2(256) = 8

```bash
>> ./lab2 samples/1a3n.pdb       
Entropy of samples/1a3n.pdb = 3.3782812826960864
```

```bash
>> ./lab2 samples/1a3n.zip
Entropy of samples/1a3n.zip = 7.982559990422653
```
