---
title: "Interview Questions: Probability"
author: Signal Data Science
---

* Bobo the amoeba has a 25%, 25%, and 50% chance of producing 0, 1, or 2 offspring, respectively. Each of Bobo's descendants also have the same probabilities. What is the probability that Bobo's lineage dies out?

	* Form the quadratic $(1/4) + (1/4)p + (1/2)p^2 = p$ and solve.

* In any 15-minute interval, there is a 20% probability that you will see at least one shooting star. What is the probability that you see at least one shooting star in the period of an hour?

	* $1 - (.8)^4$.

* How can you generate a random number between 1--7 with only a die?

	* Enumerate outcomes for rolling the die twice and categorize them as corresponding to 1, 2, ..., 7. For the remainder outcomes (which aren't divisible by 7), reroll.

* How can you get a fair coin toss if someone hands you a coin that is weighted to come up heads more often than tails?

	* Do two flips. H/T and T/H have same probability; repeat if H/H or T/T.

* You have an 50--50 mixture of two normal distributions with the same standard deviation. How far apart do the means need to be in order for this distribution to be bimodal?

	* Add two normal distributions and look at the second derivative, which is strictly less than zero for $|\mu_1 - \mu_2| < 2\sigma$.

* Given draws from a normal distribution with known parameters, how can you simulate draws from a uniform distribution?

	* Look at percentile in the distribution (z-score).

* A certain couple tells you that they have two children, at least one of which is a girl. What is the probability that they have two girls?

	* The possibilities are FF, MF, and FM, so probability is 1/3.

* You have a group of couples that decide to have children until they have their first girl, after which they stop having children. What is the expected number of children each couple will have? What is the expected gender ratio of the children that are born?

	* The expected number of children is $1(1/2) + 2(1/2)^2 + 3(1/2)^2 + \cdots$ which is an [arithmetic-geometric sum](https://en.wikipedia.org/wiki/Arithmetico-geometric_sequence#Sum_to_infinite_terms). Letting $S$ be the sum and $r$ be the common ratio (1/2), the general idea is that you form expressions for $S$ and $rS$, subtract the latter from the former, and divide through by $1-r$. The answer is 2 in this particular case, so the expected gender ratio is 1:1.

* How many ways can you split 12 people into 3 teams of 4?

	* It's $12!/(4!)^3 3!$, where the $3!$ accounts for team ordering and the $4!$ accounts for within-group ordering.

* You call 2 Ubers and 3 Lyfts. If the time that each takes to reach you is IID, what is the probability that all the Lyfts arrive first? What is the probability that all the Ubers arrive first?

	* There are 5! different orderings of the cars in total, 3!2! of which have the Lyfts arrive first, so the probability is $3!2!/5!$. Same for the Ubers because of symmetry in the problem (probability of Lyfts all arriving first equal to probability of Lyfts all arriving last).

* On a dating site, users can select 5 out of 24 adjectives to describe themselves. A match is declared between two users if they match on at least 4 adjectives. If Alice and Bob randomly pick adjectives, what is the probability that they form a match?

	* Suppose we know which adjectives Alice chose. There are (5 choose 4) ways for Bob to choose 4 of Alice's adjectives and 19 ways for Bob to choose an adjective that Alice did not choose. There's also 1 way for Bob to choose all the same adjectives. Then 19 times (5 choose 4) plus 1 divided by # possibilities is the answer.

* A lazy high school senior types up application and envelopes to $n$ different colleges, but puts the applications randomly into the envelopes. What is the expected number of applications that went to the right college?

	* Formally: "what's the expected number of fixed points in a random permutation for some $n$?" Use linearity of expectation. Let $X_i$ be an indicator variable corresponding to whether or not $i$ is a fixed point. Then the number of fixed points is $F = \sum_i X_i$ and $E[F] = E[X_1 + \cdots + X_i] = \sum_i E[X_i]$. Each $E[X_i]$ is equal to $1/n$ so the expected number of fixed points is 1 for all $n$.

* Let's say you have a very tall father. On average, what would you expect the height of his son to be? Taller, equal, or shorter? What if you had a very short father?

	* Closer to the mean in general because of regression to the mean. See the [conceptual examples on Wikipedia](https://en.wikipedia.org/wiki/Regression_toward_the_mean#Conceptual_background).

* What's the expected number of coin flips until you get two heads in a row? What's the expected number of coin flips until you get two tails in a row?

	* [Quora has many solutions.](https://www.quora.com/What-is-the-expected-number-of-coin-flips-until-you-get-two-heads-in-a-row)

* Let's say we play a game where I keep flipping a coin until I get heads. If the first time I get heads is on the $n$th coin, then I pay you $2n-1$ dollars. How much would you pay me to play this game?

	* Expected payoff is $1 (1/2) + 3 (1/2)^2 + 5 (1/2)^3 + \cdots$. This is an arithmetic-geometric sum (see previous question); sum comes out to be 3, so you shouldn't pay more than $3.

* You have two coins, one of which is fair and comes up heads with a probability 1/2, and the other which is biased and comes up heads with probability 3/4. You randomly pick coin and flip it twice, and get heads both times. What is the probability that you picked the fair coin?

	* Probability of HH and fair coin is $(1/2) (1/2)^2$ and probability of HH and biased coin is $(1/2) (3/4)^2$. Divide the former by their sum for $4/13 \approx 0.30769$.

* You have a 0.1% chance of picking up a coin with both heads and a 99.9% chance of picking up a fair coin. You flip your coin and it comes up heads 10 times. What's the probability that you picked the fair coin?

	* Similar to previous question. Probability of picking fair coin and getting 10 heads is $0.999 (1/2)^{10}$ and probability of picking double-head coin and getting 10 heads is 0.001; divide former by their sum for approximately 49%.

* What's the expected number of times you need to roll a 6-sided die until each number comes up at least once?

	* Look at expected *time* for the 1st, 2nd, ... number to show up to get $6/6 + 6/5 + \cdots + 6/1$.