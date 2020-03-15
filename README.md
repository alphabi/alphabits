# experiment-a0z1

Encoding data in free verse where one letter = one bit

My first instinct was that an even-odd modulus operation would give good enough distributon: however, a quick recitation of the alphabet skipping every other letter ("A, C, E, G, I, K, M, O, Q, S, U, W, Y") indicates that this would not be the case, as *all five natural vowels* featured in nearly every English word have the same mod-two value (all are either even or odd, depending on whether you start your count at zero or one).

In light of that likely inadvertent property of the alphabet's order, I fell back to what would probably be the simplest, most naive approach to divide the alphabet: literally just dividing it in half and making all letters from A through M correspond to 0, and N through Z to 1. While this puts the three most used vowels (A, E, and I) on the same side, it still leaves two vowels (O and U) for the other bits.

## Using these tools

### Generating words-by-alphabi reference lists

Make sure you have Lua 5.1 or greater installed, as well as a wordlist at `/usr/share/dict/words`. (On Ubuntu, this can be achieved with `sudo apt-get install lua wamerican`.)

Then, to generate word lists based on the naive alphabinarization of the wordlist (where all characters outside the basic alphabet, including accented characters as well as punctuation, are ignored):

```sh
mkdir bitdicts
lua init/dictgen.lua
```

This will populate the `bitdicts` directory with files by the name of the bits that each word in the wordlist corresponds to in alphabinary (so, for instance, `bitdicts/1000001111011` would contain the words "officiousness" and "salaciousness", assuming they were in your initial wordlist).

### Finding words to correspond to bits

The `listwords.lua` tool outputs the combination of all the words in lists of bits from the beginning of a given bit sequence, in ASCIIbetical order (assuming the input wordlist the bitdicts were built from was also in this order). For example:

```sh
lua listwords.lua 011101101
```

would produce the same outputs as:

```sh
cat bitdicts/0 bitdicts/01 bitdicts/011 bitdicts/0111 \
    bitdicts/01110 bitdicts/011101 bitdicts/0111011 \
    bitdicts/01110110 bitdicts/011101101 | sort
```

To find words that fit from the *right* side of a bit sequence, you can pass
`listwords.lua` the `-r` flag before the sequence:

```sh
lua listwords.lua -r 011101101
```

This would yield the same results as:

```sh
cat bitdicts/1 bitdicts/01 bitdicts/101 bitdicts/1101 \
    bitdicts/01101 bitdicts/101101 bitdicts/1101101 \
    bitdicts/11101101 bitdicts/011101101 | sort
```
