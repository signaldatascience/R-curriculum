Notation: Let $f_X(x)$ denote the probability density of $X$ and $f_{XY}(x, y)$ denote the joint probability density of $X$ and $Y$.

We are given $f_X(x) = 1$ and $f_{Y \mid X=x}(y, x) = 1/x$. Our goal is (1) to evaluate $f_{X \mid Y=y}(x, y)$ and (2) to evaluate the expected value of that conditional probability distribution.

In general, we have

$$f_{XY}(x, y) = f_{Y \mid X=x}(y, x) f_X(x) = f_{X \mid Y=y}(x, y) f_Y(y).$$

As such, we can calculate

$$f_{XY}(x, y) = 1 \cdot (1/x) = 1/x.$$

In general, it is true that

$$f_Y(y) = \int \! f_{XY}(x, y) \, \mathrm{d}x.$$

For some given value of $X=x$, $Y$ is drawn from the range $[0, x]$. We can conversely say that for some given value of $Y=y$, $X$ is drawn from the range $[y, 1]$. As such, we integrate $x$ from $y$ to 1, and we have

$$f_Y(y) = \int_y^1 \! \frac{1}{x} \, \mathrm{d}x = \left. \left( \ln x \right) \right|_y^1 = - \ln y.$$

Now, we can calculate

$$f_{X \mid Y=y}(x, y) = \frac{f_{Y \mid X=x}(y, x) f_X(x)}{f_Y(y)} = \frac{(1/x) \cdot 1}{- \ln y} = - \frac{1}{x \ln y}.$$

Finally, we calculate the expected value by evaluating another integral.

$$\mathbb{E}(X \mid Y = y) = \int_y^1 \! x \cdot f_{Y \mid X=x}(y, x) \, \mathrm{d}x = \int_y^1 \! - \frac{1}{\ln y} \, \mathrm{d}x = \frac{y-1}{\ln y}.$$