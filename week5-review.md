# Week 5 — "Measuring Relationships" — rework plan

Working document. Nothing in `sessions/week5_lecture.qmd` has been changed yet.
Every number below is computed from the DfE files in this repo, so anything
here can go straight onto a slide.

Agreed direction:

- Retitle to **Measuring Relationship*s*** (plural)
- Keep covariance and correlation, but build them **graphically** out of the
  variance material from week 1
- Keep ANOVA and the between/within variation idea, on the schools data
- Galton and Pearson belong in it — both were UCL
- The current content is not accessible enough; it needs rebuilding around
  graphical output rather than formulae
- Work out how week 5 hands over to regression in week 6

---

## 1. The spine

The lecture currently runs covariance → Pearson → Spearman → ANOVA as four
topics. They are one topic, and naming it makes the whole deck easier to
follow:

> **How much of the variation in one thing is accounted for by knowing
> another?**

That single question orders everything, including the two lectures either side:

| | What varies | What we know | Measure |
|---|---|---|---|
| Week 1 | Attainment 8 | nothing | **variance** |
| Week 5 | Attainment 8 | another number | **covariance → r** |
| Week 5 | Attainment 8 | which group | **ANOVA** |
| Week 6 | Attainment 8 | another number, modelled | **regression** |

Every row is the same decomposition. Week 1 measured the total variation;
weeks 5 and 6 spend the rest of the course carving it up. If that table goes in
early and comes back at the end, the regression handover writes itself
(§5 below).

---

## 2. Covariance, graphically, out of week 1's variance

This is the centrepiece and it replaces the four made-up points currently in
the deck.

Week 1 defined variance as the mean **squared deviation** from the mean. Draw
that literally: a dot plot of Attainment 8, the mean as a vertical line, and
each school's deviation drawn as a *square*. Variance is the average area of
those squares.

Now covariance: instead of one variable's deviation squared, take **two
variables' deviations multiplied**. Put Attainment 8 on one axis and %
disadvantaged on the other, draw the two mean lines so the plot is divided into
four quadrants, and draw each school's **rectangle** back to where the mean
lines cross.

- Rectangles in the top-right and bottom-left are **positive** — both
  deviations share a sign
- Rectangles in the top-left and bottom-right are **negative**
- **Covariance is the mean signed area of those rectangles**

Shade the two signs differently and the sign of the covariance is visible
before any arithmetic: for attainment and disadvantage the negative quadrants
plainly dominate.

Three things then fall out for free, each of which the current deck asserts:

1. **Variance is the special case where the two variables are the same.**
   Every rectangle becomes a square, every area is positive — which is *why*
   variance can never be negative. That is the link back to week 1.
