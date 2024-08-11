# Permutations and Combinations

### 1. Basic Formulas

- **Permutation**: $nP_r = \frac{n!}{(n-r)!}$
- **Combination**: $nC_r = \frac{n!}{(n-r)! \cdot r!}$

### Example: Probability of Getting an Ace if You Draw 5 Cards

The probability of getting an ace if you draw 5 cards is calculated as:

```math
P(\text{ace if draw 5 cards}) = 1 - P(\text{no ace if draw 5 cards})
```

```math
P(\text{ace if draw 5 cards}) = 1 - \frac{{48C5}}{{52C5}} \approx 0.341
```

---

# Bayesian Probability

### Q1: Expensive Phone Plan

Among customers, only 0.1% have an expensive phone plan. A classification model predicts whether a customer will choose this plan.

- $P(\text{Customer expensive phone plan}, A) = 0.1\%$
- $P(\text{Model predicts expensive phone plan}, B \mid \text{customer cheap phone plan}, A') = 10\% $
- $P(\text{Model predicts cheap phone plan}, B' \mid \text{customer expensive phone plan}, A) = 0\% $

Find $P(\text{Customer expensive phone plan}, A \mid \text{Model predicts expensive phone plan}, B)$.

Using Bayes' Theorem:

```math
P(A \mid B) = \frac{P(B \mid A) \cdot P(A)}{P(B)}
```

Therefore:

```math
P(B \mid A) = 1 - P(B' \mid A) = 100\% - 0\% = 100\%
```

```math
P(A) = 0.1\%
```

```math
P(B) = P(B \mid A') \cdot P(A') + P(B \mid A) \cdot P(A)
```

```math
P(B) = 10\% \cdot 99.9\% + 100\% \cdot 0.1\% = 0.1009
```

Hence:

```math
P(A \mid B) = \frac{100\% \cdot 0.1\%}{0.1009} \approx 0.099 \approx 9.9\%
```

### Q2: Meteorologist's Prediction

Historical data shows it rains 5 days per year in a desert region. A meteorologist predicts rain today.

- $P(\text{rain}, A) = \frac{5}{365}$
- $P(\text{Model predicts rain}, B \mid \text{rain}, A) = 90\%
- $P(\text{Model predicts rain}, B \mid \text{no rain}, A') = 10\%

Find $P(\text{Rain}, A \mid \text{Model predicts rain}, B)$.

Using Bayes' Theorem:

```math
P(A \mid B) = \frac{P(B \mid A) \cdot P(A)}{P(B)}
```

Therefore:

```math
P(B \mid A) = 90\%
```

```math
P(A) = \frac{5}{365}
```

```math
P(B) = P(B \mid A') \cdot P(A') + P(B \mid A) \cdot P(A)
```

```math
P(B) = 10\% \cdot \frac{360}{365} + 90\% \cdot \frac{5}{365} = \frac{81}{730}
```

Hence:

```math
P(A \mid B) = \frac{90\% \cdot \frac{5}{365}}{\frac{81}{730}} = \frac{1}{9} \approx 11.1\%
```
