# CASA0007 — review of the ten-week lecture course

Working notes, written September 2026 ahead of the week 1 rewrite. Based on
reading all ten `sessions/week*_lecture.qmd` files in full, plus
`assessments/index.qmd` and `sessions/index.qmd`.

---

## 1. The course as it currently stands

| Wk | Topic | Author | Data used | Live code | Slide theme |
|----|-------|--------|-----------|-----------|-------------|
| 1 | Exploratory Data Analysis 1 | Huanfa | US city population (hard-coded), Null Island | none | bare revealjs |
| 2 | Exploratory Data Analysis 2 | Bea | student heights, Anscombe's quartet | 3 Python | bare revealjs |
| 3 | Hypothesis testing | Bea | student heights, coin, NHS mammograms | 2 Python | bare revealjs |
| 4 | Linear algebra | Bea | none | none | bare revealjs |
| 5 | Measuring relationship | Huanfa | random numbers; schools mentioned | 6 Python | bare revealjs |
| 6 | Regression 1 | Adam | **DfE schools** | 41 R | CASA |
| 7 | Regression 2 | Adam | **DfE schools** | 32 R | CASA |
| 8 | Regression 3 (LME) | Adam | **DfE schools** | 42 R | CASA |
| 9 | Dimensionality reduction | Huanfa | **DfE schools** | 7 Python | CASA |
| 10 | Clustering | Huanfa | schools (images only) | none | CASA |

Two things jump out of that table before any judgement about content.

**The DfE schools data only becomes the spine in week 6.** Weeks 1–4 use five
unrelated toy datasets. Your instinct to move week 1 onto the schools data is
well-founded: it would give the course a single worked example that students
meet in week 1 and are still using in week 10, and it removes the jolt at week 6
where everything suddenly changes.

**The course splits visually down the middle.** Weeks 1–5 are bare revealjs;
weeks 6–10 use `casa-slides.scss`. Students will see two different-looking
courses. Since the theme is one line of front matter, this is cheap to fix and
worth doing whoever rewrites what.

---

## 2. What works well

Worth saying, because the gaps below shouldn't imply the course is weak.

- **The regression arc (6–8) is genuinely excellent.** One real policy question,
  carried across three weeks, with the model getting progressively less naive
  and the *interpretation* getting progressively more careful. The Brighton
  overfitting demo — nudge three schools, watch the relationship evaporate — is
  the best single teaching moment in the course.
- **Week 3's framing of hypothesis testing** as five mechanical steps, with the
  coin example returned to at the end, is clean and memorable.
- **Week 2's honesty about bias** (cognitive, historical, selection, "can data
  ever be truly representative? Probably not") is unusually good and sets an
  ethical tone the rest of the course benefits from.
- **Huanfa's "checklist when you learn a new metric"** in week 5 — does it exist
  for all inputs, what does the sign mean, what's the range, is it normalised,
  is it symmetric — is a transferable habit, not just a fact. It deserves to be
  used more than once.

---

## 3. Gaps

Ranked by how much they cost students, judged against what the assessment
actually asks for.

### 3.1 Generalised linear models are assessed but never taught

This is the one to fix first. `assessments/index.qmd` tells students they may use:

> *"...some explanatory / predictive methods such as ANOVA, linear regression or
> some of the generalised linear models **also introduced**."*

GLMs are never introduced. The only mention in ten lectures is week 8's closing
slide listing them under methods **"not yet covered in this course"** —
logistic, Poisson, negative binomial, GAMs.

A student with a binary or count outcome — which is most urban/social data —
reads the brief, believes logistic regression is fair game, and finds no
teaching anywhere. Either the brief should stop promising it, or a GLM needs a
home. Given Poisson distributions are already taught in week 2 and the
regression machinery is in place by week 7, Poisson/logistic regression is a
much smaller addition than it looks.

### 3.2 No confidence intervals, anywhere

Students learn p-values (week 3) and standard errors (weeks 2, 6), but the
phrase "confidence interval" appears exactly once in ten weeks — week 8, in
passing, about caterpillar plots.

