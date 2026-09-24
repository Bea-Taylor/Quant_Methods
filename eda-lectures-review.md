# Lectures 1 and 2 — making one coherent EDA series

Written after reading both decks in full: `week1_lecture.qmd` (63 slides, rebuilt
this term) and `week2_lecture.qmd` at Bea's `L2 restructure` commit (60 slides).
Nothing in either file has been changed.

---

## 1. The short version

The two lectures do not currently disagree so much as **fail to divide the
work**. Each is coherent on its own, but there is no stated principle that says
what belongs where, so four topics get taught twice and one gets taught in the
wrong order.

There is also a larger problem than the repetition: **they look like they come
from different courses.**

| | Lecture 1 | Lecture 2 |
|---|---|---|
| Code chunks | 33 R, 0 Python | 0 R, 7 Python |
| References to the schools data | 76 | **0** |
| Examples | DfE school performance throughout | Coin tosses, horse kicks, chess and rice, rabbits, bike-share, a council survey |

A student sees the course dataset introduced as "our dataset for the term",
used for an hour, and then not mentioned again the following week.

---

## 2. A principle that divides them cleanly

The cleanest line I can find, and the one that needs the least surgery:

> **Lecture 1 — "What have I actually got?"**
> Describing the data in front of you. Empirical, concrete, all schools data.
>
> **Lecture 2 — "What is it a sample of, and what shape lies behind it?"**
> Moving from the observed data to the process that produced it. Theoretical,
> and about whether your data represents anything.

Under that split the handoff is already half-built. Bea's "When descriptive
statistics aren't enough" opening, and the Anscombe's quartet slide, are
**exactly the right pickup** from week 1 — they take what week 1 taught and show
its limits. That is a genuine handoff rather than a repetition, and it should
survive untouched.

The distributions are where the principle does real work:

- **Lecture 1 names distributions as labels for data types.** *"This variable is
  a bounded count, which makes it binomial - and that is why a percentage is the
  natural summary."* One line, recognition only, no maths.
- **Lecture 2 teaches distributions as probability models.** Parameters, PMF and
  PDF, calculating probabilities with them.

Recognition in week 1, mechanics in week 2. That is a line students can feel,
and it is defensible when either of you is asked "why are we doing this twice?"

---

## 3. The four things currently taught twice

### 3.1 Histograms — the clearest case, and the easiest fix

| | |
|---|---|
| **Week 1** | "What is a distribution?" - a three-panel build going points → bins → density curve. Then "A boxplot is a summarised histogram". |
| **Week 2** | A `# Histograms` section that is one sentence long, with a speaker note reading *"Need a slide to show how to make a histogram in Python."* |

Week 1 already does this properly and visually. **Week 2's histogram section can
go**, and the missing Python slide never needs writing — it belongs in a
practical anyway. Week 2's "See it in histograms" slide, which shows the Normal
*specifically*, should stay; that is a different job.

### 3.2 Binomial and Poisson — taught in both, differently

Week 1 mentions Poisson 9 times and binomial 13 times, across `## Count`,
`## Binomial` and `## Negative binomial`. Week 2 then teaches Binomial and
Poisson from scratch with coin tosses and horse kicks.

Applying §2's principle:

- **Week 1 keeps `## Count` and `## Binomial`** but trimmed to the naming job -
  what the data type is, which distribution goes with it, why that changes the
  natural summary. No variance/mean arithmetic.
- **`## Negative binomial` is the one slide that breaks the rule.** It computes a
  variance-to-mean ratio and explains overdispersion - that is mechanics, in
  week 1, for a distribution week 2 does not cover at all. Options: move it to
  week 2 alongside Poisson, or move it forward to the GLM lecture where
  overdispersion is actually used. I would move it to the **GLM lecture** - it
  has no work to do in week 1 and it is the payoff for the Poisson material
  there.
- **Week 2 keeps the full treatment** but should reach for the schools data at
  least once per distribution (see §4).

### 3.3 Logs and transformation — fine, but make the seeding explicit

Week 1's `## Real-valued multiplicative` shows absence on a log-scaled axis with
mean and median marked. Week 2 then has a substantial section: exponentials,
chess and rice, rabbits, natural logs, *"Log it! to straighten growth"*,
*"Log it! to tame long tails"*.

This is not really duplication - week 2 is far deeper and better placed. But
neither slide acknowledges the other. **One sentence in each** fixes it: week 1
saying *"there is a reason this axis works, and we come back to it next week"*,
week 2 saying *"remember the absence data from last week - this is why that
axis helped"*.

### 3.4 Representativeness — overlapping, and week 1's version is stronger

Week 1 has `## Careful — we have just changed what we are studying` and
`## Dropping cases is a decision, not a technicality`, both arising naturally
from subsetting to mainstream schools. Week 2 has a nine-slide section on
representative data, bias, selection bias, historical bias and cognitive bias.

These are not the same point, but they will feel like it. The distinction worth
drawing:

- **Week 1: you changed the population by what you filtered.** A concrete thing
  the students just watched happen, to a real dataset.
