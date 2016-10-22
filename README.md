# experiment-a0z1

Encoding data in free verse where one letter = one bit

My first instinct was that an even-odd modulus operation would give good enough distributon: however, a quick recitation of the alphabet skipping every other letter ("A, C, E, G, I, K, M, O, Q, S, U, W, Y") indicates that this would not be the case, as *all five natural vowels* featured in nearly every English word have the same mod-two value (all are either even or odd, depending on whether you start your count at zero or one).

In light of that likely inadvertent property of the alphabet's order, I fell back to what would probably be the simplest, most naive approach to divide the alphabet: literally just dividing it in half and making all letters from A through M correspond to 0, and N through Z to 1. While this puts the three most used vowels (A, E, and I) on the same side, it still leaves two vowels (O and U) for the other bits.
