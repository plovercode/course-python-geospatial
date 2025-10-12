---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.17.3
kernelspec:
  display_name: Python 3 (ipykernel)
  language: python
  name: python3
---

<p><font size="6"><b>Visualization - Matplotlib</b></font></p>

> *DS Python for GIS and Geoscience*  
> *September, 2025*
>
> *© 2025, Joris Van den Bossche and Stijn Van Hoey. Licensed under [CC BY 4.0 Creative Commons](http://creativecommons.org/licenses/by/4.0/)*

---

+++

# Matplotlib

+++

[Matplotlib](http://matplotlib.org/) is a Python package used widely throughout the scientific Python community to produce high quality 2D publication graphics. It transparently supports a wide range of output formats including PNG (and other raster formats), PostScript/EPS, PDF and SVG and has interfaces for all of the major desktop GUI (graphical user interface) toolkits. It is a great package with lots of options.

However, matplotlib is...

> The 800-pound gorilla — and like most 800-pound gorillas, this one should probably be avoided unless you genuinely need its power, e.g., to make a **custom plot** or produce a **publication-ready** graphic.

> (As we’ll see, when it comes to statistical visualization, the preferred tack might be: “do as much as you easily can in your convenience layer of choice [nvdr e.g. directly from Pandas, or with seaborn], and then use matplotlib for the rest.”)

(quote used from [this](https://dansaber.wordpress.com/2016/10/02/a-dramatic-tour-through-pythons-data-visualization-landscape-including-ggplot-and-altair/) blogpost)

And that's we mostly did, just use the `.plot` function of Pandas. So, why do we learn matplotlib? Well, for the *...then use matplotlib for the rest.*; at some point, somehow!

Matplotlib comes with a convenience sub-package called ``pyplot`` which, for consistency with the wider matplotlib community, should always be imported as ``plt``:

```{code-cell} ipython3
import numpy as np
import matplotlib.pyplot as plt
```

## - dry stuff - The matplotlib `Figure`, `Axes` and `Axis`

At the heart of **every** plot is the figure object. The "Figure" object is the top level concept which can be drawn to one of the many output formats, or simply just to screen. Any object which can be drawn in this way is known as an "Artist" in matplotlib.

Lets create our first artist using pyplot, and then show it:

```{code-cell} ipython3
fig = plt.figure()
plt.show()
```

On its own, drawing the figure artist is uninteresting and will result in an empty piece of paper (that's why we didn't see anything above).

By far the most useful artist in matplotlib is the **Axes** artist. The Axes artist represents the "data space" of a typical plot, a rectangular axes (the most common, but not always the case, e.g. polar plots) will have 2 (confusingly named) **Axis** artists with tick labels and tick marks.

![](../img/matplotlib_fundamentals.png)

There is no limit on the number of Axes artists which can exist on a Figure artist. Let's go ahead and create a figure with a single Axes artist, and show it using pyplot:

```{code-cell} ipython3
ax = plt.axes()
```

Matplotlib's ``pyplot`` module makes the process of creating graphics easier by allowing us to skip some of the tedious Artist construction. For example, we did not need to manually create the Figure artist with ``plt.figure`` because it was implicit that we needed a figure when we created the Axes artist.

Under the hood matplotlib still had to create a Figure artist, its just we didn't need to capture it into a variable.

+++

## - essential stuff - Matplotlib works 'Object Oriented'

+++

Objects have characteristics (attributes) and can do things (methods).

+++

Some example data:

```{code-cell} ipython3
x = np.linspace(0, 5, 10)
y = x ** 10
```

Create a `Figure` and `Axes` object to plot data. Use the `Axes` object to plot x and y data.

```{code-cell} ipython3
fig, ax = plt.subplots()
ax.plot(x, y, '-')
```

Using the existing objects, further adjustment can be done using the existing methods, e.g.

```{code-cell} ipython3
from matplotlib import ticker

fig, ax = plt.subplots()
ax.plot(x, y, '-')

# Add a title
ax.set_title("My data")

# Add custom formatting instead of the default scientific formatting:
ax.yaxis.set_major_formatter(ticker.FormatStrFormatter("%.1f"))
```

By using the Matplotlib objects, we now have **full control** of where the plot axes are placed, and we can add more than one axis to the Figure:

```{code-cell} ipython3
fig, ax1 = plt.subplots()
ax1.plot(x, y, '-')
ax1.set_ylabel('y')

ax2 = fig.add_axes([0.2, 0.5, 0.4, 0.3]) # inset axes
ax2.set_xlabel('x')
ax2.plot(x, y*2, 'r-')
```

<div class="alert alert-info" style="font-size:18px">

<b>REMEMBER</b>:

 <ul>
  <li>Use the <b>object oriented</b> power of Matplotlib!</li>
  <li>Get yourself used to writing <code>fig, ax = plt.subplots()</code></li>
</ul>
</div>

```{code-cell} ipython3
fig, ax = plt.subplots()
ax.plot(x, y, '-')
# ...
```

## An small cheat-sheet reference for some common elements

```{code-cell} ipython3
x = np.linspace(-1, 0, 100)

fig, ax  = plt.subplots(figsize=(10, 7))

# Adjust the created axes so that its topmost extent is 0.8 of the figure.
fig.subplots_adjust(top=0.9)

ax.plot(x, x**2, color='0.4', label='power 2')
ax.plot(x, x**3, color='0.8', linestyle='--', label='power 3')

ax.vlines(x=-0.75, ymin=0., ymax=0.8, color='0.4', linestyle='-.')  # vertical dotted line within range [0, 0.8]
ax.fill_between(x=x, y1=x**2, y2=1.1*x**2, color='0.85')   # color fill between the two exponential functions

ax.axhline(y=0.1, color='0.4', linestyle='-.')   # ax-wide horizontal dotted line 
ax.axhspan(ymin=0.65, ymax=0.75, color='0.95')   # ax-wide horizontal filled space

fig.suptitle('Figure title', fontsize=18, 
             fontweight='bold')
ax.set_title('Axes title', fontsize=16)

ax.set_xlabel('The X axis')
ax.set_ylabel('The Y axis $y=f(x)$', fontsize=16)

ax.set_xlim(-1.0, 1.1)
ax.set_ylim(-0.1, 1.)

ax.text(0.5, 0.2, 'Text centered at (0.5, 0.2)\nin data coordinates.',
        horizontalalignment='center', fontsize=14)

ax.text(0.5, 0.5, 'Text centered at (0.5, 0.5)\nin relative Axes coordinates.',
        horizontalalignment='center', fontsize=14, 
        transform=ax.transAxes, color='grey')

ax.annotate('Text pointing at (0.0, 0.75)', xy=(0.0, 0.75), xycoords="data",
            xytext=(20, 40), textcoords="offset points",
            horizontalalignment='left', fontsize=14,
            arrowprops=dict(facecolor='black', shrink=0.05, width=1))

ax.legend(loc='lower right', frameon=True, ncol=2, fontsize=14)
```

Adjusting specific parts of a plot is a matter of accessing the correct element of the plot:

<img src="https://matplotlib.org/stable/_images/anatomy.png" width="800"/>

+++

For more information on legend positioning, check [this post](http://stackoverflow.com/questions/4700614/how-to-put-the-legend-out-of-the-plot) on stackoverflow!

+++

## I do not like the style...

+++

**...understandable**

+++

Matplotlib had a bad reputation in terms of its default styling as figures created with earlier versions of Matplotlib were very Matlab-lookalike and mostly not really catchy. 

Since Matplotlib 2.0, this has changed: https://matplotlib.org/users/dflt_style_changes.html!

However...
> *Des goûts et des couleurs, on ne discute pas...*

(check [this link](https://fr.wiktionary.org/wiki/des_go%C3%BBts_et_des_couleurs,_on_ne_discute_pas) if you're not french-speaking)

To account different tastes, Matplotlib provides a number of styles that can be used to quickly change a number of settings:

```{code-cell} ipython3
plt.style.available
```

```{code-cell} ipython3
x = np.linspace(0, 10)

with plt.style.context('seaborn-v0_8-colorblind'): 
    fig, ax = plt.subplots()
    ax.plot(x, np.sin(x) + x + np.random.randn(50))
    ax.plot(x, np.sin(x) + 0.5 * x + np.random.randn(50))
    ax.plot(x, np.sin(x) + 2 * x + np.random.randn(50))
```

We should not start discussing about colors and styles, just pick **your favorite style**!

```{code-cell} ipython3
plt.style.use('seaborn-v0_8-whitegrid')
```

or go all the way and define your own custom style, see the [official documentation](https://matplotlib.org/3.1.1/tutorials/introductory/customizing.html) or [this tutorial](https://colcarroll.github.io/yourplotlib/#/).

+++

<div class="alert alert-info">

<b>REMEMBER</b>:

 <ul>
  <li>If you just want <b>quickly a good-looking plot</b>, use one of the available styles (<code>plt.style.use('...')</code>)</li>
  <li>Otherwise, the object-oriented way of working makes it possible to change everything!</li>
</ul>
</div>

+++

## Interaction with Pandas/xarray

+++

The default plotting of Pandas/xarray relies on Matplotlib. Let's use a Pandas DataFrame as an example

```{code-cell} ipython3
import pandas as pd
```

```{code-cell} ipython3
flowdata = pd.read_csv('data/vmm_flowdata.csv', 
                       index_col='Time', 
                       parse_dates=True)
```

```{code-cell} ipython3
flowdata.head()
```

### From Pandas/xarray to Matplotlib

+++

Under the hood, Pandas creates an Matplotlib Figure with an Axes object. The `Axis` object(s) returned can be further adjusted:

```{code-cell} ipython3
ax = flowdata.plot()
ax.set_title('discharge [$m^3/s$]');
```

Pandas/xarray provide a number of convenience options as keyword parameters:

```{code-cell} ipython3
axs = flowdata.plot(subplots=True, sharex=True,
                    figsize=(16, 8), colormap='viridis', # Dark2
                    fontsize=15, rot=0)
axs[0].set_title('discharge [$m^3/s$]');
```

### From Matplotlib to Pandas/xarray

+++

Starting from 'empty' Matplotlib objects, we can tell Pandas/xarray to use these to plot new data on:

```{code-cell} ipython3
fig, (ax0, ax1) = plt.subplots(2, 1) #prepare a Matplotlib figure

flowdata.plot(ax=ax0) # use Pandas for the plotting
```

```{code-cell} ipython3
fig, (ax0, ax1) = plt.subplots(2, 1, figsize=(16, 6)) #provide with matplotlib 2 axis

flowdata[["L06_347", "LS06_347"]].plot(ax=ax0) # plot the two timeseries of the same location on the first plot
flowdata["LS06_348"].plot(ax=ax1, color='0.2') # plot the other station on the second plot

# further adapt with matplotlib
ax0.set_ylabel("L06_347")
ax1.set_ylabel("LS06_348")
ax1.legend()
```

<div class="alert alert-info" style="font-size:18px">

**Remember** 

`fig.savefig()` to save your Figure object!

</div>

+++

# Need more matplotlib inspiration?

+++

<div class="alert alert-info">

 <b>Remember</b>: 

* You can do anything with matplotlib, but at a cost... <a href="http://stackoverflow.com/questions/tagged/matplotlib">stackoverflow</a>
* The preformatting of Pandas provides mostly enough flexibility for quick analysis and draft reporting. It is not for paper-proof figures or customization

If you take the time to make your perfect/spot-on/greatest-ever matplotlib-figure: Make it a <b>reusable function</b>!

</div>

+++

For more in-depth material:
* http://www.labri.fr/perso/nrougier/teaching/matplotlib/
* notebooks in matplotlib section: http://nbviewer.jupyter.org/github/jakevdp/PythonDataScienceHandbook/blob/master/notebooks/Index.ipynb#4.-Visualization-with-Matplotlib
* main reference: [matplotlib homepage](http://matplotlib.org/)

+++

<div class="alert alert-info" style="font-size:18px">

**Galleries!**

Galleries are great to get inspiration, see the plot you want, and check the code how it is created:
    
* [matplotlib gallery](http://matplotlib.org/gallery.html) is an important resource to start from
* [seaborn gallery](https://seaborn.pydata.org/examples/index.html)
* The Python Graph Gallery (https://python-graph-gallery.com/)

</div>