2. **Why the magnitude is meaningless.** The rectangles are measured in
   Attainment-8-points × percentage-points. Rescale either axis and every area
   changes. The existing unit quiz ("what is the unit of covariance between °C
   and calls per minute?") is good and should survive here.
3. **Why normalising fixes it.** Redraw the identical plot with both axes in
   **standard deviations** instead of raw units — week 1 now teaches z-scores,
   so this is a re-use, not a new idea. The cloud of points is unchanged in
   shape; only the axis labels change. The mean signed area of the rectangles
   is now **r**.

That last step is worth stating as an equation because it is short and it is
the whole of Pearson:

$$r = \frac{1}{n}\sum z_x z_y$$

Checked on the data: `cor()` gives **−0.5807**, and the mean product of
z-scores gives **−0.5805** (the gap is only the *n* vs *n−1* convention).
Pearson's r is the average product of standard scores — nothing more. It also
explains the two properties the current checklist asserts without support:
r is unitless because z-scores are unitless, and r is bounded by ±1 because a
variable standardised against itself gives a mean product of exactly 1.

**Keep the checklist device** ("does it exist for all inputs / what does the
sign mean / what is the range / is it normalised / is it symmetric"). It is the
best transferable thing in the deck. It just now has answers that were derived
rather than announced.

---

## 3. Galton and Pearson

Worth doing properly, and not only because of the UCL connection — the history
*is* the explanation of where these ideas came from and why "regression" has
such an odd name.

**Francis Galton** looked at a scatterplot of parents' heights against their
children's heights and noticed the children were consistently *less extreme*
than the parents. He called it "regression towards mediocrity" (1886) and he
coined "correlation" in its statistical sense.

**Karl Pearson** was Professor of Applied Mathematics at UCL from 1884, studied
under Galton, formalised the product-moment correlation coefficient in the
1890s, and in 1911 founded what was the world's first university statistics
department — at UCL.

So the two measures in this lecture were both developed a few hundred metres
from where the lecture is given. That is a genuinely nice thing to be able to
say.

**It cannot be said without the rest of it.** Galton coined the word
"eugenics" and left money in his will for a Chair of Eugenics at UCL; Pearson
was its first holder. Following its Inquiry into the History of Eugenics
(reported February 2020), UCL **denamed** the Galton Lecture Theatre and the
Pearson Building in June 2020, and issued a formal public apology in January
2021.

Suggested handling — one slide, straight, no hand-wringing:

> The two people who gave us correlation and regression developed them in the
> service of eugenics. UCL took their names off its buildings in 2020 and
> apologised in 2021. The methods are indispensable and they are used every day
> for purposes their inventors never imagined. Both of those things are true.
> Knowing where your tools came from is part of using them well.

It also sets up something the course needs anyway: these techniques were built
to measure human difference, which is exactly what students will be doing with
school and neighbourhood data. It is a natural place to plant the idea that a
correlation is not a cause and a group difference is not a group deficiency.

*Sources for the UCL history:* [UCL denames buildings named after
eugenicists](https://www.ucl.ac.uk/news/2020/jun/ucl-denames-buildings-named-after-eugenicists),
[Inquiry into the history of eugenics at
UCL](https://www.ucl.ac.uk/about/leadership/organisation/president-provost/inquiry-history-eugenics-ucl).

---

## 4. ANOVA on the schools data

Currently ANOVA gets motivation, a three-step theory slide, an assumptions
table and a one-way/two-way comparison — but **no worked example, no output
and no figure**, despite being one of the methods the assessment explicitly
offers. It works well on Ofsted ratings:

```
Attainment 8 by Ofsted rating, mainstream secondaries

               Df   Sum Sq   Mean Sq   F value   Pr(>F)
OFSTEDRATING    4    85307     21327       351   <2e-16
Residuals    3183   193385        61
```

| Ofsted rating | n | mean A8 | sd |
|---|---|---|---|
| Outstanding | 468 | 58.0 | 9.6 |
| Good | 2,236 | 46.2 | 7.5 |
| Requires improvement | 408 | 39.7 | 6.4 |
| Serious weaknesses | 44 | 39.7 | 9.3 |
| Special measures | 32 | 37.0 | 9.2 |
| *(grand mean)* | | *46.9* | |

$$\text{SS}_{\text{total}} = \text{SS}_{\text{between}} + \text{SS}_{\text{within}}$$

$$278{,}692 = 85{,}307 + 193{,}385$$

Knowing a school's Ofsted rating accounts for **30.6%** of the variation in
Attainment 8. Which means the other 69.4% is variation *within* rating
categories — and that is the more interesting number to talk about.

The figure to pair with it: the five group distributions (violins or raincloud,
matching week 1's visual vocabulary), grand mean as a horizontal line, group
means marked. Between-group variation is how far the group means sit from the
grand line; within-group variation is how fat each violin is. F is the ratio.
The picture and the formula are then the same object.

Four things this example throws up that are worth keeping rather than smoothing
over:

- **Two groups are tiny** (44 and 32 schools). Good moment to point back at
  week 1's population-vs-sample slide.
- **The group SDs differ** (6.4 to 9.6). The deck already has an assumptions
  table including equal variances — here is a real case where it is strained.
  Better to show students an assumption bending on real data than a clean toy.
- **"Serious weaknesses" and "special measures" have almost the same mean as
  "requires improvement."** The F test says *some* groups differ, not which.
  That is the honest motivation for post-hoc tests.
- **The direction of causation is genuinely ambiguous** — does the rating
  reflect attainment, or drive it? A better discussion than any invented
  example would produce.

---

## 5. The handover to regression — three options

This was the open question. Three ways to do it, in my order of preference.

### Option A (recommended): the standardised slope **is** r

Fit the line to the standardised data and the slope comes out as r exactly.
Verified:

| | |
|---|---|
| r (Attainment 8, % disadvantaged), n = 3,250 | **−0.5822** |
| slope of `lm(scale(A8) ~ scale(FSM))` | **−0.5822** |
| slope of `lm(A8 ~ FSM)`, raw units | −0.3775 |
| r × sd(A8)/sd(FSM) = −0.5822 × 9.334/14.393 | −0.3775 |

So the regression line is not a new idea — it is the correlation, put back into
the original units. And it closes the Galton loop from §3, because:

$$\hat{z}_y = r \cdot z_x$$

Since |r| < 1 **always**, the predicted value is *always* less extreme than the
predictor. A school one standard deviation above average on intake is predicted
just 0.58 standard deviations above average on outcome. That shrinkage is not a
quirk of the data — it is forced by the arithmetic, and it is exactly what
Galton saw in his parents and children. **That is why it is called
"regression".**

It is visible in the schools data too. Using % of high prior attainers as the
intake measure (r = 0.842 with Attainment 8):

| | mean intake z | mean outcome z |
|---|---|---|
| Schools with intake z > +1 (n = 242) | +2.82 | **+2.26** |
| Schools with intake z < −1 (n = 155) | −1.13 | −1.13 |

The upper tail shrinks plainly. The lower tail does not, because the intake
variable has a floor at zero and is badly skewed there — worth saying out loud
rather than hiding, since it is a real illustration of why we looked at
distributions before we looked at relationships.

**Why this is the best link:** it makes week 6 a continuation rather than a new
topic, it pays off the Galton opening, and it re-uses week 1's z-scores for the
third time in the deck. The lecture can end on the same scatterplot it started
with, now with a line through it.

### Option B: ANOVA and regression are the same decomposition

Also true, and also verifiable in one slide. Run the Ofsted ANOVA through
`lm()` instead of `aov()`:

```
aov(ATT8SCR ~ OFSTEDRATING)   F = 351.03 on 4 and 3183 df
 lm(ATT8SCR ~ OFSTEDRATING)   F = 351.03 on 4 and 3183 df,  R² = 0.3061
                       η² = SS_between / SS_total = 0.3061
```

Identical. **ANOVA is regression with a categorical predictor**, and η² is R².
So the total-variation split from §1 covers both.

I would use this as the *punchline of the ANOVA section* rather than as the
handover — a "these were the same thing all along" moment — and let Option A
carry the actual transition. But it could be the main link if you would rather
the bridge came out of ANOVA than out of correlation.

### Option C: r² is R²

r = −0.5822 → r² = **0.3390**, which is exactly the R² week 6 reports for its
bivariate model of Attainment 8 on disadvantage. Cheap to state, useful for
students to recognise the number when it reappears. Worth one line regardless
of which option carries the bridge — but it should not be the bridge on its
own.

**Suggested combination:** Galton opens the lecture (§3) → covariance and r
built graphically (§2) → limitations of r (§6) → ANOVA, ending on the Option B
reveal (§4) → Galton closes it with Option A, and Option C as the final line.

---

## 6. Limitations of r — demonstrate rather than assert

The current three limitations are well chosen (non-linearity, outlier
sensitivity, doesn't work on ordinal/nominal) but are illustrated with
Wikipedia figures. All three are demonstrable on our own variables:

**Non-linearity.** Spearman beats Pearson on both headline relationships, which
is the signature of a relationship that is monotonic but not linear:

| | Pearson | Spearman |
|---|---|---|
| Attainment 8 vs % disadvantaged | −0.581 | **−0.628** |
| Attainment 8 vs % absence | −0.715 | **−0.769** |

And logging both variables pulls Pearson from −0.580 to **−0.668** — the same
log-log move week 6 uses to fit its model, and the one week 1 now introduces
under real-valued multiplicative data. So: *r is a linear measure, this
relationship is multiplicative, so either rank it or transform it.*

**Outlier sensitivity.** Drop the 163 selective schools and r moves from −0.581
to **−0.530** (n falls 3,235 → 2,801). Week 1 ends up naming those schools —
everything beyond three SDs on Attainment 8 is a grammar school — so students
already know exactly who is being removed and why it matters.

**Ordinal data.** `OFSTEDRATING` again, which week 1 now establishes as the
course's ordinal variable, including what goes wrong when software treats it as
a number. Spearman handles it; Pearson does not. This also sits right next to
the ANOVA section, which uses the same variable a different way — worth
pointing out that a variable's type constrains which tool you reach for.

Replacing `np.random.rand(10)` in the Spearman section with this removes the
last of the synthetic examples.

---

## 7. Can GLMs be fitted in anywhere?

Short answer: **they have to be, because the assessment brief already says they
were taught.** This turned out to be less a curriculum question than a live
discrepancy.

### 7.1 The brief promises them and week 8 disclaims them

The assessment brief tells students to use a second-half method, and lists:

> "…some explanatory / predictive methods such as ANOVA, linear regression or
> some of the **generalised linear models also introduced**."

The only mention of GLMs anywhere in ten lectures is a bullet list on week 8's
final "Conclusions" slide, under the heading:

> "Other regression variants (**not yet covered in this course**) might be more
> appropriate in other situations: Generalised Linear Models — Logistic
> Regression… Poisson Regression / Negative Binomial Regression…"

Students read both documents. One says the GLMs were introduced; the other says
they were not covered. That needs resolving either way, and it is a small piece
of work compared with the rest of this plan.

There is also a practical reason beyond tidiness: students choose their own
dataset. A good proportion of social-science outcomes are binary or counts. If
the only modelling tools on offer are OLS, ANOVA, PCA and clustering, a student
whose outcome is "did this happen or not" either mis-applies OLS or abandons
the topic.

### 7.2 Week 1 has already built most of the machinery

This is the piece of luck. The week 1 rebuild now teaches the statistical data
types taxonomy *and* the binomial, Poisson and negative binomial distributions,
including overdispersion. Nothing in the rest of the course ever uses any of
it — every model in weeks 6–8 has a continuous, roughly normal outcome
(Attainment 8 or Progress 8), so OLS is never put under strain.

A GLM is precisely the payoff for that week 1 material, and it fits in one
table:

| Week 1 data type | Distribution | Model |
|---|---|---|
| Real-valued | Normal | OLS — weeks 6–8 |
| Binary / proportion | Binomial | Logistic regression |
| Count | Poisson / negative binomial | Poisson / NB regression |

That single slide *is* the concept. Everything else is worked example.

### 7.3 There is a genuine non-normal outcome already in the repo

`england_ks4-pupdest.csv` — pupil destinations — is sitting in the data folder
unused by any lecture. It gives, for each school, how many of the cohort went
on to a sustained education, employment or training destination. That is a
count out of a known total: a textbook binomial outcome, and a far more
policy-relevant one than anything invented.

Fitted on mainstream secondaries (n = 3,131, median cohort 175):

```
glm(cbind(OVERALL_DEST, not_sustained) ~ PTFSM6CLA1A,
    family = binomial)

logit slope  = −0.0266
odds ratio per +10pp disadvantage = 0.766
```

**Every 10 percentage points more disadvantage is associated with a 23% fall in
the odds of a pupil sustaining a destination.** That is a quotable sentence of
exactly the kind the assessment asks students to produce.

### 7.4 What the comparison actually shows — and what it doesn't

I had expected OLS on the percentage to fail visibly by predicting above 100%.
**It doesn't** — no fitted value exceeds 100 in this sample, so that hook is
not available. What is true is more interesting:

| % disadvantaged | OLS predicts | Binomial GLM predicts |
|---|---|---|
| 0 | 98.3% | 97.0% |
| 25 | 93.8% | 94.3% |
| 50 | 89.3% | 89.5% |
| 75 | 84.8% | 81.4% |
| **100** | **80.4%** | **69.3%** |

The two models agree almost exactly through the middle and diverge by 11
percentage points at the top — in precisely the schools that policy is about.
OLS is not obviously broken; it is quietly wrong at the edges, and nothing in
its output says so. That is a better lesson than a model that falls over,
and it matches the course's existing habit of showing assumptions bending
rather than snapping.

Two further things fall straight out of week 1:

- **49 schools (1.6%) sit at exactly 100%.** A ceiling, which is why a
  straight-line model was always going to struggle up there.
- **The residual deviance is 8,465 on 3,129 df — a ratio of 2.7.** That is
  overdispersion, the exact phenomenon week 1's negative binomial slide now
  introduces. Ignoring it makes the standard errors **1.6× too narrow**, so
  the model reports more confidence than it has earned. Switching to
  `quasibinomial` fixes it in one word. This is the single best payoff
  available for the week 1 distributions material.

### 7.5 Recommendation: an optional extension session, plus two cheap signposts

**This is the better answer**, and it is better than squeezing slides into
week 8, for a reason worth stating plainly: everything in §7.3 and §7.4 above
is good material, and cramming it into the last five minutes of an already
60-slide lecture would waste it. An optional session has no time pressure, so
it can be taught properly — the distributions, the worked example, the
interpretation of an odds ratio, and the overdispersion check, at a pace that
actually lands.

Three further advantages, one of which matters more than the teaching:

- **It touches nobody else's material.** Weeks 2–4 are Bea's and weeks 9–10 are
  Huanfa's. A new standalone session is the only version of this that needs no
  negotiation with anyone.
- **It can absorb the rest of week 8's orphan list.** That conclusions slide
  also names Generalised Additive Models, spatial and geographically weighted
  regression, and ridge/lasso. All of them currently dead-end. An extension
  session turns that slide from a list of things you were not taught into a
  door.
- **It is where "what do I do about *my* data" lives.** Students choose their
  own topic. The session can be framed around the question they will actually
  arrive with — *my outcome is a yes/no, or a count, and week 6's recipe does
  not fit it* — which is a much better hook than "here is another model family".

**Assessment fairness works out fine here**, which is the thing I would have
worried about. The brief offers a *menu* — dimensionality reduction, or
clustering, or ANOVA, or regression, or a GLM. Nobody is compelled to use a
GLM, so an optional session that unlocks one more option disadvantages no one.
That would not be true if GLMs were the only route to a good mark.

**But it does not fix the brief on its own.** "Generalised linear models also
introduced" still implies core taught content, and a student who skipped an
optional session could reasonably feel the brief had misled them. What the
optional session does is make the brief edit *honest and easy* instead of a
retreat — something like:

> "…or one of the generalised linear models covered in the optional extension
> session."

That is a one-line change, it is now true, and it doubles as advertising for
the session.

**Keep one signpost in the core material.** The week 5 slide from the spine
table (§1) is free and worth having regardless: *we have been decomposing the
variation in a continuous outcome; when the outcome is a count or a yes/no,
the same logic holds but the arithmetic changes — see the extension session.*
One sentence, no method taught. And week 8's conclusions slide changes from
"not yet covered in this course" to a link.

**Where it goes in the repo.** `_website.yml`'s schedule sidebar is already
sectioned ("Part 1: Basics", "Part 2: Correlation and Regression"), so this is
a new section — "Extension material" or similar — below the ten weeks. No
structural change, and it reads correctly as sitting outside the taught course.

**The one risk** is that optional material gets no engagement. Three things
help: signpost it from week 8's conclusions slide at the moment students are
told these methods exist; signpost it from the brief where they are choosing a
method; and give it the destinations example rather than a toy, so the first
slide answers a real question.

### 7.6 What I would not do

Squeeze GLMs into weeks 6 or 7. They are 80 and 70 slides already, they are
building one continuous argument towards the Brighton policy conclusion, and
interrupting that to change outcome types would cost more than it teaches.

Leave the brief and week 8 contradicting each other. Whichever route is taken,
that one line needs editing.

---

## 8. Decisions to work through

Roughly in the order they would need settling:

1. **Retitle** to "Measuring Relationships" — and CASA theme
   (`../css/casa-slides.scss`), which weeks 6–10 use and this deck does not.
2. **Does the Galton/eugenics slide go in, and in those words?** My draft in §3
   is a starting point, not a proposal — this is your call and your framing.
3. **How far to take the covariance rectangles.** Full build across several
   slides (squares, then rectangles, then restandardised), or one static
   three-panel figure? The former teaches better; the latter is less to build
   and less to talk over.
4. **Which bridge to regression** — A, B, or both as suggested.
5. **Is the covariance→correlation argument still the opening move?** It is the
   strongest thing in the current deck ("Cov(A,B) = −0.39, Cov(A,C) = −0.01 —
   which pair is more closely related? You can't say"). The rebuild keeps it
   but reaches it through pictures instead of a table.
6. **How much ANOVA?** Currently a fifth of the deck with no example. With a
   worked example and a figure it becomes closer to a third. Does two-way ANOVA
   survive, or become a pointer to week 6's multiple regression?
7. **The orphaned variance slide** still says "Denote city population by…",
   which was week 1's example before the rebuild. Under this plan it gets
   rewritten into the §2 opening anyway.
8. **Post-hoc tests** — mentioned nowhere currently. The Ofsted example makes
   the need obvious. In, or out of scope?

---

## 8. The practical

Already on the schools data — it plots `PERCTOT` against `ATT8SCR`, does
Pearson and Spearman, builds a correlation matrix and runs an ANOVA across
local authorities. So it needs far less work than week 1's did. Three things:

- **It reads `england_filtered.csv` from a
  `raw.githubusercontent.com/huanfachen/QM/…` URL.** That points at upstream,
  so it will never see changes made in this fork, and it needs a live network
  connection in the lab. Week 1's practical reads the local file. Week 9's
  practical has the same problem.
- **Python only.** The `multicode` filter is already in the repo and both the
  correlation and ANOVA calls have direct R equivalents, so the weeks 6–8
  treatment is available cheaply if you want it.
- If the lecture ends on the standardised-slope identity, the practical is the
  obvious place to have students *verify* it — compute r, fit the line to
  standardised variables, confirm they match. It is two lines of code and it
  makes the week 6 handover something they did rather than watched.

---

## 9. Smaller fixes

- Typos: "Assuem" (Crisis of covariance), "ourliers" (twice, Spearman section
  headings), "Motivated continued".
- Week 1 now promises this lecture by name: *"Coming up in week 5. ANOVA asks
  whether the differences between group means are large compared with the
  spread within the groups."* Worth paying off in the opening.
