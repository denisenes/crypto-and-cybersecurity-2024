# Практическое задание 1. Реализация атак на шифр в различных сценариях

## How to run

```
ghci lab.hs
```

после чего можно использовать возможности REPL для выполнения необходимых действий.

## Задание 1

Зашифровать:
```haskell
ghci> encryptCaesar 16 "HEYBROTHERHELLO"
"XUORHEJXUHXUBBE"
```

Расшифровать:
```haskell
ghci> decryptCaesar 16 "XUORHEJXUHXUBBE"
"HEYBROTHERHELLO"
```

## Задание 2

Атака по открытому исходному тексту:
```haskell
ghci> attackByOpenText "XUORHEJXUHXUBBE" "HEYBROTHERHELLO"
16
```

## Задание 3

Атака перебором:
```haskell
ghci> attackByBrutforce "XUORHEJXUHXUBBE"
[(0,"XUORHEJXUHXUBBE"),(1,"WTNQGDIWTGWTAAD"),(2,"VSMPFCHVSFVSZZC"),(3,"URLOEBGUREURYYB"),(4,"TQKNDAFTQDTQXXA"),(5,"SPJMCZESPCSPWWZ"),(6,"ROILBYDROBROVVY"),(7,"QNHKAXCQNAQNUUX"),(8,"PMGJZWBPMZPMTTW"),(9,"OLFIYVAOLYOLSSV"),(10,"NKEHXUZNKXNKRRU"),(11,"MJDGWTYMJWMJQQT"),(12,"LICFVSXLIVLIPPS"),(13,"KHBEURWKHUKHOOR"),(14,"JGADTQVJGTJGNNQ"),(15,"IFZCSPUIFSIFMMP"),(16,"HEYBROTHERHELLO"),(17,"GDXAQNSGDQGDKKN"),(18,"FCWZPMRFCPFCJJM"),(19,"EBVYOLQEBOEBIIL"),(20,"DAUXNKPDANDAHHK"),(21,"CZTWMJOCZMCZGGJ"),(22,"BYSVLINBYLBYFFI"),(23,"AXRUKHMAXKAXEEH"),(24,"ZWQTJGLZWJZWDDG"),(25,"YVPSIFKYVIYVCCF")]
```

## Задание 4

Атака при помощи словаря:
```haskell
ghci> attackUsingDictionary "XUORHEJXUHXUBBE"
[(16,"HEYBROTHERHELLO")]
```

Словарь определен как список в исходном коде.