For a course whose assessment is a *public-facing* article, this is the wrong
omission. "Somewhere between 2 and 5 points" communicates to a general reader;
"p < 0.05" does not. CIs are also the standard way to show uncertainty on a
chart, which the assessment explicitly rewards. This would sit naturally at the
end of week 3, built from the standard error material already in week 2.

### 3.3 Chi-square is referenced twice but never taught

Week 5 mentions it as Pearson's other contribution. Week 6's test-selection
flowchart routes two categorical variables to "Chi Squared or Similar". Neither
teaches it. A student following the flowchart hits a dead end. It's a short
addition to week 3, alongside the other tests.

### 3.4 Missing data is used but never explained

Week 1 covers nulls conceptually (good). But week 9 then runs `KNNImputer`
on the school data with no explanation of what imputation is, why it's needed,
or what it risks. Students doing their own analysis will hit missingness
immediately and have no framework beyond "drop it".

The DfE data is ideal for teaching this, because its missingness is *meaningful*
— `SUPP` (suppressed for small numbers), `NE`, `LOWCOV`. That's a much better
lesson than a generic one: the reason a value is missing is itself data, and
suppression is disclosure control, not an error.

### 3.5 Nothing on rates vs counts, or the ecological fallacy

No lecture mentions per-capita normalisation, rates vs raw counts, or the
ecological fallacy / MAUP. For a cohort of urban studies students producing
area-level analyses, the ecological fallacy is the single most likely
inferential error they will make — and the schools data invites it directly
(school-level disadvantage → conclusions about individual pupils, which is
precisely what weeks 6–8 are careful about in practice but never name).

"Big places have big numbers" is the most common failure in student data
journalism, and it costs one slide to inoculate against.

### 3.6 Data visualisation is assessed heavily but taught thinly

The mark scheme rewards visual communication; the brief asks for "a range of
graphical or tabular elements" and outputs "appropriate for a general
audience". The teaching is one FT Visual Vocabulary slide in week 1 and a
boxplot.

Given you want week 1 to be visual anyway, this is an opportunity rather than a
problem: the choices you make *while* showing the schools data (why a histogram
here, why a boxplot there, why this is the wrong chart) can carry the lesson
without a separate lecture.

### 3.7 Smaller ones

- **Statistical power** — Type I/II errors are covered well in week 3, but
  power and sample size never come up. One slide in week 3 would close it.
- **Time series** — nothing on temporal change, trends or seasonality. Much
  FT-style data journalism is time series. May be a deliberate scope decision;
  flagging it as a choice rather than an oversight.
- **Week 10 is thin relative to the others** — 230 lines against 750–2,200
  elsewhere, no live code, all static images. Clustering deserves the same
  treatment PCA gets in week 9.

---

## 4. Coherence issues

### 4.1 Duplication across weeks

- **Variance and standard deviation** are defined in week 1 and then defined
  again in week 5 — the same formula block with the same "city population"
  notation, apparently copy-pasted. If week 1 moves to schools data, week 5's
  copy will be orphaned, still talking about city populations.