- **Week 2: the data was never the population to begin with.** Bias in how the
  data came to exist at all.

Week 2's section would land much harder if it **opened by referring back** to
what week 1 did - *"last week we dropped the special and independent schools and
watched the headline number move. That was us introducing bias deliberately.
Now: what about the bias that was already there?"*

---

## 4. The dataset problem

This is the thing I would fix first, ahead of any of the repetition.

Week 2 uses no schools data at all. The textbook examples are individually good
- horse kicks is the classic Poisson story and worth keeping for its own sake -
but **every single one is borrowed**, and the course dataset vanishes for a
week.

It does not need rewriting. It needs **one schools example per distribution**,
placed after the textbook one:

| Distribution | Keep the classic | Add from our data |
|---|---|---|
| Normal | UCL heights | Attainment 8 across mainstream schools - already plotted in week 1 |
| Binomial | Coin toss, council survey | Disadvantaged pupils out of cohort - week 1's own `## Binomial` slide |
| Poisson | Death by horse kicks | Below-Good schools per local authority, or absences per pupil |
| Exponential | Bike-share arrivals | *(no natural one - leave it borrowed)* |

That way the classic example teaches the idea and the schools example proves it
was not a toy. It is maybe four slides of work, and it makes the fortnight feel
like one course.

**The language split matters less**, but is worth a decision. Week 1 is 33 R
chunks, week 2 is 7 Python. Both are legitimate - the course teaches both - but
if all the code a student sees in week 1 is R and all of it in week 2 is Python,
that should be a stated choice ("we will show you both, alternating") rather
than an accident of who wrote which deck.

---

## 5. One genuine ordering problem

Week 1's `## When is the mean a good summary?` says:

> *"Mean a better summary when variance is small and distribution normal... if
> the data are roughly normal, about **two thirds** of observations sit inside
> the shaded band"*

That is the 68% rule, and it depends on the Normal distribution - which **week 2
teaches**. Week 1 never defines "normal" anywhere; I checked, the phrase appears
nowhere else in the deck.

Three ways out, in my order of preference:

1. **Leave it, and flag it as a forward reference.** Add half a sentence: *"we
   are leaning on a property of the normal distribution here - Bea will make
   this precise next week"*. Costs nothing, and gives week 2 something to pay
   off.
2. Move the two-thirds claim into week 2 and have week 1 make the point purely
   visually - the bands are visibly different widths without needing the 68%
   figure at all.
3. Define the Normal briefly in week 1. I would not - it drags theory into the
   descriptive lecture and undoes §2.

---

## 6. Week 2's "Last week" slide is now out of date

It currently recaps: data types, key metrics, visualising, outliers. The speaker
notes say *"4 data types: nominal, ordinal, interval, ratio / Numerical vs
categorical"*.

Week 1 has moved on from that. It now also covers the finer statistical data
types beyond Stevens, distributions, counts and rates, standard scores, and
missingness as information. The numerical-vs-categorical framing was
**deliberately dropped** from week 1 this term.

Week 1's own closing `# Overview` slide is an accurate summary of what it now
contains, and would make a better basis for the recap.

---

## 7. Suggested running orders

Nothing here is a rewrite - it is moves, trims and a handful of new slides.

**Lecture 1 — What have I got?** *(largely as-is)*

1. The dataset · what a row looks like · Attainment 8
2. Data types - Stevens, then the finer statistical types
3. Distributions as **observed shapes** - histogram build, boxplot as summarised histogram
4. The named types with their distributions, **recognition only** *(trim `## Negative binomial` out to the GLM lecture)*
5. Centre and spread · when the mean works *(+ forward reference to the Normal)*
6. Making things comparable - counts, rates, z-scores
7. Missingness and outliers
8. Population vs sample from subsetting → **hands to week 2**

**Lecture 2 — What lies behind it?**

1. Recap *(rewritten from week 1's actual Overview)*
2. When descriptive statistics aren't enough · Anscombe *(keep exactly as is - this is the best handoff in either deck)*
3. ~~Histograms~~ *(cut - week 1 covers it)*
4. Probability distributions - continuous vs discrete, the key-distributions table
5. Normal · Binomial · Poisson · Exponential, **each with a schools example added**
6. Exponentials and logarithms · transforming data *(+ callback to week 1's absence axis)*
7. Representative data and bias *(+ opening callback to week 1's subsetting)*
8. Overview

---

## 8. Smaller things

- **Week 2 has five parked sections** commented out: the scientific method,
  exploratory data analysis, introducing statistical concepts, motivation, and
  exploring the data. Worth deciding whether any come back - "what *is* EDA?"
  is arguably missing from both decks, and would sit naturally at the top of
  week 1.
- **Week 1 has no `chalkboard: true`** in its front matter; week 2 does, as do
  weeks 6-8. Trivial, but worth matching.
- **Week 2's dates** say 13th October 2026, week 1 says 18 September 2026.
  Worth a check that the gap is right once the term dates are fixed.