- **The descriptive-statistics list** (n, mean, median, mode, sd, range)
  appears three times: week 1, week 2 ("What to declare"), week 5 ("Back to
  W1"). Once as teaching and twice as recap is defensible; three near-identical
  lists is not.
- **Correlation example grids** appear in week 5 and week 6 from two different
  sources, illustrating the same point.

### 4.2 Recaps are inconsistent

Weeks 2, 3, 4, 5, 9 and 10 open with a "Last week" recap. Weeks 6, 7 and 8
don't — they recap internally instead. Not wrong, but a student notices.

### 4.3 Three voices

Huanfa: terse, checklist tables, quiz slides, unit-analysis questions.
Bea: narrative, heavy imagery, incremental reveals, strong speaker notes.
Adam: long-form, applied, live model output, branded.

Variety is fine and arguably good. But it's worth a conversation about a shared
minimum — theme, recap slide, learning objectives, key takeaways — so the
course reads as one course. Weeks 1–5 have "Learning Objectives" slides;
weeks 6–8 don't.

---

## 5. Sequencing

Mostly sound. Two observations:

- **Week 2 uses logs and exponentials heavily; week 4 then teaches functions,
  domain and range.** The formal machinery arrives two weeks after it was
  needed. Defensible (week 2 is motivating, week 4 is consolidating), but if
  students find week 2 hard, this is why.
- **Week 4 (linear algebra) is well placed** immediately before the regression
  block, and the "maths to English" translation of the GWR paper equations is a
  good payoff. Keep that.

---

## 6. Notes specific to the week 1 rewrite

Things I noticed in `week1_lecture.qmd` that bear on what you're about to do.

**Structural**

- There is **no code at all** — every figure is a static image. Weeks 2, 5 and 9
  all run live Python. Moving week 1 to live, executed examples on the schools
  data brings it in line and makes the "here is the actual data" point for you.
- **The slide `## Boxplot for comparing multiple datasets` is empty** — header
  and nothing else. A genuine hole, and precisely where a schools example (e.g.
  Attainment 8 by school type, or by region) would land well.
- **`## Quiz time` is an empty placeholder** with a speaker note saying
  "Mentimeter quiz".
- **The outliers taxonomy is built by repeating the same four-row table three
  times**, each time filling one more row. It works as a reveal, but it's three
  slides of near-identical markdown and hard to edit.
- **The US city population example is hard-coded prose** — "282 values, mean
  302869.3, median 167744.5" — with no data shown and no source given. Students
  can't see what's being described, which is exactly the problem you want to fix.

**The bimodal histogram is your best argument**

Week 6 has a histogram of Attainment 8 across all English schools that is
visibly bimodal, because special schools and independent schools are mixed in
with mainstream ones. Adam then filters them out and the distribution becomes
sensible.

That is a far better week 1 hook than any toy dataset: it shows *why* you look
at the shape of data before computing anything, and it makes mean-vs-median,
outliers and data types all fall out of one real example. It also plants a seed
that pays off in week 6.

**Data types map onto the schools data cleanly**

- Nominal — `MINORGROUP`, `RELCHAR`, `gor_name`, `ADMPOL_PT`
- Ordinal — `OFSTEDRATING` (Outstanding → Special Measures)
- Interval — `OFSTEDLASTINSP` (dates)
- Ratio — `ATT8SCR`, `TOTPUPS`, `PTFSM6CLA1A`, `PERCTOT`

`P8MEA` (Progress 8) is a nice edge case worth a slide: it's a value-added score
centred on zero, so the zero *is* meaningful but it isn't a ratio scale — you
can't say a school with 1.0 is "twice as good" as one with 0.5. Good for
puncturing the assumption that "has a zero" means "ratio".

**Null values are better taught here than with Null Island**

The Null Island slides are charming and I'd keep them. But the DfE data has
`SUPP`, `NP`, `NE`, `LOWCOV`, `SUPPMAT` — real missingness codes with real
meanings, already handled in the `na_values` lists in weeks 6–8. Teaching those
in week 1 sets up the practicals and teaches something the toy example can't:
missing values are often a *decision* someone made, not an absence.

**Small fixes while you're in there**

- Typos: "descibe" (line ~110), "encodeded" (~95), "longtitude" (~70).
- `_website.yml` lines 52 and 54 say **"Explanatory** Data Analysis #1 / #2" —
  should be "Exploratory". This is visible in the live site navigation.
- The interval-scale example about longitude and latitude ("the coordinate of 8
  is twice as far as that of 4?") is muddled — longitude has an arbitrary zero
  by convention, which is the point, but the slide doesn't quite land it.

---

## 7. Suggested priorities

If you only do three things:

1. **Resolve the GLM promise** in the assessment brief — either teach one or
   stop offering it. This is a live fairness issue, not a nice-to-have.
2. **Move week 1 onto the schools data** (in hand), and while doing it, fold in
   missing-data codes and rates-vs-counts, which cost a slide each.
3. **Add confidence intervals to week 3** — cheapest large win for the quality
   of what students write.

Then, if there's appetite: unify the slide theme, thin the duplicated
descriptive-statistics material, and give week 10 the same depth as week 9.

---

*One thing I couldn't act on: your message included "for example, ." with the
example missing, so if there was a specific gap you had in mind, it isn't
covered above unless I happened to land on it independently.*
